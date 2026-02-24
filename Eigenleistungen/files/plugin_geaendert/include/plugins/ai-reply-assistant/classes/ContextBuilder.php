<?php
/**
 * AI Reply Assistant — Context Builder
 *
 * Assembles the full prompt payload for LLM chat completion, including:
 *   - System prompt (with configurable language)
 *   - Ticket metadata
 *   - Conversation history (last N messages, PII-redacted)
 *   - Optional multimodal image attachments
 *   - Knowledge base content (Mini-KB + osTicket KB + Canned Responses)
 *   - Sensitive data warning flag
 *
 * @package AiReplyAssistant
 */

class AiReplyContextBuilder {

    /** Default number of images forwarded in multimodal mode */
    const DEFAULT_MAX_IMAGES = 3;

    /** Default per-image byte limit (2 MiB) */
    const DEFAULT_MAX_IMAGE_BYTES = 2097152;

    /** Hard limit to avoid oversized inline payloads */
    const MAX_TOTAL_IMAGE_BYTES = 12582912; // 12 MiB

    /** @var PluginConfig */
    private $config;

    /** @var AiReplyPiiRedactor */
    private $redactor;

    /** @var AiReplyKbRetriever */
    private $kbRetriever;

    /**
     * @param PluginConfig $config
     */
    public function __construct(PluginConfig $config) {
        $this->config      = $config;
        $this->redactor    = new AiReplyPiiRedactor($config);
        $this->kbRetriever = new AiReplyKbRetriever($config);
    }

    /**
     * Build the full prompt payload for the configured LLM.
     *
     * @param  Ticket      $ticket       The ticket being processed
     * @param  ThreadEntry $entry        The triggering user message
     * @param  array       $gatingResult Result from GatingLogic (contains sensitive_data flags)
     * @return array {
     *     system_prompt: string,
     *     user_message: string,
     *     user_images: array,
     *     prompt_text: string   (combined system + user for hashing)
     * }
     */
    public function build(Ticket $ticket, ThreadEntry $entry, array $gatingResult) {
        $systemPrompt = $this->buildSystemPrompt($gatingResult);
        $userPayload  = $this->buildUserMessagePayload($ticket, $entry, $gatingResult);
        $userMessage  = $userPayload['user_message'];

        return array(
            'system_prompt' => $systemPrompt,
            'user_message'  => $userMessage,
            'user_images'   => $userPayload['user_images'],
            'prompt_text'   => $systemPrompt . "\n\n" . $userMessage,
        );
    }

    /**
     * Build the system prompt with rules and output format.
     *
     * @param  array $gatingResult
     * @return string
     */
    private function buildSystemPrompt(array $gatingResult) {
        $language = $this->config->get('response_language') ?: 'Serbian (ekavica, Latin script)';

        $sensitiveWarning = '';
        if (!empty($gatingResult['sensitive_data_found'])) {
            $sensitiveWarning = "\nSecurity note: The customer has shared sensitive data (flagged in context). "
                . "Remind them NOT to share such information via ticket and suggest a secure alternative "
                . "(e.g., in-person verification, secure portal).";
        }

        $prompt = <<<SYSTEM
You are an L1 support agent assistant for a helpdesk system.

RULES:
1. Respond ONLY in {$language}.
2. Use ONLY the information provided in the ticket context and knowledge base below.
3. Do NOT invent information, URLs, phone numbers, or procedures not present in the context.
4. NEVER ask the customer for passwords, credit card numbers, JMBG, or other sensitive personal data.
5. If you do not have enough information to provide a helpful answer, set "need_more_info" to true and list up to 3 specific, professional questions in the "questions" array.
6. Keep your tone professional, concise, and clear.
7. If the customer has shared sensitive data (flagged below), remind them not to share such information and suggest a secure alternative.
8. If the KB context contains lines starting with "Reference URL:", include a final section in reply_body:
   Sources:
   - <exact URL used>
9. Never invent source URLs; only use URLs that appear in the provided context.
10. If image attachments are provided in the request, use their visual evidence when relevant and mention that you used attachment evidence.{$sensitiveWarning}

OUTPUT FORMAT:
You MUST respond with a valid JSON object with exactly this structure:
{
  "reply_subject": "Short subject line for the response",
  "reply_body": "Full response text. Use line breaks for readability.",
  "need_more_info": false,
  "questions": [],
  "suggested_tags": ["tag1", "tag2"],
  "confidence": 0.85
}

FIELD RULES:
- reply_subject: A brief, relevant subject line (max 100 chars)
- reply_body: The draft response. Professional, helpful, concise. May include numbered steps.
  If "Reference URL" values are present in context, append the "Sources:" section at the end.
- need_more_info: true if the ticket lacks details for a proper answer
- questions: Array of 0-3 clarifying questions (only when need_more_info=true)
- suggested_tags: 0-3 tags that categorize this ticket (e.g., "password-reset", "network")
- confidence: Float 0.0-1.0 — your confidence that reply_body fully addresses the issue
SYSTEM;

        return $prompt;
    }

    /**
     * Build the user payload containing ticket text context and optional images.
     *
     * @param  Ticket      $ticket
     * @param  ThreadEntry $entry
     * @param  array       $gatingResult
     * @return array {
     *    user_message: string,
     *    user_images: array
     * }
     */
    private function buildUserMessagePayload(Ticket $ticket, ThreadEntry $entry, array $gatingResult) {
        $parts = array();
        $userImages = array();

        // Section 1: Ticket metadata
        $parts[] = $this->buildMetadataSection($ticket);

        // Section 2: Sensitive data flag
        $parts[] = $this->buildSensitiveSection($gatingResult);

        // Section 3: Conversation history
        $parts[] = $this->buildConversationSection($ticket);

        // Section 4: Attachment summary + optional multimodal images
        $parts[] = $this->buildAttachmentSection($entry, $userImages);

        // Section 5: Knowledge base
        $parts[] = $this->buildKnowledgeSection($ticket, $entry);

        return array(
            'user_message' => implode("\n\n", $parts) . "\n\n=== END CONTEXT ===",
            'user_images'  => $userImages,
        );
    }

    /**
     * Build ticket metadata section.
     *
     * @param  Ticket $ticket
     * @return string
     */
    private function buildMetadataSection(Ticket $ticket) {
        $userName = 'Customer';
        try {
            $user = $ticket->getUser();
            if ($user) {
                $name = $user->getFirstName();
                if (empty($name)) {
                    $name = $user->getName();
                }
                if (!empty($name)) {
                    // Redact the name (replace with first name or generic)
                    list($redactedName, ) = $this->redactor->redact((string) $name);
                    $userName = $redactedName;
                }
            }
        } catch (\Exception $e) {
            // Keep default "Customer"
        }

        // Redact subject
        list($subject, ) = $this->redactor->redact($ticket->getSubject() ?: '(no subject)');

        // Get department, priority, status names safely
        $deptName = 'Unknown';
        try {
            $dept = $ticket->getDept();
            if ($dept) {
                $deptName = $dept->getName();
            }
        } catch (\Exception $e) {}

        $priorityName = 'Normal';
        try {
            $priority = $ticket->getPriority();
            if ($priority) {
                $priorityName = $priority->getDesc();
            }
        } catch (\Exception $e) {}

        $statusName = 'Open';
        try {
            $status = $ticket->getStatus();
            if ($status) {
                $statusName = $status->getName();
            }
        } catch (\Exception $e) {}

        return "=== TICKET CONTEXT ===\n"
             . "Ticket ID: " . $ticket->getId() . "\n"
             . "Ticket Number: " . $ticket->getNumber() . "\n"
             . "Subject: " . $subject . "\n"
             . "Department: " . $deptName . "\n"
             . "Priority: " . $priorityName . "\n"
             . "Status: " . $statusName . "\n"
             . "Customer: " . $userName;
    }

    /**
     * Build sensitive data warning section.
     *
     * @param  array $gatingResult
     * @return string
     */
    private function buildSensitiveSection(array $gatingResult) {
        $section = "=== SENSITIVE DATA FLAG ===\n";

        if (!empty($gatingResult['sensitive_data_found'])) {
            $types = implode(', ', $gatingResult['sensitive_types']);
            $section .= "WARNING: Customer message contains sensitive data types: {$types}.\n"
                      . "Do NOT request any sensitive information. Suggest secure alternatives.";
        } else {
            $section .= "None detected.";
        }

        return $section;
    }

    /**
     * Build conversation history section from thread entries.
     *
     * @param  Ticket $ticket
     * @return string
     */
    private function buildConversationSection(Ticket $ticket) {
        $maxMessages  = max(1, (int) $this->config->get('context_message_count') ?: 6);
        $maxMsgLength = max(100, (int) $this->config->get('max_message_length') ?: 2000);

        $section = "=== CONVERSATION HISTORY (last {$maxMessages} messages) ===";

        try {
            $thread = $ticket->getThread();
            if (!$thread) {
                return $section . "\n(No thread available)";
            }

            // Get thread entries — messages (M) and responses (R), skip notes (N)
            $entries = $thread->getEntries(array(
                'order' => 'DESC',
                'limit' => $maxMessages,
            ));

            if (!$entries) {
                return $section . "\n(No messages)";
            }

            // Collect entries (they come DESC, we need ASC for chronological order)
            $messages = array();
            foreach ($entries as $e) {
                $type = $e->getType();
                // Only include customer messages (M) and agent replies (R)
                if ($type !== 'M' && $type !== 'R') {
                    continue;
                }

                $role = ($type === 'M') ? 'Customer' : 'Agent';

                // Get message body text
                $body = $e->getBody();
                if ($body instanceof ThreadEntryBody) {
                    $text = $body->getClean();
                    if (empty($text)) {
                        $text = strip_tags((string) $body->display('html'));
                    }
                } else {
                    $text = strip_tags((string) $body);
                }

                $text = html_entity_decode(trim($text), ENT_QUOTES, 'UTF-8');

                // Truncate long messages
                if (mb_strlen($text) > $maxMsgLength) {
                    $text = mb_substr($text, 0, $maxMsgLength) . '... (truncated)';
                }

                // PII redaction
                list($text, ) = $this->redactor->redact($text);

                // Get timestamp
                $created = $e->getCreateDate();
                if ($created instanceof DateTime) {
                    $timestamp = $created->format('Y-m-d H:i');
                } else {
                    $timestamp = (string) $created;
                }

                $messages[] = "\n[{$role}] ({$timestamp}):\n{$text}";
            }

            // Reverse to chronological order (was DESC)
            $messages = array_reverse($messages);

            if (empty($messages)) {
                return $section . "\n(No messages)";
            }

            return $section . implode("\n", $messages);

        } catch (\Exception $e) {
            return $section . "\n(Error retrieving conversation history)";
        }
    }

    /**
     * Build attachment section and collect image payloads for multimodal models.
     *
     * @param  ThreadEntry $entry
     * @param  array       $userImages (output)
     * @return string
     */
    private function buildAttachmentSection(ThreadEntry $entry, array &$userImages) {
        $section = array("=== ATTACHMENTS ===");
        $policy = mb_strtolower(trim((string) ($this->config->get('attachment_policy') ?: 'ignore')));
        $analyzeImages = ($policy === 'analyze_images');

        $attachments = array();
        try {
            $raw = $entry->getAttachments();
            if ($raw && (is_array($raw) || $raw instanceof Traversable)) {
                foreach ($raw as $a) {
                    $attachments[] = $a;
                }
            } elseif (is_object($raw) && method_exists($raw, 'getAll')) {
                $list = $raw->getAll();
                if (is_array($list) || $list instanceof Traversable) {
                    foreach ($list as $a) {
                        $attachments[] = $a;
                    }
                }
            }
        } catch (\Exception $e) {
            return "=== ATTACHMENTS ===\n(Error retrieving attachments)";
        }

        if (empty($attachments)) {
            return "=== ATTACHMENTS ===\nNone";
        }

        $section[] = "Policy: " . $policy;
        $section[] = "Total attachments: " . count($attachments);

        if (!$analyzeImages) {
            $section[] = "Image analysis disabled by policy.";
            return implode("\n", $section);
        }

        $maxImages = $this->readIntConfig(
            'attachment_max_images',
            self::DEFAULT_MAX_IMAGES,
            1,
            6
        );
        $maxImageBytes = $this->readIntConfig(
            'attachment_max_image_bytes',
            self::DEFAULT_MAX_IMAGE_BYTES,
            131072,
            10485760
        );
        $totalImageBytes = 0;

        $included = array();
        $skipped = array();

        foreach ($attachments as $attachment) {
            $file = $this->resolveAttachmentFile($attachment);
            if (!$file) {
                $skipped[] = 'unknown-file (cannot resolve file object)';
                continue;
            }

            $filename = $this->resolveAttachmentFilename($attachment, $file);
            $mimeType = $this->resolveAttachmentMimeType($file);
            $size = $this->resolveAttachmentSize($file);

            if (!$this->isSupportedImageMime($mimeType)) {
                $skipped[] = $filename . ' (' . ($mimeType ?: 'unknown mime') . ', non-image or unsupported)';
                continue;
            }

            if (count($userImages) >= $maxImages) {
                $skipped[] = $filename . ' (image limit reached)';
                continue;
            }

            if ($size > 0 && $size > $maxImageBytes) {
                $skipped[] = $filename . ' (' . $this->formatBytes($size) . ', exceeds per-image limit)';
                continue;
            }

            try {
                $binary = $file->getData();
            } catch (\Exception $e) {
                $binary = '';
            }

            if (!is_string($binary) || $binary === '') {
                $skipped[] = $filename . ' (empty or unreadable)';
                continue;
            }

            $actualBytes = strlen($binary);
            if ($actualBytes > $maxImageBytes) {
                $skipped[] = $filename . ' (' . $this->formatBytes($actualBytes) . ', exceeds per-image limit)';
                continue;
            }

            if (($totalImageBytes + $actualBytes) > self::MAX_TOTAL_IMAGE_BYTES) {
                $skipped[] = $filename . ' (total image payload limit reached)';
                continue;
            }

            $dataUrl = 'data:' . $mimeType . ';base64,' . base64_encode($binary);
            $userImages[] = array(
                'filename' => $filename,
                'mime_type' => $mimeType,
                'size_bytes' => $actualBytes,
                'data_url' => $dataUrl,
            );
            $totalImageBytes += $actualBytes;
            $included[] = $filename . ' (' . $mimeType . ', ' . $this->formatBytes($actualBytes) . ')';
        }

        $section[] = "Images sent to LLM: " . count($included);
        if (!empty($included)) {
            foreach ($included as $line) {
                $section[] = '- ' . $line;
            }
        }

        if (!empty($skipped)) {
            $section[] = "Skipped attachments:";
            $maxSkipped = 12;
            $shown = 0;
            foreach ($skipped as $line) {
                $section[] = '- ' . $line;
                $shown++;
                if ($shown >= $maxSkipped) {
                    $remaining = count($skipped) - $shown;
                    if ($remaining > 0) {
                        $section[] = '- ... and ' . $remaining . ' more';
                    }
                    break;
                }
            }
        }

        return implode("\n", $section);
    }

    /**
     * Resolve attachment file object.
     *
     * @param  mixed $attachment
     * @return mixed|null
     */
    private function resolveAttachmentFile($attachment) {
        if (is_object($attachment) && method_exists($attachment, 'getFile')) {
            return $attachment->getFile();
        }
        if (is_object($attachment) && isset($attachment->file)) {
            return $attachment->file;
        }
        return null;
    }

    /**
     * Resolve attachment display filename.
     *
     * @param  mixed $attachment
     * @param  mixed $file
     * @return string
     */
    private function resolveAttachmentFilename($attachment, $file) {
        if (is_object($attachment) && method_exists($attachment, 'getFilename')) {
            $name = (string) $attachment->getFilename();
            if (!empty($name)) {
                return $name;
            }
        }
        if (is_object($file) && method_exists($file, 'getName')) {
            $name = (string) $file->getName();
            if (!empty($name)) {
                return $name;
            }
        }
        return 'attachment';
    }

    /**
     * Resolve attachment mime type.
     *
     * @param  mixed $file
     * @return string
     */
    private function resolveAttachmentMimeType($file) {
        $mimeType = '';
        if (is_object($file) && method_exists($file, 'getMimeType')) {
            $mimeType = (string) $file->getMimeType();
        } elseif (is_object($file) && method_exists($file, 'getType')) {
            $mimeType = (string) $file->getType();
        }

        return mb_strtolower(trim($mimeType));
    }

    /**
     * Resolve attachment byte size if available.
     *
     * @param  mixed $file
     * @return int
     */
    private function resolveAttachmentSize($file) {
        if (is_object($file) && method_exists($file, 'getSize')) {
            return (int) $file->getSize();
        }
        return 0;
    }

    /**
     * Supported image MIME types for multimodal input.
     *
     * @param  string $mimeType
     * @return bool
     */
    private function isSupportedImageMime($mimeType) {
        $allowed = array(
            'image/png',
            'image/jpeg',
            'image/jpg',
            'image/webp',
            'image/gif',
            'image/bmp',
        );
        return in_array($mimeType, $allowed, true);
    }

    /**
     * Read integer config with min/max clamping.
     *
     * @param  string $key
     * @param  int    $default
     * @param  int    $min
     * @param  int    $max
     * @return int
     */
    private function readIntConfig($key, $default, $min, $max) {
        $raw = $this->config->get($key);
        if ($raw === null || $raw === '') {
            $raw = $default;
        }
        $value = (int) $raw;
        if ($value < $min) {
            $value = $min;
        } elseif ($value > $max) {
            $value = $max;
        }
        return $value;
    }

    /**
     * Human-readable byte formatter.
     *
     * @param  int $bytes
     * @return string
     */
    private function formatBytes($bytes) {
        $bytes = max(0, (int) $bytes);
        if ($bytes < 1024) {
            return $bytes . ' B';
        }
        if ($bytes < 1048576) {
            return round($bytes / 1024, 1) . ' KB';
        }
        return round($bytes / 1048576, 2) . ' MB';
    }

    /**
     * Build knowledge base section.
     *
     * Combines: static Mini-KB + osTicket FAQ + Canned Responses.
     *
     * @param  Ticket      $ticket
     * @param  ThreadEntry $entry
     * @return string
     */
    private function buildKnowledgeSection(Ticket $ticket, ThreadEntry $entry) {
        $kbContent = $this->kbRetriever->retrieve($ticket, $entry);

        if (empty(trim($kbContent))) {
            return "=== KNOWLEDGE BASE ===\nNo knowledge base content available.";
        }

        return $kbContent;
    }
}

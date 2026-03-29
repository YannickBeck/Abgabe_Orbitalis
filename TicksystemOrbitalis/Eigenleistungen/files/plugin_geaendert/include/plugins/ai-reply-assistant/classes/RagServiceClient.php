<?php
/**
 * AI Reply Assistant — RAG Service Client
 *
 * Calls the local KB RAG HTTP service and returns normalized retrieval hits.
 */

class AiReplyRagException extends \Exception {}

class AiReplyRagServiceClient {

    /** @var PluginConfig */
    private $config;

    /** Default local RAG endpoint base URL */
    const DEFAULT_RAG_URL = 'http://127.0.0.1:8099';

    /**
     * @param PluginConfig $config
     */
    public function __construct(PluginConfig $config) {
        $this->config = $config;
    }

    /**
     * Query RAG service for relevant KB snippets.
     *
     * @param  Ticket      $ticket
     * @param  ThreadEntry $entry
     * @return array       Array of {question, answer_snippet, score, category, topic}
     * @throws AiReplyRagException on strict mode service failures
     */
    public function query(Ticket $ticket, ThreadEntry $entry) {
        $baseUrl = trim($this->config->get('rag_service_url') ?: self::DEFAULT_RAG_URL);
        $baseUrl = rtrim($baseUrl, '/');
        $endpoint = $baseUrl . '/query';

        $timeout = (int) ($this->config->get('rag_timeout_seconds') ?: 10);
        $timeout = max(2, min(60, $timeout));

        $topK = (int) ($this->config->get('rag_top_k') ?: 5);
        $topK = max(1, min(20, $topK));

        $payload = array(
            'subject'        => (string) ($ticket->getSubject() ?: ''),
            'latest_message' => $this->getEntryText($entry),
            'top_k'          => $topK,
        );

        $json = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        if ($json === false) {
            return $this->handleFailure('Failed to encode RAG payload: ' . json_last_error_msg());
        }

        $ch = curl_init();
        curl_setopt_array($ch, array(
            CURLOPT_URL            => $endpoint,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $json,
            CURLOPT_HTTPHEADER     => array('Content-Type: application/json'),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => $timeout,
            CURLOPT_CONNECTTIMEOUT => min(5, $timeout),
        ));

        $body = curl_exec($ch);
        $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlErr = curl_errno($ch) ? curl_error($ch) : '';
        curl_close($ch);

        if (!empty($curlErr)) {
            return $this->handleFailure('RAG service cURL error: ' . $curlErr);
        }

        if ($httpCode !== 200) {
            $errBody = $this->truncate((string) $body, 250);
            return $this->handleFailure("RAG service HTTP {$httpCode}: {$errBody}");
        }

        $decoded = json_decode((string) $body, true);
        if (!is_array($decoded)) {
            return $this->handleFailure('RAG service returned invalid JSON.');
        }

        $rows = isset($decoded['results']) && is_array($decoded['results'])
            ? $decoded['results']
            : array();

        $normalized = array();
        foreach ($rows as $row) {
            if (!is_array($row)) {
                continue;
            }
            $question = trim((string) ($row['question'] ?? ''));
            $snippet  = trim((string) ($row['answer_snippet'] ?? ''));
            if (empty($question) && empty($snippet)) {
                continue;
            }
            $normalized[] = array(
                'question'       => $question,
                'answer_snippet' => $snippet,
                'score'          => (float) ($row['score'] ?? 0),
                'category'       => trim((string) ($row['category'] ?? '')),
                'topic'          => trim((string) ($row['topic'] ?? '')),
                'source_type'    => trim((string) ($row['source_type'] ?? '')),
                'faq_id'         => (int) ($row['faq_id'] ?? 0),
                'category_id'    => (int) ($row['category_id'] ?? 0),
                'category_url'   => trim((string) ($row['category_url'] ?? '')),
                'faq_url'        => trim((string) ($row['faq_url'] ?? '')),
                'reference_url'  => trim((string) ($row['reference_url'] ?? '')),
            );
        }

        return $normalized;
    }

    /**
     * Handle service failures according to configured fail mode.
     *
     * @param  string $message
     * @return array
     * @throws AiReplyRagException
     */
    private function handleFailure($message) {
        if ($this->isStrictMode()) {
            throw new AiReplyRagException($message);
        }

        error_log('[AI Reply Assistant] [WARN] ' . $message);
        return array();
    }

    /**
     * Strict mode is enforced for this deployment.
     *
     * @return bool
     */
    private function isStrictMode() {
        $mode = trim((string) ($this->config->get('rag_fail_mode') ?: 'strict'));
        return ($mode === 'strict' || empty($mode));
    }

    /**
     * Extract plain text from thread entry body.
     *
     * @param  ThreadEntry $entry
     * @return string
     */
    private function getEntryText(ThreadEntry $entry) {
        try {
            $body = $entry->getBody();
            if ($body instanceof ThreadEntryBody) {
                $text = $body->getClean();
                if (empty($text)) {
                    $text = strip_tags((string) $body->display('html'));
                }
            } else {
                $text = strip_tags((string) $body);
            }

            return html_entity_decode(trim((string) $text), ENT_QUOTES, 'UTF-8');
        } catch (\Exception $e) {
            return '';
        }
    }

    /**
     * Truncate large strings for safe logging.
     *
     * @param  string $value
     * @param  int    $length
     * @return string
     */
    private function truncate($value, $length = 250) {
        if (mb_strlen($value) <= $length) {
            return $value;
        }
        return mb_substr($value, 0, $length) . '...';
    }
}

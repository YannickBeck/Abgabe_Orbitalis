<?php
/**
 * AI Reply Assistant — LLM Client
 *
 * Handles HTTP communication with OpenAI-compatible Chat Completions APIs,
 * including local Ollama endpoints.
 *
 * Features:
 *   - Configurable endpoint, model, temperature, max_tokens
 *   - Optional Bearer auth (disabled by default for local Ollama)
 *   - Timeout and retry with exponential backoff
 *   - JSON response_format enforcement with compatibility fallback
 *   - Token usage tracking
 *
 * @package AiReplyAssistant
 */

class AiReplyOpenAiClient {

    /** Legacy fallback endpoint (original plugin behavior) */
    const DEFAULT_OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions';

    /** Base retry delay in seconds */
    const RETRY_DELAY_BASE = 2;

    /** HTTP status codes that should NOT be retried */
    const NO_RETRY_CODES = array(401, 403);

    /** @var PluginConfig */
    private $config;

    /**
     * @param PluginConfig $config
     */
    public function __construct(PluginConfig $config) {
        $this->config = $config;
    }

    /**
     * Send a chat completion request to the configured LLM endpoint.
     *
     * @param  string $systemPrompt  The system-level instructions
     * @param  string $userMessage   The user-level context payload
     * @param  string $model         Model name
     * @param  array  $userImages    Optional multimodal image payloads
     * @return array {
     *     success: bool,
     *     reply_text: string,
     *     prompt_tokens: int,
     *     completion_tokens: int,
     *     total_tokens: int,
     *     model: string,
     *     error: string|null,
     *     http_code: int
     * }
     */
    public function chatCompletion($systemPrompt, $userMessage, $model, array $userImages = array()) {
        $temperature = (float) ($this->config->get('openai_temperature') ?: 0.3);
        $maxTokens   = (int) ($this->config->get('openai_max_tokens') ?: 1500);
        $timeout     = (int) ($this->config->get('openai_timeout') ?: 180);
        $maxRetries  = $this->resolveRetryCount();

        // Clamp values
        $temperature = max(0.0, min(2.0, $temperature));
        $maxTokens   = max(100, min(4096, $maxTokens));
        $timeout     = max(5, min(600, $timeout));
        $maxRetries  = max(0, min(3, $maxRetries));

        $apiUrl = $this->resolveApiUrl();
        if (empty($apiUrl)) {
            return $this->errorResult('LLM endpoint is not configured.', 0);
        }

        list($headers, $headerError) = $this->buildHeaders();
        if ($headerError !== null) {
            return $this->errorResult($headerError, 0);
        }

        $payload = $this->buildPayload($systemPrompt, $userMessage, $model, true, $userImages);
        $jsonPayload = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        if ($jsonPayload === false) {
            return $this->errorResult('Failed to encode request payload: ' . json_last_error_msg(), 0);
        }

        // Retry loop
        $lastError = '';
        $lastCode  = 0;
        $didResponseFormatFallback = false;

        for ($attempt = 0; $attempt <= $maxRetries; $attempt++) {
            if ($attempt > 0) {
                $delay = self::RETRY_DELAY_BASE * pow(2, $attempt - 1);
                sleep($delay);
            }

            $result = $this->curlRequest($apiUrl, $jsonPayload, $headers, $timeout);

            // cURL-level error
            if ($result['curl_error']) {
                $lastError = 'cURL error: ' . $result['curl_error'];
                $lastCode  = 0;
                // Timeout retries typically repeat the same long-running failure on local LLMs.
                if (stripos($result['curl_error'], 'timed out') !== false) {
                    return $this->errorResult(
                        'LLM request timed out. Increase LLM Request Timeout in plugin settings.',
                        0
                    );
                }
                continue;
            }

            $httpCode = $result['http_code'];
            $lastCode = $httpCode;

            if ($httpCode === 200) {
                return $this->parseResponse($result['body'], $model);
            }

            // Some providers reject response_format; retry once without it.
            if (!$didResponseFormatFallback
                && $this->shouldRetryWithoutResponseFormat($httpCode, $result['body'])
            ) {
                $didResponseFormatFallback = true;

                $payloadNoFormat = $this->buildPayload($systemPrompt, $userMessage, $model, false, $userImages);
                $jsonPayloadNoFormat = json_encode(
                    $payloadNoFormat,
                    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
                );

                if ($jsonPayloadNoFormat !== false) {
                    $fallbackResult = $this->curlRequest($apiUrl, $jsonPayloadNoFormat, $headers, $timeout);

                    if ($fallbackResult['curl_error']) {
                        $lastError = 'cURL error: ' . $fallbackResult['curl_error'];
                        $lastCode  = 0;
                        continue;
                    }

                    $fallbackCode = (int) $fallbackResult['http_code'];
                    if ($fallbackCode === 200) {
                        return $this->parseResponse($fallbackResult['body'], $model);
                    }

                    $httpCode = $fallbackCode;
                    $lastCode = $fallbackCode;
                    $result   = $fallbackResult;
                }
            }

            // Non-retryable HTTP errors
            if (in_array($httpCode, self::NO_RETRY_CODES, true)
                || ($httpCode >= 400 && $httpCode < 500 && $httpCode !== 429)
            ) {
                $errBody = $this->extractApiError($result['body']);
                return $this->errorResult(
                    "LLM API error (HTTP {$httpCode}): {$errBody}",
                    $httpCode
                );
            }

            // 429 or 5xx -> retry
            $lastError = "LLM API error (HTTP {$httpCode}): " . $this->extractApiError($result['body']);
        }

        return $this->errorResult(
            "LLM request failed after " . ($maxRetries + 1) . " attempts. Last error: {$lastError}",
            $lastCode
        );
    }

    /**
     * Resolve retry count while preserving explicit "0" values.
     *
     * @return int
     */
    private function resolveRetryCount() {
        $retry = $this->config->get('llm_retry_count');
        if ($retry !== null && $retry !== '') {
            return (int) $retry;
        }

        $legacyRetry = $this->config->get('openai_retry_count');
        if ($legacyRetry !== null && $legacyRetry !== '') {
            return (int) $legacyRetry;
        }

        return 1;
    }

    /**
     * Build request payload for chat completions.
     *
     * @param string $systemPrompt
     * @param string $userMessage
     * @param string $model
     * @param bool   $includeResponseFormat
     * @param array  $userImages
     * @return array
     */
    private function buildPayload(
        $systemPrompt,
        $userMessage,
        $model,
        $includeResponseFormat = true,
        array $userImages = array()
    ) {
        $temperature = (float) ($this->config->get('openai_temperature') ?: 0.3);
        $maxTokens   = (int) ($this->config->get('openai_max_tokens') ?: 1500);

        $payload = array(
            'model'       => $model,
            'messages'    => array(
                array('role' => 'system', 'content' => $systemPrompt),
                array('role' => 'user',   'content' => $this->buildUserContent($userMessage, $userImages)),
            ),
            'temperature' => $temperature,
            'max_tokens'  => $maxTokens,
        );

        if ($includeResponseFormat) {
            $payload['response_format'] = array('type' => 'json_object');
        }

        return $payload;
    }

    /**
     * Build user content block (text-only or multimodal text+images).
     *
     * @param  string $userMessage
     * @param  array  $userImages
     * @return mixed
     */
    private function buildUserContent($userMessage, array $userImages) {
        if (empty($userImages)) {
            return $userMessage;
        }

        $content = array(
            array(
                'type' => 'text',
                'text' => (string) $userMessage,
            ),
        );

        foreach ($userImages as $img) {
            $url = isset($img['data_url']) ? trim((string) $img['data_url']) : '';
            if (empty($url)) {
                continue;
            }
            $content[] = array(
                'type' => 'image_url',
                'image_url' => array('url' => $url),
            );
        }

        // Fall back to text-only if all image inputs were invalid.
        if (count($content) === 1) {
            return $userMessage;
        }

        return $content;
    }

    /**
     * Build headers, including optional Authorization.
     *
     * @return array [headers, error|null]
     */
    private function buildHeaders() {
        $headers = array('Content-Type: application/json');
        $authEnabled = $this->isAuthEnabled();

        $apiKey = trim($this->config->get('llm_api_key') ?: '');
        if (empty($apiKey)) {
            $apiKey = trim($this->config->get('openai_api_key') ?: '');
        }

        if ($authEnabled) {
            if (empty($apiKey)) {
                return array($headers, 'LLM API key is required because authentication is enabled.');
            }
            $headers[] = 'Authorization: Bearer ' . $apiKey;
        }

        return array($headers, null);
    }

    /**
     * Decide whether Authorization should be sent.
     *
     * @return bool
     */
    private function isAuthEnabled() {
        $authFlag = $this->config->get('llm_auth_enabled');
        if ($authFlag !== null && $authFlag !== '') {
            return $this->toBool($authFlag);
        }

        // Legacy fallback: old setups with openai_api_key should still authenticate.
        $legacyKey = trim($this->config->get('openai_api_key') ?: '');
        return !empty($legacyKey);
    }

    /**
     * Resolve chat completions endpoint from LLM base URL setting.
     *
     * @return string
     */
    private function resolveApiUrl() {
        $base = trim($this->config->get('llm_base_url') ?: '');
        if (empty($base)) {
            return self::DEFAULT_OPENAI_API_URL;
        }

        $base = rtrim($base, '/');

        if (preg_match('#/v1/chat/completions$#i', $base)
            || preg_match('#/chat/completions$#i', $base)
        ) {
            return $base;
        }

        $parts = parse_url($base);
        $path = isset($parts['path']) ? $parts['path'] : '';

        if ($path === '' || $path === '/') {
            return $base . '/v1/chat/completions';
        }

        if (preg_match('#/v1$#i', $path)) {
            return $base . '/chat/completions';
        }

        return $base . '/chat/completions';
    }

    /**
     * Heuristic to retry once without response_format.
     *
     * @param int    $httpCode
     * @param string $body
     * @return bool
     */
    private function shouldRetryWithoutResponseFormat($httpCode, $body) {
        if ($httpCode < 400 || $httpCode >= 500 || $httpCode === 401 || $httpCode === 403) {
            return false;
        }

        $error = mb_strtolower($this->extractApiError($body));
        if (strpos($error, 'response_format') !== false
            || strpos($error, 'json_object') !== false
            || strpos($error, 'unknown field') !== false
            || strpos($error, 'unsupported') !== false
        ) {
            return true;
        }

        return in_array($httpCode, array(400, 404, 415, 422), true);
    }

    /**
     * Execute the curl request.
     *
     * @param  string $apiUrl
     * @param  string $jsonPayload
     * @param  array  $headers
     * @param  int    $timeout
     * @return array  { body: string, http_code: int, curl_error: string|null }
     */
    private function curlRequest($apiUrl, $jsonPayload, array $headers, $timeout) {
        $ch = curl_init();

        curl_setopt_array($ch, array(
            CURLOPT_URL            => $apiUrl,
            CURLOPT_POST           => true,
            CURLOPT_POSTFIELDS     => $jsonPayload,
            CURLOPT_HTTPHEADER     => $headers,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => $timeout,
            CURLOPT_CONNECTTIMEOUT => min(30, max(5, $timeout)),
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
        ));

        $body     = curl_exec($ch);
        $httpCode = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlErr  = curl_errno($ch) ? curl_error($ch) : null;

        curl_close($ch);

        return array(
            'body'       => ($body !== false) ? $body : '',
            'http_code'  => $httpCode,
            'curl_error' => $curlErr,
        );
    }

    /**
     * Parse a successful LLM response.
     *
     * @param  string $body  Raw JSON response body
     * @param  string $model Requested model name
     * @return array
     */
    private function parseResponse($body, $model) {
        $data = json_decode($body, true);
        if (!is_array($data)) {
            return $this->errorResult('Failed to decode LLM response JSON.', 200);
        }

        // Extract assistant reply text
        $replyText = '';
        if (isset($data['choices'][0]['message']['content'])) {
            $content = $data['choices'][0]['message']['content'];
            if (is_array($content)) {
                $parts = array();
                foreach ($content as $part) {
                    if (is_array($part) && isset($part['type']) && $part['type'] === 'text') {
                        $parts[] = (string) ($part['text'] ?? '');
                    }
                }
                $replyText = trim(implode("\n", $parts));
            } else {
                $replyText = $content;
            }
        } elseif (isset($data['choices'][0]['text'])) {
            $replyText = $data['choices'][0]['text'];
        }

        if (empty(trim($replyText))) {
            return $this->errorResult('LLM returned an empty response.', 200);
        }

        // Extract token usage
        $promptTokens     = isset($data['usage']['prompt_tokens']) ? (int) $data['usage']['prompt_tokens'] : 0;
        $completionTokens = isset($data['usage']['completion_tokens']) ? (int) $data['usage']['completion_tokens'] : 0;
        $totalTokens      = isset($data['usage']['total_tokens']) ? (int) $data['usage']['total_tokens'] : 0;

        $actualModel = isset($data['model']) ? $data['model'] : $model;

        return array(
            'success'           => true,
            'reply_text'        => $replyText,
            'prompt_tokens'     => $promptTokens,
            'completion_tokens' => $completionTokens,
            'total_tokens'      => $totalTokens,
            'model'             => $actualModel,
            'error'             => null,
            'http_code'         => 200,
        );
    }

    /**
     * Extract a human-readable error message from an API response.
     *
     * @param  string $body
     * @return string
     */
    private function extractApiError($body) {
        if (empty($body)) {
            return '(empty response body)';
        }

        $data = json_decode($body, true);
        if (is_array($data) && isset($data['error']['message'])) {
            return $data['error']['message'];
        }

        return mb_substr($body, 0, 300);
    }

    /**
     * Convert flexible config values to boolean.
     *
     * @param  mixed $value
     * @return bool
     */
    private function toBool($value) {
        if (is_bool($value)) {
            return $value;
        }
        if (is_int($value)) {
            return $value > 0;
        }
        $value = mb_strtolower(trim((string) $value));
        return in_array($value, array('1', 'true', 'yes', 'on'), true);
    }

    /**
     * Build a standardized error result.
     *
     * @param  string $message
     * @param  int    $httpCode
     * @return array
     */
    private function errorResult($message, $httpCode) {
        return array(
            'success'           => false,
            'reply_text'        => '',
            'prompt_tokens'     => 0,
            'completion_tokens' => 0,
            'total_tokens'      => 0,
            'model'             => '',
            'error'             => $message,
            'http_code'         => $httpCode,
        );
    }
}

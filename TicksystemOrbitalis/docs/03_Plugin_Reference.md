# 03 Plugin Reference

## Plugin Entry Points

- Bootstrap: `include/plugins/ai-reply-assistant/class.AiReplyPlugin.php:53`
- AJAX Route fuer manuellen Draft: `include/plugins/ai-reply-assistant/class.AiReplyPlugin.php:83`
- Manuelle Ausloesung pro Ticket: `include/plugins/ai-reply-assistant/classes/EventRouter.php:227`
- Hauptpipeline: `include/plugins/ai-reply-assistant/classes/EventRouter.php:383`

## Konfigurationsfelder (Admin UI)

Quelle: `include/plugins/ai-reply-assistant/config.php`.

### LLM Verbindung

| Key | Zweck | Default | Validierung |
|---|---|---|---|
| `llm_base_url` | Basis-URL der Chat API | `http://127.0.0.1:11434/v1` | URL, `http/https` (`config.php:377`) |
| `llm_auth_enabled` | Bearer Auth ein/aus | `false` | Bei `true` Key-Pflicht (`config.php:410`) |
| `llm_api_key` | Optionaler API Key | leer | Nur bei aktivierter Auth relevant |
| `llm_model` | Modellauswahl | `gemma3:4b` | Choice |
| `llm_model_custom` | Custom Modellname | leer | Ueberschreibt Dropdown |
| `openai_timeout` | HTTP Timeout in Sekunden | `180` | `5..300` (`config.php:424`) |
| `openai_retry_count` | Retry Anzahl | `0` | `0..3` (`config.php:425`) |

### RAG Retrieval

| Key | Zweck | Default | Validierung |
|---|---|---|---|
| `rag_enabled` | RAG Nutzung aktivieren | `false` | bool |
| `rag_service_url` | Base URL des RAG-Service | `http://127.0.0.1:8099` | URL, `http/https` (`config.php:388`) |
| `kb_reference_base_url` | Absolute Basis fuer Referenzlinks | leer | URL, optional (`config.php:399`) |
| `rag_timeout_seconds` | Timeout fuer `/query` | `10` | `2..60` (`config.php:431`) |
| `rag_top_k` | Anzahl Retrieval Treffer | `5` | `1..20` (`config.php:432`) |
| `rag_fail_mode` | Fehlerverhalten | `strict` | Wird erzwungen (`config.php:471`) |

### Kontext und Multimodal

| Key | Zweck | Default | Validierung |
|---|---|---|---|
| `context_message_count` | Historie-Laenge | `6` | `1..20` |
| `max_message_length` | Max Zeichen je Nachricht | `2000` | `100..10000` |
| `response_language` | Antwortsprache | `Deutsch` | Text |
| `mini_kb_content` | Statischer KB Block | leer | auf 4000 Zeichen gekuerzt (`config.php:474`) |
| `attachment_policy` | `analyze_images|ignore|deny` | `ignore` | Choice |
| `attachment_max_images` | Max Bilder pro Request | `3` | `1..6` (`config.php:429`) |
| `attachment_max_image_bytes` | Max Bytes pro Bild | `2097152` | `131072..10485760` (`config.php:430`) |

### Filters, Privacy, Limits (relevant)

- `allowed_departments`, `blocked_priorities`, `blocked_tags`, `allowed_statuses`
- `pii_redaction_enabled`, `redact_ip_addresses`
- `rate_limit_per_ticket_seconds`, `rate_limit_global_per_minute`

## Gating-Reihenfolge

Reihenfolge aus `include/plugins/ai-reply-assistant/classes/GatingLogic.php:46`:

1. Plugin enabled?
2. Nachricht leer?
3. Status erlaubt?
4. Department erlaubt?
5. Prioritaet blockiert?
6. Tag blockiert?
7. Attachment Policy blockiert?
8. Ticket Rate Limit
9. Global Rate Limit
10. Sensitive Data Detection (flaggt, blockiert nicht)

## Prompt-Vertrag

### Systemprompt Regeln

- Antwort nur in konfigurierter Sprache
- Nur Kontext/Fakten aus Ticket + KB
- Keine erfundenen Quellen
- Bei vorhandenen `Reference URL` -> `Sources:` Abschnitt anhaengen

Referenz: `include/plugins/ai-reply-assistant/classes/ContextBuilder.php:77`.

### Erwartetes JSON vom LLM

Parser erwartet strukturiertes JSON (u.a. `reply_subject`, `reply_body`, `confidence`).
Referenz: `include/plugins/ai-reply-assistant/classes/ResponseParser.php`.

## Fehlerpfade

Die Pipeline loggt explizite Fehlercodes:

- `rag_error`
- `llm_error`
- `parse_error`
- `note_write_error`
- `exception`

Siehe `include/plugins/ai-reply-assistant/classes/EventRouter.php:425` bis `include/plugins/ai-reply-assistant/classes/EventRouter.php:490`.

## LLM Transportlogik

- Endpoint-Aufbau aus `llm_base_url`: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:311`
- Optionaler Auth-Header: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:271`
- Timeout und Retry: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:57`
- `response_format` Fallback bei inkompatiblen APIs: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:346`

## Manueller Draft (UI)

- Button-Injektion in Ticketansicht: `include/plugins/ai-reply-assistant/classes/EventRouter.php`
- AJAX Endpoint: `scp/ajax.php/ai-reply/generate` (via Hook in Bootstrap)
- Ergebnis: Internal Note, kein Direktversand an Kunden.

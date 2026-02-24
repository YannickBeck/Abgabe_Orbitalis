# 06 Config and Env Matrix

## Ziel

Dieses Dokument listet alle betriebsrelevanten Parameter zentral.

## A) Plugin Konfiguration (`config.php`)

Quelle: `include/plugins/ai-reply-assistant/config.php`.

| Key | Typ | Default | Bereich / Regel |
|---|---|---|---|
| `enabled` | bool | `false` | Master Switch |
| `log_level` | choice | `error` | `off|error|debug` |
| `llm_base_url` | text | `http://127.0.0.1:11434/v1` | URL `http/https` |
| `llm_auth_enabled` | bool | `false` | Auth aktiviert Bearer Header |
| `llm_api_key` | text | leer | Pflicht nur bei `llm_auth_enabled=true` |
| `llm_model` | choice | `gemma3:4b` | Modell-Dropdown |
| `llm_model_custom` | text | leer | Ueberschreibt Dropdown |
| `openai_max_tokens` | int | `700` | `100..4096` |
| `openai_temperature` | float | `0.2` | `0.0..2.0` |
| `openai_timeout` | int | `180` | `5..300` |
| `openai_retry_count` | int | `0` | `0..3` |
| `allowed_departments` | multiselect | `0` | `0` bedeutet alle |
| `blocked_priorities` | multiselect | leer | optionale Sperrliste |
| `blocked_tags` | text | `incident,...` | CSV |
| `allowed_statuses` | multiselect | `open` | Allowlist |
| `attachment_policy` | choice | `ignore` | `analyze_images|ignore|deny` |
| `attachment_max_images` | int | `3` | `1..6` |
| `attachment_max_image_bytes` | int | `2097152` | `131072..10485760` |
| `context_message_count` | int | `6` | `1..20` |
| `max_message_length` | int | `2000` | `100..10000` |
| `response_language` | text | `Deutsch` | Promptsprache |
| `mini_kb_content` | text | leer | auf 4000 Zeichen begrenzt |
| `use_osticket_kb` | bool | `false` | Fallback FAQ Search |
| `use_canned_responses` | bool | `true` | Canned Search |
| `kb_article_limit` | int | `3` | `1..5` |
| `rag_enabled` | bool | `false` | aktiviert externes Retrieval |
| `rag_service_url` | text | `http://127.0.0.1:8099` | URL `http/https` |
| `kb_reference_base_url` | text | leer | fuer absolute Source Links |
| `rag_timeout_seconds` | int | `10` | `2..60` |
| `rag_top_k` | int | `5` | `1..20` |
| `rag_fail_mode` | choice | `strict` | wird in pre_save erzwungen |
| `pii_redaction_enabled` | bool | `true` | maskiert sensitive Daten |
| `redact_ip_addresses` | bool | `false` | optional |
| `rate_limit_per_ticket_seconds` | int | `120` | `0..3600` |
| `rate_limit_global_per_minute` | int | `60` | `0..1000` |

## B) RAG Service ENV (`app.py` + systemd)

| Variable | Default | Zweck |
|---|---|---|
| `OSTICKET_ROOT` | `/var/www/osticket` | osTicket Root |
| `OSTICKET_CONFIG` | leer | direkte Config-Datei |
| `OSTICKET_BASE_URL` | leer | Link-Basis fuer FAQ/Kategorie |
| `OLLAMA_BASE_URL` | `http://127.0.0.1:11434` | Embedding Endpoint |
| `OLLAMA_EMBED_MODEL` | `embeddinggemma:latest` | Embedding Modell |
| `RAG_REFRESH_SECONDS` | `300` | Refresh Intervall |
| `RAG_DEFAULT_TOP_K` | `5` | Query default |
| `RAG_MAX_TOP_K` | `8` | Query cap |
| `RAG_MAX_EMBED_CHARS` | `2400` | Textkuerzung |
| `RAG_MIN_CATEGORY_GUIDANCE_CHARS` | `20` (Code) | Category-only Mindestlaenge |
| `RAG_EMBED_BATCH_SIZE` | `4` | Batch |
| `RAG_EMBED_TIMEOUT_SECONDS` | `120` | Timeout |

Quellen: `tools/kb_rag_service/app.py:443`, `tools/kb_rag_service/systemd/osticket-kb-rag.service`.

Runtime-Hinweis: Im bereitgestellten systemd-Template ist `RAG_MIN_CATEGORY_GUIDANCE_CHARS=80` gesetzt und damit effektiv.

## C) Seeder CLI Parameter

Quelle: `seed_osticket_kb.py:107`.

| Flag | Default | Zweck |
|---|---|---|
| `--apply` | aktiv | schreibt Aenderungen |
| `--dry-run` | aus | simuliert + rollback |
| `--root` | auto | osTicket root override |
| `--config` | auto | config datei override |
| `--dataset` | `./kb_demo.json` | datenquelle |
| `--log-level` | `info` | logging detail |

## D) Beispielwerte (anonymisiert)

```env
OSTICKET_ROOT=<OSTICKET_ROOT>
OSTICKET_BASE_URL=<OSTICKET_BASE_URL>
OLLAMA_BASE_URL=<OLLAMA_BASE_URL>
RAG_SERVICE_URL=<RAG_SERVICE_URL>
DB_HOST=<DB_HOST>
```

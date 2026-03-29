# 10 Security Privacy Limits

## Sicherheitsmodell

1. LLM und Embeddings laufen lokal (`<OLLAMA_BASE_URL>`)
2. RAG-Service laeuft lokal (`127.0.0.1:8099` empfohlen)
3. Nur Webentrypoint extern exponieren (Cloudflare/Reverse Proxy)

## Datenminimierung im Plugin

- PII Redaction vor Prompt-Versand (wenn aktiviert)
- Optionales Redacting von IP-Adressen
- Keine rohe Prompt/Response Persistenz im Zielmodell

Referenzen:

- PII Gating/Detection: `include/plugins/ai-reply-assistant/classes/GatingLogic.php:107`
- Prompt-Aufbau: `include/plugins/ai-reply-assistant/classes/ContextBuilder.php:59`

## Secret Handling

- API Keys niemals in Doku/Commits hinterlegen
- systemd-Umgebungswerte ohne Secrets bevorzugen
- Key nur setzen, wenn `llm_auth_enabled=true`

Validierung: `include/plugins/ai-reply-assistant/config.php:410`.

## Netzwerkgrenzen

Empfohlen:

- Extern offen: `80/443`
- Intern only: `8099` (RAG), `11434` (Ollama), `3306` (DB)

## Quellenintegritaet

Die Antwort darf nur Quellen verlinken, die im Kontext enthalten sind.

Referenzen:

- Prompt-Regel Sources: `include/plugins/ai-reply-assistant/classes/ContextBuilder.php:98`
- URL-Aufloesung pro Hit: `include/plugins/ai-reply-assistant/classes/KbRetriever.php:259`

## Grenzen

1. Kein kryptografisch signierter Audit-Trail
2. Keine rollenbasierte Auth zwischen Plugin und lokalem RAG-Service
3. Keine Ende-zu-Ende Verschluesselung zwischen lokalen Diensten per Default
4. Security-Hardening (SELinux/AppArmor, mTLS) nicht standardmaessig enthalten

## Empfohlene Hardening-Massnahmen

1. Loopback-Bindung fuer RAG und Ollama erzwingen
2. Firewall-Regeln fuer lokale Dienste setzen
3. systemd mit restriktiveren Optionen haerten
4. Regelmaessige Rotation von Zugangsdaten und Session-Management

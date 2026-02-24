# 09 Troubleshooting

## Leitprinzip

Immer zuerst feststellen, ob Fehler aus Plugin, RAG-Service, Ollama oder Netzwerk/Runtime kommt.

## Schnell-Diagnose

```bash
sudo systemctl status osticket-kb-rag.service --no-pager
sudo journalctl -u osticket-kb-rag.service -n 120 --no-pager
curl -sS <RAG_SERVICE_URL>/health
curl -sS -X POST <RAG_SERVICE_URL>/query -H 'Content-Type: application/json' -d '{"subject":"test","latest_message":"test","top_k":3}'
```

## Fehlerbild A: `AI Draft Error ... HTTP 0`

Typische Ursache:

- AJAX Request scheitert (timeout, endpoint nicht erreichbar, service down)

Diagnose:

1. Apache/PHP Logs pruefen
2. RAG Health pruefen
3. Plugin endpoint route pruefen (`scp/ajax.php/ai-reply/generate`)

Referenzen:

- JS Fehlerbehandlung: `include/plugins/ai-reply-assistant/classes/EventRouter.php`
- Pipeline Start: `include/plugins/ai-reply-assistant/classes/EventRouter.php:383`

## Fehlerbild B: `LLM request timed out ... 45s`

Typische Ursache:

- Lokales Modell antwortet nicht rechtzeitig
- Timeout zu knapp

Diagnose:

1. Ollama Erreichbarkeit: `curl -sS <OLLAMA_BASE_URL>/api/tags`
2. Modell vorhanden: `ollama list`
3. Plugin Timeout Wert pruefen (`openai_timeout`)

Codepfad:

- Timeout Handling: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:103`

Fix:

1. `openai_timeout` erhoehen
2. leichteres Modell verwenden
3. Systemlast reduzieren

## Fehlerbild C: `/health` bleibt `warming_up`

Typische Ursache:

- Initialer Embedding-Build laeuft sehr lange
- Embedding Timeout/DB Zugriff scheitert

Diagnose:

1. `journalctl -u osticket-kb-rag.service -f`
2. Auf wiederholte Embed Calls und Fehler achten
3. `last_error` in `/health` auswerten

Codepfad:

- Health Statuslogik: `tools/kb_rag_service/app.py:820`
- Initial Build: `tools/kb_rag_service/app.py:803`

Fix:

1. `RAG_EMBED_TIMEOUT_SECONDS` erhoehen
2. `RAG_MAX_EMBED_CHARS` reduzieren
3. DB/Config Pfad validieren
4. Manuell `POST /reindex` nach Ursachebehebung

## Fehlerbild D: `/query` liefert `{\"results\":[]}`

Typische Ursache:

- Index leer (`doc_count=0`)
- unpassende Query
- KB Daten fehlen oder nicht indexiert

Diagnose:

1. `health` -> `doc_count`
2. Seeder erneut mit `--apply`
3. RAG `POST /reindex`
4. Query mit klaren Begriffen testen

Fix:

- Sicherstellen, dass FAQ/Kategorien in DB vorhanden sind
- RAG Reindex triggern
- `rag_top_k` ggf. erhoehen

## Fehlerbild E: systemd `Unit ... not found`

Typische Ursache:

- Unit-Datei nicht installiert

Fix:

```bash
sudo install -m 644 <REPO_ROOT>/tools/kb_rag_service/systemd/osticket-kb-rag.service /etc/systemd/system/osticket-kb-rag.service
sudo systemctl daemon-reload
sudo systemctl enable --now osticket-kb-rag.service
```

## Fehlerbild F: Verbindung zu `127.0.0.1:8099` fehlgeschlagen

Typische Ursache:

- Service abgestuerzt
- falsches WorkingDirectory/ExecStart

Diagnose:

```bash
sudo systemctl status osticket-kb-rag.service --no-pager
sudo journalctl -u osticket-kb-rag.service -n 200 --no-pager
```

## Fehlerbild G: Plugin zeigt `OpenAI error` trotz lokalem LLM

Einordnung:

- Die Klasse heisst historisch `OpenAiClient`, wird aber fuer OpenAI-kompatible lokale Endpoints genutzt.
- Fehlertext kann daher OpenAI enthalten, obwohl die Anfrage lokal lief.

Referenz:

- Clientklasse: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:1`

## Ursachenbaum fuer leere Retrievals

1. Service nicht `ok` -> zuerst Index fixen
2. `rag_enabled` aus -> Plugin nutzt ggf. lokalen FAQ fallback
3. KB leer oder nur private Daten ohne passende Inhalte
4. Query zu unspezifisch
5. stale index -> `/reindex`

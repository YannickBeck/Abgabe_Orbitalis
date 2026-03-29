# 04 RAG Service Reference

## Zweck

Der RAG-Service stellt semantisches KB-Retrieval fuer das Plugin bereit.

Implementierung: `tools/kb_rag_service/app.py`.

## Kernfunktionen

1. osTicket Config finden/parsen
2. DB-Schema discovery (FAQ/Kategorie/Topic)
3. Dokumente laden (FAQ + Category Guidance)
4. Embeddings via Ollama erzeugen
5. Vector Index aufbauen
6. HTTP Endpoints bereitstellen

Relevante Stellen:

- Config Discovery: `tools/kb_rag_service/app.py:145`
- Layout Discovery: `tools/kb_rag_service/app.py:282`
- Dokumentaufbau: `tools/kb_rag_service/app.py:525`
- Startup/Refresh: `tools/kb_rag_service/app.py:790`

## Laufzeitkonfiguration (ENV)

| Variable | Default | Bedeutung |
|---|---|---|
| `OSTICKET_ROOT` | `/var/www/osticket` | Basis fuer Config-Suche |
| `OSTICKET_CONFIG` | leer | Direkte Config-Datei (optional) |
| `OSTICKET_BASE_URL` | leer | Basis fuer absolute FAQ/Kategorie-Links |
| `OLLAMA_BASE_URL` | `http://127.0.0.1:11434` | Ollama Endpoint |
| `OLLAMA_EMBED_MODEL` | `embeddinggemma:latest` | Embedding Modell |
| `RAG_REFRESH_SECONDS` | `300` | Intervall fuer Signature-Pruefung |
| `RAG_DEFAULT_TOP_K` | `5` | Default Trefferanzahl |
| `RAG_MAX_TOP_K` | `8` | Harte obere Grenze |
| `RAG_MAX_EMBED_CHARS` | `2400` | Textlimit fuer stabile Embeddings |
| `RAG_MIN_CATEGORY_GUIDANCE_CHARS` | `20` im Code | Mindestlaenge fuer Category-only Dokumente |
| `RAG_EMBED_BATCH_SIZE` | `4` | Batchgroesse beim Embedding |
| `RAG_EMBED_TIMEOUT_SECONDS` | `120` | Timeout pro Embed-Aufruf |

Quellen: `tools/kb_rag_service/app.py:443`, `tools/kb_rag_service/app.py:455`.

Hinweis: Das mitgelieferte systemd-Template setzt `RAG_MIN_CATEGORY_GUIDANCE_CHARS=80` und ueberschreibt damit den Code-Default zur Laufzeit.

## API Endpoints

### `GET /health`

Antwort liefert Betriebsstatus:

- `status`: `warming_up`, `ok`, `error`
- `doc_count`
- `last_signature`
- `last_error`
- Konfig-Transparenz (`embed_model`, `ollama_base_url`, ...)

Statuslogik: `tools/kb_rag_service/app.py:820`.

Beispiel:

```bash
curl -sS <RAG_SERVICE_URL>/health
```

### `POST /query`

Request:

```json
{
  "subject": "Outlook startet nicht",
  "latest_message": "haengt beim Start",
  "top_k": 5
}
```

Response:

```json
{
  "results": [
    {
      "faq_id": 45,
      "category_id": 10,
      "source_type": "faq",
      "question": "Outlook startet nicht ...",
      "answer_snippet": "...",
      "score": 0.78,
      "category": "Microsoft 365",
      "topic": "Microsoft 365 / Outlook",
      "faq_url": "<OSTICKET_BASE_URL>/scp/faq.php?id=45",
      "category_url": "<OSTICKET_BASE_URL>/scp/categories.php?id=10",
      "reference_url": "<OSTICKET_BASE_URL>/scp/faq.php?id=45"
    }
  ]
}
```

Endpoint: `tools/kb_rag_service/app.py:876`.

### `POST /reindex`

Erzwingt einen Rebuild (`force=True`).

```bash
curl -sS -X POST <RAG_SERVICE_URL>/reindex
```

Endpoint: `tools/kb_rag_service/app.py:866`.

## Dokumentmodell

Es werden zwei Dokumenttypen indexiert:

1. `source_type=faq` mit FAQ-Inhalten
2. `source_type=category` fuer Kategorie-Leitfaeden

Referenzen:

- FAQ Metadata: `tools/kb_rag_service/app.py:631`
- Category Guidance Dokumente: `tools/kb_rag_service/app.py:675`

## Health-Zustaende

- `warming_up`: Startup aktiv, Index noch nicht fertig
- `ok`: `index is not None`
- `error`: letzter Rebuild mit Fehler

Definition: `tools/kb_rag_service/app.py:820`.

## Index-Lifecycle

1. Startup startet sofort Initial Build (`start_initial_build`).
2. Parallel startet periodischer Refresh (`start_refresh_loop`).
3. Signature-Vergleich verhindert unnoetige Rebuilds.
4. Fehler setzen `last_error` und sind in `/health` sichtbar.

## systemd Template

Template-Datei: `tools/kb_rag_service/systemd/osticket-kb-rag.service`.

Wichtige Felder:

- `WorkingDirectory`
- `Environment=...`
- `ExecStart`
- `User`/`Group`

Empfehlung: Runtime-Werte in einer separaten Override-Datei verwalten.

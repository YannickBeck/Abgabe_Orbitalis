# osTicket KB RAG Service

Lokaler Python-Service für KB-Retrieval via LlamaIndex + Ollama Embeddings.

## Funktionen
- Lädt osTicket FAQ/Kategorien/Topics direkt aus MySQL.
- Indexiert FAQ-Inhalte **und** Kategorie-Leitfäden (`faq_category.description/notes`).
- Baut beim Start einen Vektorindex.
- Aktualisiert den Index periodisch (`RAG_REFRESH_SECONDS`, Default 300s).
- HTTP API:
  - `GET /health`
  - `POST /query`
  - `POST /reindex`

## Installation

```bash
cd /osTicket/tools/kb_rag_service
python3 -m pip install -r requirements.txt
```

## Start

```bash
cd /osTicket/tools/kb_rag_service
python3 -m uvicorn app:app --host 127.0.0.1 --port 8099
```

## Environment Variablen
- `OSTICKET_ROOT` (Default: `/var/www/osticket`)
- `OSTICKET_CONFIG` (optional, überschreibt Root-Suche)
- `OLLAMA_BASE_URL` (Default: `http://127.0.0.1:11434`)
- `OLLAMA_EMBED_MODEL` (Default: `embeddinggemma:latest`)
- `OSTICKET_BASE_URL` (optional, z.B. `http://192.168.194.65` für absolute KB-Referenzlinks)
- `RAG_REFRESH_SECONDS` (Default: `300`)
- `RAG_DEFAULT_TOP_K` (Default: `5`)
- `RAG_MAX_TOP_K` (Default: `8`)
- `RAG_MAX_EMBED_CHARS` (Default: `2400`, begrenzt große FAQ-Texte für stabilere Embeddings)
- `RAG_MIN_CATEGORY_GUIDANCE_CHARS` (Default: `80`, Mindestlänge für eigene Kategorie-Guidance-Dokumente)
- `RAG_EMBED_BATCH_SIZE` (Default: `4`)
- `RAG_EMBED_TIMEOUT_SECONDS` (Default: `120`)

## Beispielanfragen

Health:

```bash
curl -sS http://127.0.0.1:8099/health
```

Query:

```bash
curl -sS -X POST http://127.0.0.1:8099/query \
  -H 'Content-Type: application/json' \
  -d '{
    "subject": "Outlook startet nicht",
    "latest_message": "Outlook bleibt beim Laden hängen",
    "top_k": 5
  }'
```

Reindex:

```bash
curl -sS -X POST http://127.0.0.1:8099/reindex
```

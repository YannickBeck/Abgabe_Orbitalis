# AI Reply Assistant RAG Integration

## Ziel
Der Plugin-Flow kann KB-Kontext über einen lokalen HTTP-RAG-Service beziehen (`tools/kb_rag_service/app.py`).

## Neue Plugin-Settings
- `rag_enabled`
- `rag_service_url` (Default: `http://127.0.0.1:8099`)
- `rag_timeout_seconds`
- `rag_top_k`
- `rag_fail_mode` (strict, erzwungen)

## Ablauf
1. In `KbRetriever` wird bei `rag_enabled=true` der RAG-Service abgefragt.
2. Treffer werden als KB-Abschnitt in den Prompt geschrieben.
3. Bei Servicefehler (strict) wird `AiReplyRagException` geworfen.
4. `EventRouter` loggt den Fall als `rag_error` und bricht den Draft ab.

## Voraussetzung
RAG-Service muss laufen:

```bash
cd /osTicket/tools/kb_rag_service
python3 -m uvicorn app:app --host 127.0.0.1 --port 8099
```

Healthcheck:

```bash
curl -sS http://127.0.0.1:8099/health
```

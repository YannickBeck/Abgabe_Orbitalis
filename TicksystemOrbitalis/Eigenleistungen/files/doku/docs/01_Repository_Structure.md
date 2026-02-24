# 01 Repository Structure

## Uebersicht

Das Repo ist ein Vollrepo. Es enthaelt den vollstaendigen osTicket-Basiscode plus projektspezifische Erweiterungen.

## Struktur (relevante Bereiche)

```text
/osTicket
|-- include/plugins/ai-reply-assistant/
|   |-- class.AiReplyPlugin.php
|   |-- config.php
|   |-- classes/
|   |-- migrations/
|   `-- README_RAG.md
|-- tools/kb_rag_service/
|   |-- app.py
|   |-- requirements.txt
|   |-- systemd/osticket-kb-rag.service
|   `-- README.md
|-- seed_osticket_kb.py
|-- kb_demo.json
|-- README_SEED_KB.md
`-- docs/
```

## Basiscode vs Custom

| Bereich | Typ | Zweck |
|---|---|---|
| `include/plugins/ai-reply-assistant/` | Custom | AI-Draft Plugin inkl. RAG-Client und LLM-Client |
| `tools/kb_rag_service/` | Custom | Lokaler Retrieval-Service auf FAQ/Kategorien |
| `seed_osticket_kb.py` | Custom | Schema-discovernder KB Seeder |
| `kb_demo.json` | Custom | Demo KB Datensatz |
| `README_SEED_KB.md` | Custom | Seeder Bedienung |
| osTicket Core (restliche Verzeichnisse) | Basiscode | Ticketplattform, Framework, Datenmodell |

## Wichtige Laufzeitbeziehungen

- Plugin -> RAG: `include/plugins/ai-reply-assistant/classes/RagServiceClient.php:25`
- Plugin -> LLM: `include/plugins/ai-reply-assistant/classes/OpenAiClient.php:57`
- Plugin -> Internal Note: `include/plugins/ai-reply-assistant/classes/NoteWriter.php:42`
- RAG -> DB Discovery: `tools/kb_rag_service/app.py:282`
- RAG -> Embeddings: `tools/kb_rag_service/app.py:443`
- Seeder -> Schema Discovery: `seed_osticket_kb.py:368`

## Deployment-Pfade (Beispiel, anonymisiert)

- Repo-Arbeitsverzeichnis: `<REPO_ROOT>`
- Produktiver osTicket Root: `<OSTICKET_ROOT>`
- systemd Unit: `/etc/systemd/system/osticket-kb-rag.service`

Hinweis: Abgabe-Doku nutzt Platzhalter fuer sensitive Infrastrukturwerte.

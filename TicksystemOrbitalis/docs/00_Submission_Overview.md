# 00 Submission Overview

## Ziel der Abgabe

Dieses Repository dokumentiert eine osTicket-basierte Loesung fuer AI-unterstuetzte Ticketantworten mit lokalem LLM und lokalem RAG.

Abgabeziel:

1. Nachvollziehbare Architektur
2. Reproduzierbarer Betrieb
3. Nachweisbare Tests und Fehlerbehandlung
4. Transparente Grenzen/Risiken

## Projektumfang

Im Scope:

- osTicket Plugin fuer AI Drafts als Internal Notes
- LLM-Anbindung ueber OpenAI-kompatible lokale API (Ollama)
- RAG-Service fuer KB-Retrieval
- Idempotenter Seeder fuer FAQ/Kategorien/Topic-Mappings
- Multimodale Eingabe (Text + Bildanhaenge)

Nicht im Scope:

- Produktive HA-/Cluster-Architektur
- Cloud-hosted LLMs als Pflichtpfad
- Automatisches Senden von Antworten an Kunden

## Systemgrenzen

- Das Plugin arbeitet innerhalb von osTicket und erzeugt nur interne Notizen.
- Der RAG-Service laeuft lokal und spricht lokal mit DB + Ollama.
- Seeder greift direkt auf MySQL/MariaDB zu und bearbeitet nur KB-relevante Tabellen.

Siehe Einstiegspunkte:

- Plugin Bootstrap: `include/plugins/ai-reply-assistant/class.AiReplyPlugin.php:53`
- Ticket-Pipeline: `include/plugins/ai-reply-assistant/classes/EventRouter.php:383`
- RAG API: `tools/kb_rag_service/app.py:859`
- Seeder Run: `seed_osticket_kb.py:904`

## Erfolgsdefinition

Die Abgabe gilt als erfolgreich, wenn:

1. `GET /health` des RAG-Service `status=ok` mit `doc_count > 0` liefert.
2. `POST /query` valide Treffer inkl. `reference_url` liefern kann.
3. AI Draft im Ticket eine Internal Note erstellt (kein Kundenversand).
4. Seeder mehrfach laeuft ohne Duplikate (idempotent).
5. Doku alle Betriebs- und Troubleshooting-Schritte enthaelt.

## Deliverables

- Projekt-README: `README.md`
- Seeder-Rundown: `README_SEED_KB.md`
- Vollstaendige Abgabe-Dokumentation unter `docs/`

## Annahmen

- Runtime Root: `<OSTICKET_ROOT>`
- Basis-URL: `<OSTICKET_BASE_URL>`
- RAG-Service URL: `<RAG_SERVICE_URL>`
- Ollama URL: `<OLLAMA_BASE_URL>`
- DB Host: `<DB_HOST>`

## Empfohlene Lesereihenfolge

1. `README.md`
2. `docs/02_Architecture_and_Dataflow.md`
3. `docs/07_Deployment_and_Operations.md`
4. `docs/08_Testplan_and_Acceptance.md`
5. `docs/09_Troubleshooting.md`

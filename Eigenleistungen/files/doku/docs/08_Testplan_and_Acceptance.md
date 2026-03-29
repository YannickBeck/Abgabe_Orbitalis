# 08 Testplan and Acceptance

## Testziel

Nachweis, dass Seeder, RAG-Service und Plugin zusammen stabil arbeiten und die definierten Abnahmekriterien erfuellen.

## Testumgebung

- osTicket erreichbar unter `<OSTICKET_BASE_URL>`
- RAG Service unter `<RAG_SERVICE_URL>`
- Ollama unter `<OLLAMA_BASE_URL>`
- Plugin aktiviert in osTicket Admin

## Testmatrix

| ID | Bereich | Testschritt | Erwartung |
|---|---|---|---|
| T1 | Seeder | `python3 seed_osticket_kb.py --dry-run` | Keine persistente DB-Aenderung, Summary vorhanden |
| T2 | Seeder | `python3 seed_osticket_kb.py --apply` zweimal | Keine Duplikate, Updates statt Inserts |
| T3 | RAG | `GET /health` nach Startup | `status=ok`, `doc_count > 0` |
| T4 | RAG | `POST /query` mit Tickettext | Trefferliste mit `score` und `reference_url` |
| T5 | Plugin | Manueller AI Draft in Ticketansicht | Internal Note wird erstellt |
| T6 | Plugin+RAG | RAG Service stoppen, AI Draft ausloesen | Draft bricht mit `rag_error` ab (strict) |
| T7 | Multimodal | Ticket mit Bildanhaengen und `analyze_images` | Kontext enthaelt Bildliste, LLM bekommt Bildpayload |
| T8 | Prompt Sources | RAG Treffer mit URLs + AI Draft | Antwort enthaelt `Sources:` nur aus Kontext |
| T9 | Ops | Portpruefung via `ss` | Ports konsistent mit Runbook |
| T10 | Security | Doku-Scan | Keine Secrets oder internen Hostnamen in Doku |

## Konkrete Testkommandos

### RAG Health

```bash
curl -sS <RAG_SERVICE_URL>/health
```

Soll:

- `status` ist `ok`
- `doc_count` groesser als 0

### RAG Query

```bash
curl -sS -X POST <RAG_SERVICE_URL>/query \
  -H 'Content-Type: application/json' \
  -d '{"subject":"Outlook startet nicht","latest_message":"haengt beim Start","top_k":3}'
```

Soll:

- JSON mit `results` Array
- Treffer enthalten `score`
- Treffer enthalten `reference_url`

### Reindex

```bash
curl -sS -X POST <RAG_SERVICE_URL>/reindex
```

Soll:

- Antwort zeigt Rebuild Ergebnis (`rebuilt`, `doc_count`)

## Plugin-Flusstests

### Automatisch

1. Kunde schreibt neue Nachricht im erlaubten Status/Department.
2. Plugin triggert Pipeline.
3. Interne Notiz entsteht.

Referenzfluss: `include/plugins/ai-reply-assistant/classes/EventRouter.php:316`.

### Manuell

1. Ticket oeffnen.
2. `AI Draft` im Agentenbereich klicken.
3. Erfolgsmeldung und Note.

Referenzfluss: `include/plugins/ai-reply-assistant/classes/EventRouter.php:227`.

## Abnahmekriterien (final)

1. Alle Kernpfade funktionieren ohne OpenAI-Pflichtkey.
2. RAG liefert reproduzierbare Treffer fuer typische Supportfragen.
3. Fehlersituationen sind transparent in Logs sichtbar.
4. Dokumentation ist vollstaendig, anonymisiert und reproduzierbar.

# 12 Database Handover Guide

## Ziel

Dieses Dokument beschreibt die Einbindung der Datenbank in einer Zielumgebung fuer die Projektabgabe.
Es gibt zwei Wege:

1. **Seeder-basiert (empfohlen)**: kein DB-Dump erforderlich
2. **Snapshot-basiert (optional)**: KB-Tabellen als SQL-Dump importieren

## Kurzantwort: Abgabeumfang

1. Repository mit Code, Dokumentation, `kb_demo.json` und `seed_osticket_kb.py` bereitstellen.
2. Diese Datenbank-Einbindungsanleitung in der Abgabe referenzieren.
3. Optional einen KB-Snapshot bereitstellen, wenn ein exakter Datenstand reproduziert werden soll.

## Weg A (empfohlen): Seeder-basiert, ohne Dump

Vorteile:

- Keine sensitiven Ticketdaten in der Abgabe
- Reproduzierbar und idempotent
- Unabhaengig von einer spezifischen Quellumgebung

### Schritte in der Zielumgebung

1. osTicket und Datenbank installieren, Basis-Setup abschliessen.
2. Repository auschecken.
3. KB Seeder ausfuehren:

```bash
cd <REPO_ROOT>
python3 seed_osticket_kb.py --apply --root <OSTICKET_ROOT>
```

4. RAG-Service starten und Reindex ausloesen:

```bash
curl -sS <RAG_SERVICE_URL>/health
curl -sS -X POST <RAG_SERVICE_URL>/reindex
```

5. Plugin in osTicket aktivieren (siehe `README.md` und `docs/07_Deployment_and_Operations.md`).

## Weg B (optional): Snapshot-Import per SQL-Dump

Dieser Weg ist sinnvoll, wenn ein exakter KB-Stand aus einer Quellumgebung uebernommen werden soll.

### B1) Export in der Quellumgebung

Nur KB-relevante Tabellen dumpen:

```bash
mysqldump -h <DB_HOST> -u <DB_USER> -p <DB_NAME> \
  <PREFIX>faq <PREFIX>faq_category <PREFIX>faq_topic <PREFIX>help_topic <PREFIX>config \
  > kb_export.sql
```

Optional Plugin-Log mitgeben:

```bash
mysqldump -h <DB_HOST> -u <DB_USER> -p <DB_NAME> <PREFIX>ai_reply_log > ai_reply_log.sql
```

Wichtig:

- Keine realen Zugangsdaten committen
- Dump-Dateien vor Abgabe auf sensitive Inhalte pruefen

### B2) Import in der Zielumgebung

Voraussetzung: osTicket-Basisdatenbank existiert bereits.

```bash
mysql -h <DB_HOST> -u <DB_USER> -p <DB_NAME> < kb_export.sql
```

Danach RAG neu aufbauen:

```bash
curl -sS -X POST <RAG_SERVICE_URL>/reindex
curl -sS <RAG_SERVICE_URL>/health
```

## LlamaIndex / Vektorraum

Der Vektorindex wird **nicht als Datei uebergeben**. Er wird zur Laufzeit aus SQL aufgebaut.

Konkretes Verhalten:

1. Service startet
2. Initial Build laeuft (`warming_up`)
3. Nach erfolgreichem Build steht `status=ok`

Checks:

```bash
curl -sS <RAG_SERVICE_URL>/health
curl -sS -X POST <RAG_SERVICE_URL>/query -H 'Content-Type: application/json' -d '{"subject":"Outlook","latest_message":"startet nicht","top_k":3}'
```

## DB-Verkabelung (osTicket Config)

In der Zielumgebung muss der DB-Zugang in osTicket konfiguriert werden (z. B. `include/ost-config.php`):

- DB Host
- DB Name
- DB User
- DB Password
- ggf. Table Prefix

Hinweis: Keine Secrets in Git. Config nur lokal setzen.

## Minimaler Abnahme-Check

1. `seed_osticket_kb.py --apply` laeuft ohne Fehler.
2. RAG `health` zeigt `ok` und `doc_count > 0`.
3. `POST /query` liefert Treffer mit `reference_url`.
4. AI Draft erstellt Internal Note im Ticket.

## Referenzen

- Deployment: `docs/07_Deployment_and_Operations.md`
- Testplan: `docs/08_Testplan_and_Acceptance.md`
- Troubleshooting: `docs/09_Troubleshooting.md`
- RAG Service: `docs/04_RAG_Service_Reference.md`
- Seeder: `docs/05_KB_Seeder_Reference.md`

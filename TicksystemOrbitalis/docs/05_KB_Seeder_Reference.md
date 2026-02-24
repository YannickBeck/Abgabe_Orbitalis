# 05 KB Seeder Reference

## Zweck

`seed_osticket_kb.py` befuellt die osTicket Knowledgebase direkt per SQL.
Der Seeder ist idempotent und schema-dynamisch.

Dateien:

- `seed_osticket_kb.py`
- `kb_demo.json`
- `README_SEED_KB.md`

## CLI

```bash
python3 seed_osticket_kb.py --apply
python3 seed_osticket_kb.py --dry-run
```

Optionale Parameter:

- `--root <OSTICKET_ROOT>`
- `--config <OSTICKET_CONFIG>`
- `--dataset <PATH>`
- `--log-level <debug|info|warn|error>`

Parser: `seed_osticket_kb.py:107`.

## Ablauf

1. osTicket Root/Config finden
2. DB Credentials aus PHP Defines lesen
3. Tabellen und Spalten per `INFORMATION_SCHEMA` erkennen
4. KB Enable best-effort setzen
5. Kategorien upserten
6. FAQs upserten
7. FAQ-Topic Mappings upserten
8. Summary ausgeben

Hauptablauf: `seed_osticket_kb.py:904`.

## Discovery-Strategie

- Prefix-Erkennung: `seed_osticket_kb.py:249`
- Schema Discovery: `seed_osticket_kb.py:368`
- Keine harten Tabellennamen im Seeder-Kern

## Idempotenz

### Kategorien

`upsert_category(...)` aktualisiert vorhandene Kategorien deterministisch.
Referenz: `seed_osticket_kb.py:627`.

### FAQs

Unique-Lookup wird dynamisch bestimmt:

- bevorzugt erkannte Unique Keys
- fallback auf `question + category_id` je nach Schema

Referenzen: `seed_osticket_kb.py:757`, `seed_osticket_kb.py:767`.

### FAQ-Topic Mapping

Mapping-Upsert ueber `(faq_id, topic_id)` und skip bei vorhandenem Datensatz.
Referenz: `seed_osticket_kb.py:859`.

## Best-Effort KB Enable

Der Seeder versucht passende Config-Keys fuer KB-Aktivierung auf `1` zu setzen.
Wenn kein eindeutiger Key gefunden wird, wird nur gewarnt.

Referenz: `seed_osticket_kb.py:567`.

## Dry-Run Verhalten

`--dry-run` fuehrt den gleichen Ablauf aus, schreibt aber keine persistente Aenderung.
Nutzbar fuer sichere Validierung in fremden Umgebungen.

## Logging und Summary

`Summary` sammelt Created/Updated/Skipped/Error Zaehler.
Referenzen: `seed_osticket_kb.py:87`, `seed_osticket_kb.py:994`.

## Datenquelle

Standard-Dataset: `kb_demo.json`.

Policy:

- Upsert ohne Loeschung
- Demo-Inhalte als Source of Truth fuer Seeder-Lauf

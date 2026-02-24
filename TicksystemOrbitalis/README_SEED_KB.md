# README_SEED_KB

## Zweck
`seed_osticket_kb.py` befüllt die osTicket Knowledgebase (Kategorien, FAQs, FAQ-Topic-Mapping) **idempotent** per direktem DB-Zugriff.

- Kein UI-Workflow
- Kein Human-Review
- Mehrfaches Ausführen erzeugt keine Duplikate
- Vorhandene Datensätze werden aktualisiert (Upsert), nicht gelöscht

## Dateien
- `seed_osticket_kb.py`
- `kb_demo.json`

## Voraussetzungen
- Python 3
- MySQL-Treiber:
  - bevorzugt: `PyMySQL`
  - fallback: `mysqlclient`

Installation:

```bash
pip install pymysql
```

Fallback:

```bash
pip install mysqlclient
```

## Aufruf

Default ist `--apply`.

```bash
python3 seed_osticket_kb.py --apply
```

Dry-run:

```bash
python3 seed_osticket_kb.py --dry-run
```

Optional mit explizitem Root/Config:

```bash
python3 seed_osticket_kb.py --dry-run --root /var/www/osticket
python3 seed_osticket_kb.py --apply --config /var/www/osticket/include/ost-config.php
```

Custom Dataset:

```bash
python3 seed_osticket_kb.py --apply --dataset /path/to/kb_demo.json
```

## Flags
- `--apply`: Änderungen schreiben (Default)
- `--dry-run`: Simulation, Transaktion wird am Ende zurückgerollt
- `--root <path>`: osTicket Root erzwingen
- `--config <path>`: Config-Datei direkt setzen
- `--dataset <path>`: JSON-Dataset
- `--log-level <debug|info|warn|error>`

## Verhalten (wichtig)
- Discovery von Tabellen/Spalten erfolgt zur Laufzeit über `INFORMATION_SCHEMA`.
- Seeder setzt KB-Enable (`enable_kb` etc.) nur **best-effort**; bei fehlendem Key wird nur gewarnt.
- Es werden nur KB-relevante Tabellen beschrieben.
- Secrets (DB-Passwort) werden nicht geloggt.

## Troubleshooting

`No MySQL driver available`:
- `pip install pymysql`

`Could not locate osTicket root`:
- mit `--root` oder `--config` starten.

`Could not identify FAQ table via discovery`:
- Prüfen, ob DB-User Leserechte auf `information_schema` und osTicket-Tabellen hat.

`Duplicate entry` trotz Upsert:
- FAQ-Unique-Key kann schemaabhängig sein. Script erneut im Debug-Mode laufen lassen:
  - `python3 seed_osticket_kb.py --apply --log-level debug`

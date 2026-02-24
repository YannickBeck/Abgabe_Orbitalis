# Eigenleistungen (Nachweis)

Dieser Ordner enthaelt einen **append-only Nachweis** der Eigenleistungen fuer die Projektabgabe.

## Regeln

- Kein Loeschen von Projektdateien
- Kein Verschieben von Projektdateien
- Eigenleistungsdateien werden als **Kopie** abgelegt
- Klassifizierung erfolgt reproduzierbar gegen feste Baselines

## Klassen

- `files/neu/`: neue Dateien, die weder in osTicket- noch Plugin-Baseline existieren
- `files/plugin_geaendert/`: vom Original-Plugin abweichende Dateien
- `files/osticket_geaendert/`: vom osTicket-Core abweichende Dateien
- `files/doku/`: projektrelevante Dokumentation

## Reproduzierbarkeit

- Baselines sind in `baselines.lock` fixiert.
- Detailliste mit Hashes steht in `MANIFEST.csv`.
- Berichte stehen unter `reports/`.

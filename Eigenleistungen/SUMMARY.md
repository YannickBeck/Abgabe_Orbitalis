# Summary Eigenleistungen

## Was wurde gebaut?

Diese Arbeit erweitert das bestehende osTicket-Ticketsystem um eine vollständige,
lokal betriebene KI-Unterstützung für Support-Mitarbeiter. Kernstück ist ein
selbst entwickeltes AI-Plugin, das bei jedem eingehenden Ticket automatisch einen
Antwortentwurf generiert – gestützt auf ein lokales LLM (Ollama/gemma3:4b) und
eine semantische Wissensdatenbank-Suche (RAG).

---

### 1. RAG-Service – neu entwickelt (`files/neu/tools/kb_rag_service/`)

Eine eigenständige Python-Anwendung, die semantische Suche über die osTicket-Wissensdatenbank ermöglicht.

- **FastAPI-Anwendung** (`app.py`) mit Endpunkten `/query`, `/health`, `/reindex`
- Liest FAQ-Artikel, Kategorien und Topics direkt aus der osTicket-MySQL-Datenbank
- Aufbau eines **LlamaIndex VectorStoreIndex** mit Ollama-Embeddings (`nomic-embed-text` / `embeddinggemma`)
- Schema-agnostisch: erkennt automatisch die osTicket-Tabellenstruktur (mehrere Versionen kompatibel)
- Automatisches Reindexing alle 5 Minuten bei Änderungen in der Wissensdatenbank
- Systemd-Service für stabilen Dauerbetrieb (`osticket-kb-rag.service`)
- 370 Dokumente indexiert (FAQs, Kategorien, Help-Topics)

---

### 2. KB-Seeder – neu entwickelt (`files/neu/seed_osticket_kb.py`)

Ein Python-Skript das die osTicket-Wissensdatenbank mit realistischen Demo-Inhalten befüllt.

- Liest und analysiert das osTicket-DB-Schema automatisch (keine festen Spaltennamen hardcodiert)
- Erstellt Demo-Kategorien und FAQ-Einträge direkt in der osTicket-Datenbank
- Generiert 370 thematisch gegliederte Wissensartikel (IT-Support-Szenarien)
- Idempotent: kann mehrfach ausgeführt werden ohne doppelte Einträge

---

### 3. AI-Reply-Plugin – grundlegend erweitert (`files/plugin_geaendert/`)

Das Basis-Plugin (`sasabajic/AI-Reply-Assistant v1.0.4`) wurde fundamental ausgebaut.
Aus einem einfachen LLM-Connector wurden **10 neue PHP-Klassen** und eine vollständige
Verarbeitungspipeline:

| Klasse | Funktion |
|--------|---------|
| `RagServiceClient` | HTTP-Client für den RAG-Service, holt semantisch passende KB-Artikel |
| `KbRetriever` | Aggregiert Wissensquellen: RAG, osTicket-FAQ, Canned Responses, Mini-KB |
| `ContextBuilder` | Baut den vollständigen LLM-Prompt inkl. Ticket-Kontext, KB-Abschnitte und JSON-Instruktionen |
| `ResponseParser` | Parst LLM-Antworten (3-stufiger JSON-Fallback), normalisiert Tags und Source-URLs |
| `NoteWriter` | Erstellt strukturierte interne Notiz im Ticket (HTML, mit Sources, Tags, Confidence) |
| `PiiRedactor` | Entfernt personenbezogene Daten (E-Mail, Telefon, IBAN, IP) aus dem Prompt |
| `RateLimiter` | Verhindert zu häufige API-Aufrufe pro Zeitfenster (DB-basiert) |
| `LogWriter` | Schreibt alle AI-Aktionen in eine eigene Datenbanktabelle für Audit-Zwecke |
| `EventRouter` | Leitet osTicket-Events (neues Ticket, neue Nachricht) an die richtige Verarbeitungslogik |
| `GatingLogic` | Entscheidet ob ein Ticket AI-verarbeitet werden soll (Abteilung, Sprache, Priorität) |

Wesentliche neue Fähigkeiten gegenüber dem Original-Plugin:
- **RAG-Integration**: semantische Suche in der Wissensdatenbank, Sources im Ticket verlinkt
- **PII-Schutz**: keine persönlichen Daten im LLM-Prompt
- **Strukturiertes JSON-Output**: `reply_body`, `suggested_tags`, `source_urls`, `confidence`, `need_more_info`
- **Interne Notiz** statt direkter Antwort – Agent prüft und sendet selbst
- **Konfigurierbares Gating**: welche Tickets sollen KI-bearbeitet werden?

---

### 4. Installations-Skript – neu entwickelt (`install-debian13.sh`)

Vollautomatisches Bash-Skript für Debian 13 das das gesamte System in einem Durchlauf aufbaut.

- **9 Schritte**: System-Pakete, Ollama, Repository-Klon, Datenbank, osTicket-Deploy, Python-Umgebung, KI-Modelle, RAG-Service, KB-Seeding
- Stellt `curl` und `git` sicher bevor Pre-flight-Checks laufen
- Erstellt alle Konfigurationsdateien, Systemd-Services und DB-Strukturen automatisch
- **AI-Chain-Validierung** nach Installation: prüft RAG-Query-Ergebnisse und LLM-JSON-Output
- Farbige Fortschrittsanzeige, strukturierte Fehlermeldungen, abschließende Zusammenfassung

---

### 5. Datenbank & Exporte (`files/neu/exports/`)

- `kb_export.sql` – Export der befüllten Wissensdatenbank (370 Artikel)
- `ai_reply_log.sql` – Schema der AI-Logging-Tabelle
- `osticket_full.sql` – Vollständiger Datenbankdump für Reproduzierbarkeit

---

## Dateianzahlen pro Klasse

| Klasse | Anzahl | Inhalt |
|--------|--------|--------|
| `neu` | 9 | RAG-Service, KB-Seeder, Systemd-Unit, Exports, Demo-Daten |
| `plugin_geaendert` | 18 | 10 neue PHP-Klassen + 8 angepasste Plugin-Dateien |
| `osticket_geaendert` | 0 | Keine Änderungen am osTicket-Kern |
| `doku` | 16 | Technische Dokumentation (14 Markdown-Dokumente) |
| **Gesamt** | **43** | |

---

## Wichtige Nachweisdokumente

- `MANIFEST.csv` – maschinell generiert, SHA256-Hashes aller Dateien
- `baselines.lock` – fixierte Vergleichsquellen (Plugin v1.0.4, osTicket v1.18.3)
- `reports/plugin_diff_summary.md` – Diff-Bericht Plugin-Änderungen
- `reports/osticket_diff_summary.md` – Diff-Bericht osTicket-Kern (leer – keine Änderungen)

## Hinweise

- Alle Dateien sind Kopien; das Projekt bleibt unangetastet.
- Die Klassifizierung ist baseline-basiert und deterministisch.

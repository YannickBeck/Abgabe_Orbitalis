# Eigenleistungen (Nachweis)

Dieser Ordner enthaelt einen **append-only Nachweis** der Eigenleistungen fuer die Projektabgabe.

---

## Was wurde gebaut?

Das Projekt erweitert osTicket um eine lokal betriebene KI-Unterstützung. Folgende Komponenten wurden vollständig selbst entwickelt:

**RAG-Service** (`files/neu/tools/kb_rag_service/`)
Eigenständige Python/FastAPI-Anwendung mit semantischer Suche (LlamaIndex + Ollama-Embeddings) über die osTicket-Wissensdatenbank. 370 Dokumente indexiert, läuft als Systemd-Service.

**KB-Seeder** (`files/neu/seed_osticket_kb.py`)
Python-Skript zur automatischen Befüllung der osTicket-Datenbank mit realistischen Demo-Wissensartikeln (370 Einträge, schema-agnostisch, idempotent).

**AI-Reply-Plugin – grundlegend erweitert** (`files/plugin_geaendert/`)
Das Basis-Plugin wurde um 10 neue PHP-Klassen ergänzt: RAG-Client, KB-Retriever, Context-Builder, Response-Parser, Note-Writer, PII-Redactor, Rate-Limiter, Log-Writer, Event-Router, Gating-Logic. Das Plugin ist damit nicht mehr ein einfacher LLM-Connector, sondern eine vollständige Verarbeitungspipeline mit RAG-Integration, PII-Schutz, strukturiertem JSON-Output und konfiguriertem Gating.

**Installations-Skript** (`install-debian13.sh` im Repo-Root)
Vollautomatisches 9-Schritte-Bash-Skript für Debian 13 inkl. AI-Chain-Validierung.

**Datenbank & Exporte** (`files/neu/exports/`)
SQL-Exports der befüllten Wissensdatenbank, des AI-Logging-Schemas und ein vollständiger Datenbankdump.

Eine detaillierte Beschreibung aller Komponenten steht in [`SUMMARY.md`](./SUMMARY.md).

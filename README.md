# Abgabe Orbitalis: osTicket + AI Reply Assistant + Local RAG

## Projektziel

Dieses Abgabeprojekt erweitert osTicket um eine lokale, KI-gestuetzte Entwurfsantwort fuer Support-Tickets.
Die Antwortentwuerfe werden als **Internal Note** erstellt (kein automatischer Kundenversand).

Kernidee:
- LLM lokal ueber Ollama (`gemma3:4b`)
- Retrieval ueber lokalen RAG-Service (LlamaIndex + Ollama Embeddings)
- Knowledgebase-Befuellung per idempotentem Seeder

## Architektur (Kurz)

1. Agent klickt in osTicket auf `AI Draft`.
2. Plugin baut Kontext aus Ticketverlauf, Metadaten, optional Bildanhaengen und KB-Hits.
3. Plugin fragt den lokalen RAG-Service (`/query`) nach relevanten FAQ/Kategorie-Treffern.
4. Plugin sendet Prompt an lokales LLM (`/v1/chat/completions` via Ollama).
5. Ergebnis wird geparst und als Internal Note gespeichert.

## Inhalt dieses Abgabeordners

- `TicksystemOrbitalis/`
  - Vollstaendiger Projektstand (Klon des aktuellen Systems) inkl. osTicket, Plugin, RAG-Service, Seeder, Doku.
- `Eigenleistungen/`
  - Nachweisordner mit den eigen erstellten/angepassten Dateien als Kopien.
  - Enthalten: `MANIFEST.csv`, `SUMMARY.md`, `baselines.lock`, Diff-Reports.

## Laufzeitmodell / Ports

- Web (osTicket/Apache): `80` (optional `443`)
- RAG-Service: `127.0.0.1:8099`
- Ollama: `127.0.0.1:11434`
- Datenbank: `127.0.0.1:3306` (oder intern)

Empfehlung: Extern nur Web exponieren; RAG/Ollama/DB intern halten.

## Relevante Komponenten im Code

- Plugin: `TicksystemOrbitalis/include/plugins/ai-reply-assistant/`
- RAG-Service: `TicksystemOrbitalis/tools/kb_rag_service/app.py`
- Seeder: `TicksystemOrbitalis/seed_osticket_kb.py`
- Projektdokumentation: `TicksystemOrbitalis/docs/`
- Eigenleistungsnachweis: `Eigenleistungen/`

## Startpunkt fuer die fachliche Bewertung

1. `TicksystemOrbitalis/README.md` (vollstaendige technische Doku)
2. `Eigenleistungen/SUMMARY.md` (kompakter Eigenleistungsueberblick)
3. `Eigenleistungen/MANIFEST.csv` (dateigenaue Nachweise inkl. Hashes)

## Website-Referenzen

### AI Reply Assistant

- Projektseite: https://github.com/sasabajic/AI-Reply-Assistant-Plugin-for-osTicket

### osTicket

- Website: https://osticket.com
- Dokumentation: https://docs.osticket.com

### LlamaIndex

- Dokumentation: https://docs.llamaindex.ai/en/stable/
- Website: https://www.llamaindex.ai/

### Ollama

- Website: https://ollama.com
- Dokumentation: https://docs.ollama.com

## GitHub-Repository (Ziel)

`https://github.com/YannickBeck/Abgabe_Orbitalis.git`

## Push-Befehle

```bash
cd "/osTicket/Abgabe Orbitalis"
git init
git add .
git commit -m "Initial submission package"
git remote add origin https://github.com/YannickBeck/Abgabe_Orbitalis.git
git branch -M main
git push -u origin main
```

Falls `origin` bereits existiert:

```bash
git remote set-url origin https://github.com/YannickBeck/Abgabe_Orbitalis.git
git push -u origin main
```

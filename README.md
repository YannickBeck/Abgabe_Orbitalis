# Orbitalis – osTicket mit lokalem AI-Support

**osTicket erweitert um KI-gestützte Antwortvorschläge** – vollständig lokal, ohne Cloud-Abhängigkeit.

Das System generiert automatisch Antwortentwürfe für Support-Tickets als interne Notiz. Ein Agent kann den Entwurf prüfen, anpassen und dann erst abschicken. Kein automatischer Kundenversand, keine Datenweitergabe an externe Dienste.

---

## Wie funktioniert das System?

```
Ticket eingeht  →  Plugin analysiert Kontext
                →  RAG-Service sucht relevante KB-Artikel
                →  Lokales LLM (Ollama) generiert Antwort
                →  Entwurf erscheint als interne Notiz
                →  Agent prüft und sendet manuell
```

**Komponenten:**
- **osTicket** – Open-Source-Helpdesksystem (PHP/Apache/MariaDB)
- **AI Reply Assistant Plugin** – PHP-Plugin, das den Entwurf-Workflow steuert
- **RAG-Service** – Python/FastAPI-Dienst für semantische Wissensbasis-Suche (LlamaIndex)
- **Ollama** – Lokaler LLM-Runner (`gemma3:4b` + `embeddinggemma`)

---

## Schnellstart

> Getestet auf **Debian 13 (Trixie)**. Benötigt: root/sudo, Internetverbindung, ~10 GB freier Speicher, ~8 GB RAM.

```bash
git clone https://github.com/YannickBeck/Abgabe_Orbitalis.git
cd Abgabe_Orbitalis
chmod +x install-debian13.sh
sudo ./install-debian13.sh
```

Das Skript erledigt alles automatisch in 9 Schritten: Pakete, Datenbank, osTicket, Python-Umgebung, Ollama-Modelle, RAG-Service und Wissensbasis-Befüllung. Am Ende zeigt es eine Zusammenfassung mit URL, Zugangsdaten und nächsten Schritten.

> **Einziger manueller Schritt danach:** Das Plugin in der osTicket-Admin-Oberfläche aktivieren – [siehe unten](#plugin-aktivieren).

---

## Voraussetzungen

| Anforderung | Detail |
|-------------|--------|
| Betriebssystem | Debian 13 (Trixie) – andere Debian/Ubuntu-Versionen mit Anpassungen |
| RAM | mind. 8 GB (Modelle: ~3,3 GB + ~500 MB) |
| Speicher | mind. 10 GB frei |
| Rechte | `root` oder `sudo` |
| Netzwerk | Internetverbindung für Pakete und Modell-Downloads |
| Ports | 80 (Web), 8099 (RAG intern), 11434 (Ollama intern), 3306 (DB intern) |

---

## Manuelle Installation (Schritt für Schritt)

Falls du das Skript nicht nutzen willst oder ein anderes System einrichtest:

### Schritt 1 – System-Pakete installieren

```bash
apt update && apt install -y \
  apache2 php8.4 php8.4-{cli,mysql,xml,mbstring,curl,gd,intl,apcu,zip} \
  libapache2-mod-php8.4 mariadb-server python3 python3-pip python3-venv \
  git curl

a2enmod php8.4 rewrite
systemctl enable --now apache2 mariadb
```

### Schritt 2 – Ollama installieren

```bash
curl -fsSL https://ollama.com/install.sh | sh
systemctl enable --now ollama

# Auf Ollama warten
sleep 10 && curl -s http://127.0.0.1:11434/api/tags | grep -q "models" && echo "Ollama läuft"
```

### Schritt 3 – Datenbank einrichten

```bash
mysql -u root <<'SQL'
CREATE DATABASE IF NOT EXISTS osticket CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'osticket'@'localhost' IDENTIFIED BY 'DEIN_PASSWORT';
GRANT ALL PRIVILEGES ON osticket.* TO 'osticket'@'localhost';
FLUSH PRIVILEGES;
SQL
```

> Ersetze `DEIN_PASSWORT` durch ein sicheres Passwort. Dieses brauchst du in Schritt 5.

### Schritt 4 – osTicket deployen

```bash
# Repository-Dateien nach /var/www/osticket kopieren
rsync -a TicksystemOrbitalis/ /var/www/osticket/
chown -R www-data:www-data /var/www/osticket/

# Konfiguration anlegen
cp /var/www/osticket/include/ost-sampleconfig.php /var/www/osticket/include/ost-config.php
chmod 0666 /var/www/osticket/include/ost-config.php
```

**Apache-VirtualHost** (`/etc/apache2/sites-available/osticket.conf`):

```apache
<VirtualHost *:80>
    DocumentRoot /var/www/osticket
    <Directory /var/www/osticket>
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

```bash
a2ensite osticket && systemctl reload apache2
```

Dann Installer aufrufen: `http://localhost/setup/install.php` und die Schritte durchgehen (DB-Zugangsdaten aus Schritt 3 eingeben).

Nach der Installation:

```bash
chmod 0644 /var/www/osticket/include/ost-config.php
rm -rf /var/www/osticket/setup/
```

### Schritt 5 – Python-Umgebung und Abhängigkeiten

```bash
python3 -m venv /opt/osticket-kb-rag/.venv
/opt/osticket-kb-rag/.venv/bin/pip install -r /var/www/osticket/tools/kb_rag_service/requirements.txt
```

### Schritt 6 – LLM- und Embedding-Modelle herunterladen

```bash
ollama pull gemma3:4b          # ~3,3 GB – LLM für Antwortgenerierung
ollama pull embeddinggemma     # ~500 MB – Embeddings für semantische Suche
```

> Die Downloads können je nach Verbindung 5–20 Minuten dauern.

### Schritt 7 – RAG-Service als Systemd-Dienst einrichten

Erstelle `/etc/systemd/system/osticket-kb-rag.service`:

```ini
[Unit]
Description=osTicket KB RAG Service
After=network.target ollama.service mariadb.service
Wants=ollama.service mariadb.service

[Service]
User=www-data
WorkingDirectory=/var/www/osticket/tools/kb_rag_service
ExecStart=/opt/osticket-kb-rag/.venv/bin/uvicorn app:app --host 127.0.0.1 --port 8099
Restart=on-failure
Environment=OSTICKET_ROOT=/var/www/osticket
Environment=OLLAMA_BASE_URL=http://127.0.0.1:11434
Environment=OLLAMA_EMBED_MODEL=embeddinggemma:latest
Environment=RAG_REFRESH_SECONDS=300
Environment=RAG_EMBED_BATCH_SIZE=4
Environment=RAG_MAX_EMBED_CHARS=1600
Environment=RAG_EMBED_TIMEOUT_SECONDS=600

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl enable --now osticket-kb-rag

# Auf Service warten
sleep 15 && curl -s http://127.0.0.1:8099/health
```

### Schritt 8 – Wissensbasis befüllen

```bash
cd /var/www/osticket
/opt/osticket-kb-rag/.venv/bin/python seed_osticket_kb.py --apply

# RAG-Index neu aufbauen
curl -s -X POST http://127.0.0.1:8099/reindex
sleep 30 && curl -s http://127.0.0.1:8099/health | python3 -c "import sys,json; d=json.load(sys.stdin); print('Dokumente:', d.get('doc_count', 0))"
```

---

## Plugin aktivieren

Nach der Installation muss das AI-Reply-Assistant-Plugin einmalig manuell in osTicket aktiviert werden:

1. Öffne `http://localhost/scp/admin.php` → melde dich als Admin an
2. **Admin Panel** → **Manage** → **Plugins**
3. Klicke auf **Add New Plugin**
4. Wähle **AI Reply Assistant** → klicke **Install**
5. Gehe zu **Instances** → **Add New Instance**
6. Konfiguriere die Instanz:

| Einstellung | Wert |
|-------------|------|
| LLM Base URL | `http://127.0.0.1:11434/v1` |
| Model | `gemma3:4b` |
| RAG Service URL | `http://127.0.0.1:8099` |
| RAG aktiviert | ✓ (Checkbox) |
| Plugin aktiviert | ✓ (Checkbox) |

7. **Save Changes**

Ab jetzt erscheint in jedem Ticket der Button **AI Draft**.

---

## Testen

Schnellcheck nach der Installation:

```bash
# osTicket erreichbar?
curl -s -o /dev/null -w "%{http_code}" http://localhost/
# Erwarte: 200

# RAG-Service läuft?
curl -s http://127.0.0.1:8099/health
# Erwarte: {"status":"ok","doc_count":N}

# Ollama läuft?
curl -s http://127.0.0.1:11434/api/tags | python3 -c "import sys,json; m=json.load(sys.stdin)['models']; print([x['name'] for x in m])"
# Erwarte: ['gemma3:4b', 'embeddinggemma:latest']

# RAG-Abfrage testen
curl -s -X POST http://127.0.0.1:8099/query \
  -H "Content-Type: application/json" \
  -d '{"query":"Wie kann ich mein Passwort zurücksetzen?","top_k":3}'
```

**Funktionstest in osTicket:**
1. Erstelle ein Test-Ticket über `http://localhost/open.php`
2. Öffne das Ticket als Agent im SCP (`http://localhost/scp/`)
3. Klicke auf **AI Draft**
4. Prüfe ob eine interne Notiz mit einem Antwortvorschlag erscheint

---

## Häufige Fehler und Lösungen

**Port 80 ist belegt**
Das Installationsskript erkennt das automatisch und wechselt auf Port 8082. Falls manuell: VirtualHost-Port anpassen und `ports.conf` aktualisieren.

```bash
# Port überprüfen
ss -tlnp | grep ':80'
```

**RAG-Service startet nicht**
```bash
systemctl status osticket-kb-rag
journalctl -u osticket-kb-rag -n 50
```
Häufige Ursache: Ollama noch nicht bereit. Sicherstellen: `curl http://127.0.0.1:11434/api/tags`

**doc_count = 0 nach Seeding**
```bash
# Manuell neu seeden
cd /var/www/osticket
/opt/osticket-kb-rag/.venv/bin/python seed_osticket_kb.py --apply
curl -X POST http://127.0.0.1:8099/reindex
```
Ursache: osTicket-Wissensbasis leer → zuerst Kategorien und FAQs in osTicket anlegen.

**AI Draft Schaltfläche fehlt**
Plugin ist nicht aktiviert oder hat keine aktive Instanz. Schritte unter [Plugin aktivieren](#plugin-aktivieren) wiederholen.

**LLM antwortet nicht / Timeout**
```bash
ollama list        # Modelle vorhanden?
ollama run gemma3:4b "Test"   # Modell manuell testen
```
Beim ersten Aufruf nach dem Systemstart kann das Laden des Modells 20–60 Sekunden dauern.

**Datenbankfehler bei Installation**
```bash
mysql -u osticket -p osticket -e "SHOW TABLES;" | wc -l
# Sollte > 50 Tabellen zeigen
```
Falls 0: osTicket-Installer nochmal aufrufen (`http://localhost/setup/install.php`).

---

## Projektstruktur

```
Abgabe_Orbitalis/
├── README.md                        ← diese Datei
├── install-debian13.sh              ← Schnellstart-Installationsskript
│
├── TicksystemOrbitalis/             ← vollständige osTicket-Installation
│   ├── include/plugins/
│   │   └── ai-reply-assistant/      ← AI-Plugin (Kern der Eigenleistung)
│   │       ├── class.AiReplyPlugin.php
│   │       ├── classes/             ← Komponenten (RAG, PII, Logging, ...)
│   │       ├── config.php
│   │       └── migrations/
│   ├── tools/
│   │   └── kb_rag_service/          ← Python RAG-Service
│   │       ├── app.py               ← FastAPI-Anwendung
│   │       ├── requirements.txt
│   │       └── systemd/             ← Systemd-Service-Template
│   ├── seed_osticket_kb.py          ← Wissensbasis-Seeder
│   ├── docs/                        ← technische Dokumentation (14 Dokumente)
│   ├── REPOSITORY_MAP.md            ← Übersicht der Projektstruktur
│   └── [osTicket-Kern...]           ← PHP-Klassen, Assets, API, SCP
│
└── Eigenleistungen/                 ← Eigenleistungsnachweis
    ├── SUMMARY.md                   ← kompakter Überblick der Eigenleistung
    ├── MANIFEST.csv                 ← dateigenaue Nachweise inkl. Hashes
    ├── README_EIGENLEISTUNG.md
    ├── files/
    │   ├── doku/docs/               ← 13 Markdown-Dokumente
    │   ├── neu/                     ← neue Komponenten (RAG, Seeder, Exports)
    │   └── plugin_geaendert/        ← modifizierte Plugin-Dateien
    └── reports/                     ← Diff-Berichte

```

---

## Referenzen

- [osTicket](https://osticket.com) – Open-Source-Helpdesksystem
- [AI Reply Assistant (Original)](https://github.com/sasabajic/AI-Reply-Assistant-Plugin-for-osTicket) – Basis-Plugin
- [Ollama](https://ollama.com) – Lokaler LLM-Runner
- [LlamaIndex](https://docs.llamaindex.ai/) – RAG-Framework

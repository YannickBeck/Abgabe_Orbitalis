# 07 Deployment and Operations

## Ziel

Betrieb der Loesung auf Linux mit osTicket, lokalem Ollama und lokalem RAG-Service.

## Port- und Service-Modell

| Komponente | Standardbindung | Zweck |
|---|---|---|
| Apache/osTicket | `0.0.0.0:80` und optional `:443` | Web UI + API |
| RAG Service | `127.0.0.1:8099` | internes KB Retrieval |
| Ollama | `127.0.0.1:11434` | lokale LLM/Embedding API |
| MySQL/MariaDB | `127.0.0.1:3306` oder intern | osTicket Datenbank |

Sicherheitsprinzip: Nur Web-Port extern exponieren, RAG/Ollama intern halten.

## Installation (Python/PEP668-kompatibel)

```bash
sudo apt update
sudo apt install -y python3-venv
sudo mkdir -p /opt/osticket-kb-rag
sudo python3 -m venv /opt/osticket-kb-rag/.venv
sudo /opt/osticket-kb-rag/.venv/bin/python -m pip install --upgrade pip
sudo /opt/osticket-kb-rag/.venv/bin/pip install -r <REPO_ROOT>/tools/kb_rag_service/requirements.txt
```

## systemd Deployment

```bash
sudo install -m 644 <REPO_ROOT>/tools/kb_rag_service/systemd/osticket-kb-rag.service /etc/systemd/system/osticket-kb-rag.service
sudo systemctl daemon-reload
sudo systemctl enable --now osticket-kb-rag.service
```

Status/Logs:

```bash
sudo systemctl status osticket-kb-rag.service --no-pager
sudo journalctl -u osticket-kb-rag.service -n 200 --no-pager
```

## osTicket / Apache Betrieb

```bash
sudo systemctl status apache2 --no-pager
sudo systemctl reload apache2
```

## Seeder Lauf

```bash
cd <REPO_ROOT>
python3 seed_osticket_kb.py --dry-run
python3 seed_osticket_kb.py --apply
```

## Service Health und Reindex

```bash
curl -sS <RAG_SERVICE_URL>/health
curl -sS -X POST <RAG_SERVICE_URL>/reindex
curl -sS -X POST <RAG_SERVICE_URL>/query -H 'Content-Type: application/json' -d '{"subject":"Outlook","latest_message":"startet nicht","top_k":3}'
```

## Operativer Start/Stop

```bash
sudo systemctl restart osticket-kb-rag.service
sudo systemctl stop osticket-kb-rag.service
sudo systemctl start osticket-kb-rag.service
```

## Laufende Portpruefung

```bash
sudo ss -tulpen | grep -E ':80|:443|:8099|:11434|:3306'
```

## Cloudflare Tunnel (theoretische Exponierung)

Empfehlung:

1. Tunnel nur auf `<OSTICKET_BASE_URL>` (`80/443`) routen.
2. Keine Exponierung von `8099` und `11434` nach extern.
3. Plugin greift intern auf RAG/Ollama per Loopback zu.

Beispielkonzept:

- Public: `helpdesk.example.tld` -> lokaler Apache
- Private intern: RAG/Ollama bleiben `127.0.0.1`

## Betriebschecks nach Deploy

1. Plugin in osTicket aktiv und konfiguriert
2. RAG `health` zeigt `ok` und `doc_count > 0`
3. Manueller AI Draft erzeugt Internal Note
4. Keine fatalen Fehler in Apache/PHP/systemd Logs

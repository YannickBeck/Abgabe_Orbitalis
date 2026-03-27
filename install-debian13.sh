#!/usr/bin/env bash
# =============================================================================
# Orbitalis – Vollständiges Installationsskript
# Führt alle 9 Schritte der README automatisch aus.
#
# Verwendung:
#   chmod +x install.sh
#   sudo ./install.sh
#
# Getestet auf: Debian 13 (Trixie)
# =============================================================================
set -euo pipefail
trap 'echo -e "\n${RED}[FEHLER]${NC} Skript abgebrochen in Zeile $LINENO. Logs: /tmp/orbitalis_install.log" | tee /dev/tty >&2' ERR

# ---------------------------------------------------------------------------
# Farben & Logging
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

LOG=/tmp/orbitalis_install.log
# Log-Datei gehört root (Skript läuft als root), damit tee immer schreiben kann
touch "$LOG" && chmod 640 "$LOG" 2>/dev/null || true
exec > >(tee -a "$LOG") 2>&1

info()    { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()      { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[FEHLER]${NC} $*" >&2; exit 1; }
step()    { echo -e "\n${BOLD}${BLUE}══════════════════════════════════════════${NC}"; \
            echo -e "${BOLD}  $*${NC}"; \
            echo -e "${BOLD}${BLUE}══════════════════════════════════════════${NC}"; }

# Fortschrittsbalken: progress <aktuell> <gesamt> <label>
progress() {
    local current=$1 total=$2 label=$3
    local width=40
    local filled=$(( current * width / total ))
    local empty=$(( width - filled ))
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    local pct=$(( current * 100 / total ))
    echo -e "\n  ${BOLD}Fortschritt: [${GREEN}${bar}${NC}${BOLD}] ${pct}% – Schritt ${current}/${total}: ${label}${NC}\n"
}

# ---------------------------------------------------------------------------
# Konfiguration (anpassbar)
# ---------------------------------------------------------------------------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OSTICKET_DIR="/var/www/osticket"
VENV_DIR="/opt/osticket-kb-rag/.venv"
CLONE_DIR="$HOME/abgabe-orbitalis"
REPO_URL="https://github.com/YannickBeck/Abgabe_Orbitalis.git"

DB_NAME="osticket"
DB_USER="osticket"
DB_PASS=""          # wird interaktiv abgefragt
ADMIN_EMAIL=""      # wird interaktiv abgefragt
ADMIN_FNAME="Admin"
ADMIN_LNAME="User"
ADMIN_USER="ostadmin"
ADMIN_PASS=""       # wird interaktiv abgefragt
SYSTEM_EMAIL="system@ki-projekt.local"

OSTICKET_PORT=80    # wird automatisch angepasst bei Port-Konflikt
RAG_PORT=8099
LLM_MODEL="gemma3:4b"
EMBED_MODEL="embeddinggemma:latest"

# ---------------------------------------------------------------------------
# Hilfsfunktionen
# ---------------------------------------------------------------------------
php_version() {
    php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || echo ""
}

port_free() {
    ! ss -tlnp 2>/dev/null | grep -q ":${1} "
}

service_active() {
    systemctl is-active --quiet "$1" 2>/dev/null
}

wait_for_port() {
    local port=$1 retries=${2:-20}
    for i in $(seq 1 $retries); do
        if curl -s --max-time 2 "http://127.0.0.1:${port}/" >/dev/null 2>&1; then
            return 0
        fi
        sleep 2
    done
    return 1
}

# ---------------------------------------------------------------------------
# 0. Pre-flight Checks
# ---------------------------------------------------------------------------
preflight() {
    step "Pre-flight Checks"

    # Root / sudo
    if [[ $EUID -ne 0 ]]; then
        error "Dieses Skript muss als root ausgeführt werden: sudo ./install.sh"
    fi
    ok "Root-Rechte vorhanden"

    # Debian 13 (Trixie)
    local os_pretty
    os_pretty=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
    if ! grep -qiE "debian" /etc/os-release 2>/dev/null; then
        warn "Dieses Skript wurde für Debian 13 entwickelt. Andere Distributionen sind nicht getestet."
    elif ! grep -qiE "trixie|13" /etc/os-release 2>/dev/null; then
        warn "Erkannte Distribution: ${os_pretty}. Dieses Skript ist für Debian 13 (Trixie) optimiert."
    else
        ok "Betriebssystem: ${os_pretty}"
    fi

    # Festplatte ≥ 5 GB frei
    FREE_KB=$(df / | awk 'NR==2 {print $4}')
    if [[ $FREE_KB -lt 5242880 ]]; then
        error "Nicht genug freier Speicherplatz. Mindestens 5 GB erforderlich (aktuell: $((FREE_KB/1024/1024)) GB)."
    fi
    ok "Freier Speicher: $((FREE_KB/1024/1024)) GB"

    # Internetverbindung
    if ! curl -sS --max-time 5 https://api.github.com >/dev/null 2>&1; then
        error "Keine Internetverbindung. Bitte prüfen und erneut ausführen."
    fi
    ok "Internetverbindung verfügbar"

    # Port-Erkennung
    if ! port_free 80; then
        warn "Port 80 ist belegt – verwende Port 8082 für osTicket."
        OSTICKET_PORT=8082
    else
        ok "Port 80 ist frei"
    fi

    if ! port_free $RAG_PORT; then
        warn "Port $RAG_PORT ist belegt – RAG-Service wird auf 8100 gestartet."
        RAG_PORT=8100
    else
        ok "Port $RAG_PORT ist frei"
    fi
}

# ---------------------------------------------------------------------------
# Interaktive Eingabe der Zugangsdaten
# ---------------------------------------------------------------------------
prompt_credentials() {
    step "Zugangsdaten konfigurieren"
    echo ""

    # DB-Passwort
    while [[ -z "$DB_PASS" ]]; do
        read -rsp "  Datenbankpasswort für User '${DB_USER}': " DB_PASS || true
        echo ""
        if [[ -z "$DB_PASS" ]]; then
            warn "Passwort darf nicht leer sein."
        fi
    done

    # Admin-E-Mail
    while [[ -z "$ADMIN_EMAIL" ]] || ! echo "$ADMIN_EMAIL" | grep -qE '^[^@]+@[^@]+\.[^@]+$'; do
        read -rp "  Admin E-Mail-Adresse: " ADMIN_EMAIL || true
        if ! echo "$ADMIN_EMAIL" | grep -qE '^[^@]+@[^@]+\.[^@]+$'; then
            warn "Ungültige E-Mail-Adresse."
            ADMIN_EMAIL=""
        fi
    done

    # Admin-Passwort
    while [[ -z "$ADMIN_PASS" ]] || [[ ${#ADMIN_PASS} -lt 8 ]]; do
        read -rsp "  Admin-Passwort (min. 8 Zeichen): " ADMIN_PASS || true
        echo ""
        if [[ ${#ADMIN_PASS} -lt 8 ]]; then
            warn "Passwort muss mindestens 8 Zeichen lang sein."
            ADMIN_PASS=""
        fi
    done

    echo ""
    info "Konfiguration:"
    info "  osTicket-URL : http://localhost:${OSTICKET_PORT}"
    info "  Datenbank    : ${DB_NAME} (User: ${DB_USER})"
    info "  Admin-Login  : ${ADMIN_USER} / ${ADMIN_EMAIL}"
    info "  RAG-Port     : ${RAG_PORT}"
    echo ""
}

# ---------------------------------------------------------------------------
# Schritt 1: System-Pakete installieren (README: Voraussetzungen)
# ---------------------------------------------------------------------------
step1_packages() {
    step "Schritt 1/9 – System-Pakete installieren"

    info "Paketlisten aktualisieren..."
    apt-get update -qq || error "apt-get update fehlgeschlagen (APT-Lock oder Netzwerkproblem?)"

    info "PHP + Erweiterungen installieren..."
    # Hinweis Debian 13 / PHP 8.4+: php-json ist seit PHP 8.0 fest eingebaut
    # und existiert nicht mehr als separates Paket. php-zip erfordert libzip5.
    apt-get install -y -qq \
        php php-cli php-mysql php-xml php-mbstring php-curl php-gd php-intl \
        php-apcu php-zip || error "PHP-Pakete konnten nicht installiert werden."

    info "Apache, MariaDB, Python, Git installieren..."
    # Debian 13 liefert Python 3.13 und MariaDB 11.4 LTS
    apt-get install -y -qq apache2 mariadb-server python3 python3-pip python3-venv git curl \
        || error "Apache/MariaDB/Python/Git konnten nicht installiert werden."

    # Apache-Module aktivieren
    local phpver
    phpver=$(php_version)
    if [[ -z "$phpver" ]]; then
        error "PHP konnte nicht ermittelt werden."
    fi
    # Debian 13: libapache2-mod-php muss explizit installiert werden
    # Beide apt-Versuche mit || warn absichern: Paket könnte bereits installiert
    # oder APT-Lock nach dem vorherigen apt-get noch kurz belegt sein.
    apt-get install -y -qq "libapache2-mod-php${phpver}" 2>/dev/null \
        || apt-get install -y -qq libapache2-mod-php 2>/dev/null \
        || warn "libapache2-mod-php konnte nicht installiert werden – möglicherweise bereits vorhanden."
    a2enmod "php${phpver}" >/dev/null 2>&1 || true
    a2enmod rewrite >/dev/null 2>&1 || true

    systemctl enable apache2 >/dev/null 2>&1 || true
    systemctl enable mariadb >/dev/null 2>&1 || true
    systemctl start apache2 || warn "Apache konnte nicht gestartet werden – prüfe: systemctl status apache2"
    systemctl start mariadb || warn "MariaDB konnte nicht gestartet werden – prüfe: systemctl status mariadb"

    # /usr/sbin ist nicht in jedem PATH (z.B. sudo ohne -i) → explizit hinzufügen
    # || true verhindert Abbruch falls apache2 dennoch non-zero zurückgibt
    local apache_ver
    apache_ver=$(PATH="/usr/sbin:${PATH}" apache2 -v 2>/dev/null | awk 'NR==1{print $3}') || true
    ok "PHP ${phpver}, ${apache_ver:-Apache installiert}, MariaDB installiert"
}

# ---------------------------------------------------------------------------
# Schritt 2: Ollama installieren (README: Ollama installieren)
# ---------------------------------------------------------------------------
step2_ollama() {
    step "Schritt 2/9 – Ollama installieren"

    if command -v ollama &>/dev/null; then
        ok "Ollama bereits installiert: $(ollama --version 2>&1 | head -1)"
    else
        info "Ollama wird installiert..."
        curl -fsSL https://ollama.com/install.sh | sh
        ok "Ollama installiert"
    fi

    systemctl enable --now ollama >/dev/null 2>&1 || true

    # Warten bis Ollama bereit ist (max. 30 s), statt blindem sleep
    info "Warte auf Ollama-Start..."
    local ollama_ready=false
    for i in $(seq 1 15); do
        if ollama list >/dev/null 2>&1; then
            ollama_ready=true
            break
        fi
        sleep 2
    done
    if ! $ollama_ready; then
        error "Ollama reagiert nicht nach 30 s. Bitte prüfen: systemctl status ollama"
    fi
    ok "Ollama läuft: $(ollama --version 2>&1 | head -1)"
}

# ---------------------------------------------------------------------------
# Schritt 3: Repository klonen (README: Schritt 1)
# ---------------------------------------------------------------------------
step3_clone() {
    step "Schritt 3/9 – Repository klonen"

    # Wenn das Skript bereits aus dem Repo heraus gestartet wurde, ist kein Klon nötig
    if [[ -d "${REPO_DIR}/include" && -d "${REPO_DIR}/tools" ]]; then
        info "Skript läuft bereits im Repository-Verzeichnis: ${REPO_DIR}"
        CLONE_DIR="$(dirname "$REPO_DIR")"
        ok "Kein Klon nötig – verwende: ${REPO_DIR}"
        return 0
    fi

    if [[ -d "${CLONE_DIR}/TicksystemOrbitalis" ]]; then
        warn "Repository bereits geklont unter ${CLONE_DIR} – überspringe Klon."
    else
        info "Klone Repository nach ${CLONE_DIR}..."
        git clone "$REPO_URL" "$CLONE_DIR"
        ok "Repository geklont"
    fi

    REPO_DIR="${CLONE_DIR}/TicksystemOrbitalis"
    [[ -d "$REPO_DIR" ]] || error "TicksystemOrbitalis-Verzeichnis nicht gefunden in ${CLONE_DIR}"
    ok "Repo-Verzeichnis: ${REPO_DIR}"
}

# ---------------------------------------------------------------------------
# Schritt 4: Datenbank einrichten (README: Schritt 2)
# ---------------------------------------------------------------------------
step4_database() {
    step "Schritt 4/9 – Datenbank einrichten"

    # Idempotenz: Wenn osTicket bereits installiert ist, ist ost-config.php die
    # einzige verlässliche Quelle für das DB-Passwort.
    # → Verbindung mit dem gespeicherten Passwort testen.
    # → Funktioniert sie: überspringen (verhindert Passwort-Mismatch bei Wiederholung).
    # → Funktioniert sie nicht: User neu anlegen MIT dem Passwort aus ost-config.php
    #   (ost-config.php bleibt immer konsistent mit MariaDB).
    local config_php="${OSTICKET_DIR}/include/ost-config.php"
    if grep -q "define('OSTINSTALLED',TRUE)" "${config_php}" 2>/dev/null; then
        local existing_pass
        existing_pass=$(grep -oP "define\('DBPASS','\K[^']*(?='\))" "${config_php}" 2>/dev/null || true)
        if [[ -n "$existing_pass" ]]; then
            local testcnf
            testcnf=$(mktemp /root/.my_install_XXXXXX.cnf)
            chmod 600 "$testcnf"
            local ep="${existing_pass//\\/\\\\}"; ep="${ep//\"/\\\"}"; ep="${ep//#/\\#}"
            printf '[client]\nuser=%s\npassword="%s"\n' "${DB_USER}" "${ep}" > "$testcnf"
            if mysql --defaults-file="$testcnf" "${DB_NAME}" -e "SELECT 1;" >/dev/null 2>&1; then
                rm -f "$testcnf"
                ok "Datenbank bereits eingerichtet und erreichbar – überspringe Setup."
                return 0
            fi
            # Verbindung schlägt fehl (z.B. User gelöscht) → neu anlegen mit
            # dem in ost-config.php gespeicherten Passwort (bleibt konsistent).
            rm -f "$testcnf"
            warn "DB-Verbindung fehlgeschlagen – User wird neu angelegt (Passwort aus ost-config.php)."
            DB_PASS="$existing_pass"
        fi
    fi

    # Sichere Passwort-Handhabung:
    #   - SQL via temp-Datei (chmod 600), nicht als -e Argument → kein ps-Leak
    #   - Passwort via .cnf-Datei für Verbindungstest → kein Passwort in ps-Output
    #   - printf %s für SQL-Werte → keine Bash-Expansion von $, \, Backticks im Passwort
    #   - Einfache Anführungszeichen im Passwort SQL-konform verdoppelt ('')
    local mycnf sqltmp
    mycnf=$(mktemp /root/.my_install_XXXXXX.cnf)
    sqltmp=$(mktemp /root/.my_install_XXXXXX.sql)
    chmod 600 "$mycnf" "$sqltmp"

    # Credentials-Datei für Verbindungstest (Passwort nicht als CLI-Argument).
    # Passwort doppelt-gequotet + Sonderzeichen für MySQL-Option-Dateien escapen:
    #   \ → \\  (zuerst, sonst doppeltes Escaping)
    #   " → \"  (schützt den doppelten Anführungszeichen-Delimiter)
    #   # → \#  (verhindert Kommentar-Interpretation)
    local pass_cnf="${DB_PASS//\\/\\\\}"
    pass_cnf="${pass_cnf//\"/\\\"}"
    pass_cnf="${pass_cnf//#/\\#}"
    printf '[client]\nuser=%s\npassword="%s"\n' "${DB_USER}" "${pass_cnf}" > "$mycnf"

    # Einfache Anführungszeichen in SQL verdoppeln (Standard-SQL-Escape)
    local db_pass_sql
    db_pass_sql=$(printf '%s' "${DB_PASS}" | sed "s/'/''/g")

    # SQL als Datei – printf %s schützt vor Bash-Expansion in Passwort-Werten.
    # CREATE OR REPLACE USER (MariaDB): setzt Passwort IMMER – auch bei Wiederholung.
    # CREATE USER IF NOT EXISTS würde bei bestehendem User das Passwort NICHT ändern.
    {
        printf "CREATE DATABASE IF NOT EXISTS \`%s\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\n" "${DB_NAME}"
        printf "CREATE OR REPLACE USER '%s'@'localhost' IDENTIFIED BY '%s';\n" "${DB_USER}" "${db_pass_sql}"
        printf "GRANT ALL PRIVILEGES ON \`%s\`.* TO '%s'@'localhost';\n" "${DB_NAME}" "${DB_USER}"
        printf "FLUSH PRIVILEGES;\n"
    } > "$sqltmp"

    mysql < "$sqltmp" || { rm -f "$mycnf" "$sqltmp"; error "Datenbank-Setup fehlgeschlagen."; }
    rm -f "$sqltmp"

    # Verbindung testen – --defaults-file (nicht --defaults-extra-file) stellt sicher,
    # dass NUR unsere Datei verwendet wird und kein System-my.cnf unsere Creds überschreibt.
    if ! mysql --defaults-file="$mycnf" "${DB_NAME}" -e "SELECT 1;" >/dev/null 2>&1; then
        rm -f "$mycnf"
        error "Datenbankverbindung fehlgeschlagen. User '${DB_USER}'@'localhost' oder Passwort prüfen:\n  sudo mysql -e \"SELECT User,Host,plugin FROM mysql.user WHERE User='${DB_USER}';\""
    fi
    rm -f "$mycnf"
    ok "Datenbank '${DB_NAME}' angelegt und Verbindung erfolgreich"
}

# ---------------------------------------------------------------------------
# Schritt 5: osTicket bereitstellen (README: Schritt 3)
# ---------------------------------------------------------------------------
step5_deploy() {
    step "Schritt 5/9 – osTicket bereitstellen"

    # Idempotenz: Wenn ost-config.php bereits eine laufende Installation enthält, überspringen.
    if grep -q "define('OSTINSTALLED',TRUE)" "${OSTICKET_DIR}/include/ost-config.php" 2>/dev/null; then
        ok "osTicket bereits installiert (ost-config.php vorhanden) – überspringe Deploy"
        return 0
    fi

    # Webserver-Verzeichnis
    mkdir -p "${OSTICKET_DIR}"
    chown www-data:www-data "${OSTICKET_DIR}"

    # Dateien kopieren
    info "Kopiere osTicket-Dateien nach ${OSTICKET_DIR}..."
    cp -r "${REPO_DIR}/." "${OSTICKET_DIR}/"

    # Sicherheit: Installationsskripte dürfen nicht über den Webserver erreichbar sein
    rm -f "${OSTICKET_DIR}/install-debian13.sh" "${OSTICKET_DIR}/install.sh"

    chown -R www-data:www-data "${OSTICKET_DIR}"
    find "${OSTICKET_DIR}" -type f -exec chmod 644 {} \;
    find "${OSTICKET_DIR}" -type d -exec chmod 755 {} \;

    # ost-config.php aus Vorlage anlegen (für Installer beschreibbar)
    [[ -f "${OSTICKET_DIR}/include/ost-sampleconfig.php" ]] \
        || error "ost-sampleconfig.php nicht gefunden – Repository-Struktur prüfen."
    cp "${OSTICKET_DIR}/include/ost-sampleconfig.php" "${OSTICKET_DIR}/include/ost-config.php"
    chmod 666 "${OSTICKET_DIR}/include/ost-config.php"

    # Apache VirtualHost schreiben (korrigiert – kein manuelles nano nötig)
    if [[ $OSTICKET_PORT -ne 80 ]]; then
        # Port in ports.conf eintragen falls nötig
        if ! grep -q "Listen ${OSTICKET_PORT}" /etc/apache2/ports.conf; then
            echo "Listen ${OSTICKET_PORT}" >> /etc/apache2/ports.conf
        fi
    fi

    cat > /etc/apache2/sites-available/osticket.conf << EOF
<VirtualHost *:${OSTICKET_PORT}>
    ServerName localhost
    DocumentRoot ${OSTICKET_DIR}

    <Directory ${OSTICKET_DIR}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/osticket_error.log
    CustomLog \${APACHE_LOG_DIR}/osticket_access.log combined
</VirtualHost>
EOF

    a2ensite osticket.conf >/dev/null 2>&1
    a2dissite 000-default.conf >/dev/null 2>&1 || true
    systemctl restart apache2

    # Warten bis Apache antwortet
    info "Warte auf Apache..."
    if ! wait_for_port "$OSTICKET_PORT" 15; then
        error "Apache antwortet nicht auf Port ${OSTICKET_PORT}. Bitte prüfen: systemctl status apache2"
    fi
    ok "Apache läuft auf Port ${OSTICKET_PORT}"

    # Web-Installer via curl ausführen
    info "Führe osTicket-Installer aus..."
    local cookie
    cookie=$(mktemp)

    curl -s -c "$cookie" -b "$cookie" \
        -X POST "http://localhost:${OSTICKET_PORT}/setup/install.php" \
        -d "s=prereq" -o /dev/null

    curl -s -c "$cookie" -b "$cookie" \
        -X POST "http://localhost:${OSTICKET_PORT}/setup/install.php" \
        -d "s=config" -o /dev/null

    local result
    result=$(curl -s -c "$cookie" -b "$cookie" \
        -X POST "http://localhost:${OSTICKET_PORT}/setup/install.php" \
        --data-urlencode "s=install" \
        --data-urlencode "name=Orbitalis Helpdesk" \
        --data-urlencode "email=${SYSTEM_EMAIL}" \
        --data-urlencode "fname=${ADMIN_FNAME}" \
        --data-urlencode "lname=${ADMIN_LNAME}" \
        --data-urlencode "admin_email=${ADMIN_EMAIL}" \
        --data-urlencode "username=${ADMIN_USER}" \
        --data-urlencode "passwd=${ADMIN_PASS}" \
        --data-urlencode "passwd2=${ADMIN_PASS}" \
        --data-urlencode "prefix=ost_" \
        --data-urlencode "dbhost=localhost" \
        --data-urlencode "dbname=${DB_NAME}" \
        --data-urlencode "dbuser=${DB_USER}" \
        --data-urlencode "dbpass=${DB_PASS}" \
        --data-urlencode "timezone=Europe/Berlin")

    rm -f "$cookie"

    if ! echo "$result" | grep -qi "congratulations\|successfully"; then
        local errmsg
        errmsg=$(echo "$result" | grep -oP '(?<=<p class="error">).*?(?=</p>)' | head -1)
        error "Installer fehlgeschlagen. ${errmsg:-Keine Details verfügbar.}"
    fi

    # Setup-Verzeichnis entfernen (Sicherheitsmaßnahme)
    rm -rf "${OSTICKET_DIR}/setup/"

    # ost-config.php auf sicheren Modus setzen
    chmod 644 "${OSTICKET_DIR}/include/ost-config.php"

    ok "osTicket installiert – URL: http://localhost:${OSTICKET_PORT}"
}

# ---------------------------------------------------------------------------
# Schritt 6: Python-Umgebung einrichten (README: Schritt 4)
# ---------------------------------------------------------------------------
step6_python() {
    step "Schritt 6/9 – Python-Umgebung einrichten"

    mkdir -p "$(dirname "$VENV_DIR")"

    if [[ -f "${VENV_DIR}/bin/pip" ]]; then
        ok "Python-venv bereits vorhanden: ${VENV_DIR}"
    else
        info "Erstelle Python-venv..."
        python3 -m venv "$VENV_DIR"
        ok "venv erstellt"
    fi

    info "Installiere Python-Abhängigkeiten..."
    local req_file="${OSTICKET_DIR}/tools/kb_rag_service/requirements.txt"
    [[ -f "$req_file" ]] || error "requirements.txt nicht gefunden: ${req_file}"
    "${VENV_DIR}/bin/pip" install --upgrade pip -q \
        || error "pip-Upgrade fehlgeschlagen."
    "${VENV_DIR}/bin/pip" install -q -r "$req_file" \
        || error "Python-Abhängigkeiten konnten nicht installiert werden."

    # Installations-Test
    if ! "${VENV_DIR}/bin/python" -c "import fastapi, uvicorn, pymysql; from llama_index.core import VectorStoreIndex" 2>/dev/null; then
        error "Python-Pakete konnten nicht importiert werden. Bitte requirements.txt prüfen."
    fi
    ok "Python-Pakete erfolgreich installiert"
}

# ---------------------------------------------------------------------------
# Schritt 7: KI-Modelle herunterladen (README: Schritt 5)
# ---------------------------------------------------------------------------
step7_models() {
    step "Schritt 7/9 – KI-Modelle herunterladen"

    # LLM-Modell
    if ollama list 2>/dev/null | grep -q "^${LLM_MODEL}"; then
        ok "Modell bereits vorhanden: ${LLM_MODEL}"
    else
        info "Lade ${LLM_MODEL} herunter (~3.3 GB – kann einige Minuten dauern)..."
        ollama pull "${LLM_MODEL}"
        ok "${LLM_MODEL} heruntergeladen"
    fi

    # Embedding-Modell (exakter Match mit ':' verhindert Falsch-Treffer bei ähnlichen Namen)
    if ollama list 2>/dev/null | grep -qF "${EMBED_MODEL%:*}:"; then
        ok "Modell bereits vorhanden: ${EMBED_MODEL}"
    else
        info "Lade ${EMBED_MODEL} herunter (~500 MB)..."
        ollama pull "${EMBED_MODEL}"
        ok "${EMBED_MODEL} heruntergeladen"
    fi
}

# ---------------------------------------------------------------------------
# Schritt 8: RAG-Service als Systemdienst (README: Schritt 6)
# ---------------------------------------------------------------------------
step8_rag_service() {
    step "Schritt 8/9 – RAG-Service als Systemdienst einrichten"

    # Service-Datei schreiben (korrigiert – Repo-Vorlage hat falsche Pfade)
    cat > /etc/systemd/system/osticket-kb-rag.service << EOF
[Unit]
Description=osTicket KB RAG Service
After=network.target ollama.service mariadb.service
Wants=ollama.service mariadb.service

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=${OSTICKET_DIR}/tools/kb_rag_service
Environment=OSTICKET_ROOT=${OSTICKET_DIR}
Environment=OSTICKET_BASE_URL=http://localhost:${OSTICKET_PORT}
Environment=OLLAMA_BASE_URL=http://127.0.0.1:11434
Environment=OLLAMA_EMBED_MODEL=${EMBED_MODEL}
Environment=RAG_REFRESH_SECONDS=300
Environment=RAG_EMBED_BATCH_SIZE=4
Environment=RAG_MAX_EMBED_CHARS=1600
Environment=RAG_EMBED_TIMEOUT_SECONDS=600
ExecStart=${VENV_DIR}/bin/python -m uvicorn app:app --host 127.0.0.1 --port ${RAG_PORT}
Restart=always
RestartSec=3
TimeoutStartSec=30

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable osticket-kb-rag.service >/dev/null 2>&1 || true
    systemctl start osticket-kb-rag.service || warn "RAG-Service konnte nicht gestartet werden – prüfe: journalctl -u osticket-kb-rag.service -n 20"

    # Warten bis Service antwortet
    info "Warte auf RAG-Service..."
    local retries=20
    for i in $(seq 1 $retries); do
        if curl -s --max-time 2 "http://127.0.0.1:${RAG_PORT}/health" >/dev/null 2>&1; then
            ok "RAG-Service läuft auf Port ${RAG_PORT}"
            return 0
        fi
        sleep 3
    done
    error "RAG-Service antwortet nicht. Bitte prüfen: journalctl -u osticket-kb-rag.service -n 30"
}

# ---------------------------------------------------------------------------
# Schritt 9: Wissensdatenbank befüllen (README: Schritt 7)
# ---------------------------------------------------------------------------
step9_seed() {
    step "Schritt 9/9 – Wissensdatenbank befüllen"

    local seed_script="${REPO_DIR}/seed_osticket_kb.py"
    [[ -f "$seed_script" ]] || error "seed_osticket_kb.py nicht gefunden unter ${REPO_DIR}"

    info "Befülle Wissensdatenbank..."
    "${VENV_DIR}/bin/python" "$seed_script" --apply --root "${OSTICKET_DIR}" \
        || error "Wissensdatenbank-Befüllung fehlgeschlagen. Skript prüfen: ${seed_script}"
    ok "Wissensdatenbank befüllt"

    # Index neu aufbauen
    info "Baue Vektorindex auf..."
    curl -s -X POST "http://127.0.0.1:${RAG_PORT}/reindex" >/dev/null || warn "Reindex-Anfrage fehlgeschlagen – Service prüfen."

    # Warten bis doc_count > 0
    local retries=15
    for i in $(seq 1 $retries); do
        local doc_count
        doc_count=$(curl -s "http://127.0.0.1:${RAG_PORT}/health" 2>/dev/null \
            | "${VENV_DIR}/bin/python" -c "import sys,json; print(json.load(sys.stdin).get('doc_count',0))" 2>/dev/null || echo 0)
        if [[ "$doc_count" -gt 0 ]]; then
            ok "RAG-Index fertig: ${doc_count} Dokumente indexiert"
            return 0
        fi
        sleep 4
    done
    warn "RAG-Index noch nicht fertig – möglicherweise noch im Aufbau. Prüfen mit: curl http://127.0.0.1:${RAG_PORT}/health"
}

# ---------------------------------------------------------------------------
# Schritt 9b: AI-Chain End-to-End-Test (RAG → LLM → JSON-Output)
# ---------------------------------------------------------------------------
step9b_validate_ai_chain() {
    step "AI-Chain-Validierung – RAG + LLM + JSON-Output"

    local llm_ok=true
    local rag_ok=true

    # ── 1. RAG-Query-Test: gibt reference_url zurück? ──
    info "Teste RAG-Query..."
    local rag_resp
    rag_resp=$(curl -s --max-time 10 -X POST "http://127.0.0.1:${RAG_PORT}/query" \
        -H "Content-Type: application/json" \
        -d '{"query":"Passwort zurücksetzen Login Fehler","top_k":2}' 2>/dev/null)

    if echo "$rag_resp" | "${VENV_DIR}/bin/python" -c \
        "import sys,json; d=json.load(sys.stdin); hits=d.get('results',[]); \
         has_url=any(h.get('reference_url') or h.get('faq_url') for h in hits); \
         exit(0) if has_url and len(hits)>0 else exit(1)" 2>/dev/null; then
        local hit_count
        hit_count=$(echo "$rag_resp" | "${VENV_DIR}/bin/python" -c \
            "import sys,json; print(len(json.load(sys.stdin).get('results',[])))" 2>/dev/null || echo 0)
        ok "RAG-Query liefert ${hit_count} Treffer mit Reference-URLs ✓"
    else
        warn "RAG-Query liefert keine Reference-URLs – Quellen werden im Ticket leer sein"
        warn "Prüfe: curl -X POST http://127.0.0.1:${RAG_PORT}/query -H 'Content-Type: application/json' -d '{\"query\":\"test\",\"top_k\":2}'"
        rag_ok=false
    fi

    # ── 2. LLM-JSON-Test: gibt gemma3:4b gültiges JSON mit Tags und source_urls aus? ──
    info "Teste LLM-JSON-Output (${LLM_MODEL})..."
    info "(Das Modell wird aufgewärmt – kann 30–60 Sekunden dauern...)"

    local test_prompt
    test_prompt='You MUST respond with ONLY a valid JSON object. No text before or after the JSON. Use exactly this structure:
{"reply_subject":"...", "reply_body":"...", "need_more_info":false, "questions":[], "suggested_tags":["tag1","tag2"], "source_urls":[], "confidence":0.8}
Test ticket: User cannot log in. Password reset failed. Tags should be related to login issues.'

    local llm_resp
    llm_resp=$(curl -s --max-time 90 -X POST "http://127.0.0.1:11434/api/generate" \
        -H "Content-Type: application/json" \
        -d "{\"model\":\"${LLM_MODEL}\",\"prompt\":$(echo "$test_prompt" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))'),\"stream\":false}" \
        2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('response',''))" 2>/dev/null)

    if echo "$llm_resp" | python3 -c "
import sys, json, re
text = sys.stdin.read()
# Try to extract JSON from response
for attempt in [text, re.sub(r'.*?(\{.*\}).*', r'\1', text, flags=re.DOTALL)]:
    try:
        d = json.loads(attempt.strip())
        tags = d.get('suggested_tags', [])
        has_body = bool(d.get('reply_body','').strip())
        if has_body and isinstance(tags, list):
            if len(tags) > 0:
                print('tags_ok')
            else:
                print('tags_empty')
            sys.exit(0)
    except Exception:
        pass
sys.exit(1)
" 2>/dev/null; then
        local tag_result
        tag_result=$(echo "$llm_resp" | python3 -c "
import sys, json, re
text = sys.stdin.read()
for attempt in [text, re.sub(r'.*?(\{.*\}).*', r'\1', text, flags=re.DOTALL)]:
    try:
        d = json.loads(attempt.strip())
        tags = d.get('suggested_tags', [])
        print(','.join(str(t) for t in tags) if tags else '(leer)')
        break
    except: pass
" 2>/dev/null || echo "?")
        if [[ "$tag_result" == "(leer)" ]]; then
            warn "LLM gibt gültiges JSON aus, aber suggested_tags ist leer – Tags fehlen im Ticket"
            warn "Das Modell folgt der Tags-Instruktion nicht zuverlässig (bekannte Einschränkung von ${LLM_MODEL})"
            llm_ok=false
        else
            ok "LLM gibt gültiges JSON aus ✓"
            ok "  → suggested_tags: ${tag_result}"
        fi
    else
        warn "LLM gibt kein parsbares JSON zurück – Antwortformat nicht garantiert"
        warn "Rohantwort (erste 300 Zeichen): $(echo "$llm_resp" | head -c 300)"
        warn "Das kann bei Kaltstart passieren – nach vollständigem Laden des Modells nochmals testen"
        llm_ok=false
    fi

    # ── Zusammenfassung ──
    if $rag_ok && $llm_ok; then
        ok "AI-Chain vollständig funktionsfähig: RAG ✓ | LLM-JSON ✓ | Tags ✓"
    else
        warn "AI-Chain teilweise eingeschränkt – Details oben. Das System läuft, aber:"
        $rag_ok  || warn "  → RAG liefert keine Reference-URLs → Sources im Ticket leer"
        $llm_ok  || warn "  → LLM-JSON-Output unzuverlässig   → Tags möglicherweise leer"
        warn "Empfehlung: Nach vollständigem Modell-Warmup (2–5 Min.) erneut testen:"
        warn "  curl -X POST http://127.0.0.1:${RAG_PORT}/query -H 'Content-Type: application/json' -d '{\"query\":\"test\",\"top_k\":2}'"
    fi
}

# ---------------------------------------------------------------------------
# Abschluss: Validierung und Zusammenfassung
# ---------------------------------------------------------------------------
validate_all() {
    step "Validierung & Zusammenfassung"

    local all_ok=true

    # Apache
    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${OSTICKET_PORT}/" 2>/dev/null || echo "000")
    if [[ "$http_code" == "200" || "$http_code" == "302" ]]; then
        ok "Apache: HTTP ${http_code} ✓"
    else
        warn "Apache: HTTP ${http_code} – möglicherweise Problem"
        all_ok=false
    fi

    # RAG-Service
    local rag_status doc_count
    rag_status=$(curl -s "http://127.0.0.1:${RAG_PORT}/health" 2>/dev/null \
        | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('status','?'),d.get('doc_count',0))" 2>/dev/null || echo "? 0")
    if echo "$rag_status" | grep -q "^ok"; then
        ok "RAG-Service: ${rag_status} Dokumente ✓"
    else
        warn "RAG-Service: ${rag_status} – möglicherweise noch warm"
        all_ok=false
    fi

    # Systemdienste
    for svc in apache2 mariadb ollama osticket-kb-rag; do
        if service_active "$svc"; then
            ok "Service ${svc}: active ✓"
        else
            warn "Service ${svc}: nicht aktiv"
            all_ok=false
        fi
    done

    # Abschluss-Box
    echo ""
    echo -e "${BOLD}╔══════════════════════════════════════════════════════╗${NC}"
    if $all_ok; then
        echo -e "${BOLD}${GREEN}║           INSTALLATION ERFOLGREICH ABGESCHLOSSEN    ║${NC}"
    else
        echo -e "${BOLD}${YELLOW}║        INSTALLATION ABGESCHLOSSEN (mit Warnungen)   ║${NC}"
    fi
    echo -e "${BOLD}╠══════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║  osTicket-URL : http://localhost:${OSTICKET_PORT}$(printf '%*s' $((22-${#OSTICKET_PORT})) '')║${NC}"
    echo -e "${BOLD}║  Admin-Login  : ${ADMIN_USER} / [dein Passwort]$(printf '%*s' $((6-${#ADMIN_USER})) '')   ║${NC}"
    local _email_trunc="${ADMIN_EMAIL:0:36}"
    local _email_pad=$(( ${#_email_trunc} < 36 ? 36 - ${#_email_trunc} : 0 ))
    echo -e "${BOLD}║  Admin-E-Mail : ${_email_trunc}$(printf '%*s' "$_email_pad" '')║${NC}"
    echo -e "${BOLD}║  RAG-Service  : http://127.0.0.1:${RAG_PORT}$(printf '%*s' $((18-${#RAG_PORT})) '')║${NC}"
    echo -e "${BOLD}║  Log-Datei    : ${LOG}$(printf '%*s' $((36-${#LOG})) '')║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}${YELLOW}║  MANUELLER SCHRITT – Plugin aktivieren:             ║${NC}"
    echo -e "${BOLD}║  1. http://localhost:${OSTICKET_PORT}/scp/admin.php öffnen$(printf '%*s' $((5-${#OSTICKET_PORT})) '')    ║${NC}"
    echo -e "${BOLD}║  2. Admin Panel → Manage → Plugins                  ║${NC}"
    echo -e "${BOLD}║  3. Add New Plugin → AI Reply Assistant → Install   ║${NC}"
    echo -e "${BOLD}║  4. Plugin-Name → Add Instance → Einstellungen:     ║${NC}"
    echo -e "${BOLD}║     LLM URL:  http://127.0.0.1:11434/v1             ║${NC}"
    echo -e "${BOLD}║     Modell:   gemma3:4b                              ║${NC}"
    echo -e "${BOLD}║     RAG URL:  http://127.0.0.1:${RAG_PORT}$(printf '%*s' $((22-${#RAG_PORT})) '')║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ---------------------------------------------------------------------------
# Hauptprogramm
# ---------------------------------------------------------------------------
main() {
    clear 2>/dev/null || true
    echo -e "${BOLD}${BLUE}"
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║   Orbitalis – Installations-Skript    ║"
    echo "  ║   osTicket + AI Reply + RAG-Service   ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    echo "  Log: ${LOG}"
    echo ""

    # curl und git müssen vor preflight verfügbar sein:
    # preflight() prüft die Internetverbindung via curl und step3_clone nutzt git.
    # Auf einem frischen Debian 13 sind beide nicht vorinstalliert.
    if ! command -v curl &>/dev/null || ! command -v git &>/dev/null; then
        echo "  → Installiere curl und git (für Pre-flight und Repository-Klon benötigt)..."
        apt-get update -qq >/dev/null 2>&1 || true
        apt-get install -y -qq curl git \
            || { echo "FEHLER: curl/git konnten nicht installiert werden. Bitte manuell nachinstallieren."; exit 1; }
    fi

    preflight
    prompt_credentials

    local TOTAL=9
    step1_packages;         progress 1 $TOTAL "System-Pakete"
    step2_ollama;           progress 2 $TOTAL "Ollama"
    step3_clone;            progress 3 $TOTAL "Repository"
    step4_database;         progress 4 $TOTAL "Datenbank"
    step5_deploy;           progress 5 $TOTAL "osTicket bereitstellen"
    step6_python;           progress 6 $TOTAL "Python-Umgebung"
    step7_models;           progress 7 $TOTAL "KI-Modelle"
    step8_rag_service;      progress 8 $TOTAL "RAG-Service"
    step9_seed;             progress 9 $TOTAL "Wissensdatenbank"
    step9b_validate_ai_chain
    validate_all
}

main "$@"

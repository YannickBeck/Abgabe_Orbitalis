# osTicket – Repository Map

> **Version:** 1.18-git | **Typ:** PHP-Ticketsystem (Custom Framework) | **Erstellt:** 2026-03-25

---

## Inhaltsverzeichnis

1. [Projektübersicht](#projektübersicht)
2. [Verzeichnisstruktur](#verzeichnisstruktur)
3. [Root-Einstiegspunkte](#root-einstiegspunkte)
4. [Kernklassen (`/include/`)](#kernklassen-include)
5. [AJAX-Handler (`/include/ajax.*.php`)](#ajax-handler)
6. [Staff Control Panel (`/scp/`)](#staff-control-panel-scp)
7. [API (`/api/`)](#api)
8. [CLI-Module (`/include/cli/modules/`)](#cli-module)
9. [Plugins (`/include/plugins/`)](#plugins)
10. [Assets & Frontend](#assets--frontend)
11. [Konfiguration](#konfiguration)
12. [.htaccess-Regeln](#htaccess-regeln)
13. [Tools (`/tools/`)](#tools)

---

## Projektübersicht

| Eigenschaft         | Wert                          |
|---------------------|-------------------------------|
| **Anwendung**       | osTicket Open Source Helpdesk |
| **Version**         | 1.18-git (Entwicklungsversion)|
| **Sprache**         | PHP (>= 7.0)                  |
| **Datenbank**       | MySQL / MariaDB               |
| **Tabellenpräfix**  | `ost_`                        |
| **Framework**       | Eigenentwicklung (kein Laravel/Symfony) |
| **Session-Cookie**  | `OSTSESSID`                   |
| **Konfiguration**   | `include/ost-config.php`      |

---

## Verzeichnisstruktur

```
/var/www/osticket/
│
├── api/                  – REST API (HTTP, Pipe, Cron)
├── apps/                 – MVC-Dispatcher für moderne SPA-ähnliche Bereiche
├── assets/               – Theme-Assets (CSS/LESS/Bilder/Fonts)
│   ├── default/
│   │   ├── css/          – Kompiliertes CSS (theme.css, theme.min.css, print.css)
│   │   ├── less/         – LESS-Quelldateien
│   │   └── images/       – Theme-Bilder und Icons
│   └── font/             – FontAwesome (eot, svg, ttf, woff)
├── css/                  – Globale Stylesheets (jQuery UI, Select2, Redactor, etc.)
├── images/               – Allgemeine Bilder, Sprites, Favicons, Flags
│   └── captcha/          – CAPTCHA-Bilder
├── include/              – Gesamte Kernlogik der Anwendung (s. unten)
├── js/                   – JavaScript-Bibliotheken (jQuery, Select2, Redactor, etc.)
├── kb/                   – Knowledge Base Client-Portal
├── pages/                – Statische Inhaltsseiten
├── scp/                  – Staff Control Panel (Admin-/Agenten-Oberfläche)
│   ├── apps/             – SCP App-Dispatcher
│   ├── css/              – SCP-spezifische Styles
│   ├── images/           – SCP-Icons
│   └── js/               – SCP-spezifisches JavaScript
└── tools/                – Zusatzwerkzeuge
    └── kb_rag_service/   – Python-basierter RAG-Dienst für die Wissensdatenbank
```

---

## Root-Einstiegspunkte

Dateien direkt in `/var/www/osticket/`:

| Datei              | Zweck                                                        |
|--------------------|--------------------------------------------------------------|
| `index.php`        | Startseite – Knowledge Base Suche & Featured Articles        |
| `open.php`         | Neues Ticket erstellen (öffentliches Formular, CAPTCHA)      |
| `tickets.php`      | Client-Dashboard – Ticket-Liste, Antworten, PDF-Export       |
| `view.php`         | Ticket-Ansicht (auch ohne Login via Token)                   |
| `login.php`        | Client-Authentifizierung                                     |
| `logout.php`       | Session beenden                                              |
| `account.php`      | Kontoeinstellungen                                           |
| `profile.php`      | Benutzerprofil-Verwaltung                                    |
| `pwreset.php`      | Passwort-Zurücksetzen                                        |
| `manage.php`       | Verwaltungsfunktionen (Client-Bereich)                       |
| `offline.php`      | Wartungsseite                                                |
| `ajax.php`         | AJAX-Router für den Client-Bereich                           |
| `avatar.php`       | Avatar-Ausgabe                                               |
| `captcha.php`      | CAPTCHA-Bildgenerierung                                      |
| `file.php`         | Datei-/Anhang-Ausgabe                                        |
| `logo.php`         | Logo-Ausgabe                                                 |
| `bootstrap.php`    | Anwendungs-Bootstrap (PHP-Ini, Konstanten, DB-Verbindung)    |
| `main.inc.php`     | Master-Bootstrap (i18n, CSRF, Session, DB)                  |
| `client.inc.php`   | Client-Portal Bootstrap (ACL, Auth, Session)                |
| `secure.inc.php`   | Bootstrap für Seiten mit Pflicht-Login                       |
| `web.config`       | IIS-Konfiguration (URL-Rewrite für Windows-Server)           |

---

## Kernklassen (`/include/`)

Die Datei `/include/class.*.php` enthält ~94 Klassen. Die wichtigsten:

| Datei                        | Zweck                                              |
|------------------------------|----------------------------------------------------|
| `class.ticket.php`           | Ticket-Lebenzyklus, Status, Zuweisungen            |
| `class.thread.php`           | Thread-Einträge (Nachrichten, Notizen, Antworten)  |
| `class.user.php`             | Endbenutzer-Verwaltung                             |
| `class.client.php`           | Client-Portal Authentifizierung                    |
| `class.staff.php`            | Agenten/Staff-Verwaltung                           |
| `class.auth.php`             | Authentifizierungs-Framework (51KB)               |
| `class.config.php`           | Systemkonfiguration (61KB)                        |
| `class.email.php`            | E-Mail-Verwaltung und -Versand                     |
| `class.mail.php`             | Mail-Parsing und -Abruf (IMAP/POP3)               |
| `class.department.php`       | Abteilungs-Verwaltung                              |
| `class.filter.php`           | Ticket-Filter-Regeln                               |
| `class.forms.php`            | Formular-Framework                                 |
| `class.dynamic_forms.php`    | Dynamische benutzerdefinierte Felder               |
| `class.api.php`              | API-Basis-Framework (15KB)                        |
| `class.orm.php`              | Object-Relational Mapper                           |
| `class.model.php`            | ORM-Basisklasse für Models                         |
| `class.sla.php`              | SLA-Richtlinien-Verwaltung                         |
| `class.queue.php`            | Ticket-Warteschlangen                              |
| `class.task.php`             | Aufgaben-Verwaltung                                |
| `class.plugin.php`           | Plugin-System                                      |
| `class.file.php`             | Datei- und Anhang-Handling (35KB)                 |
| `class.attachment.php`       | Anhang-Verwaltung                                  |
| `class.cron.php`             | Cronjob-Methoden (Mail, Monitor, Purge)            |
| `class.setup.php`            | Setup/Upgrade-Logik                                |
| `class.search.php`           | Volltext-/Filter-Suche                             |

**Weitere Bibliotheken in `/include/`:**

| Verzeichnis        | Inhalt                                   |
|--------------------|------------------------------------------|
| `pear/`            | PEAR-Bibliotheken (Mail, Net, HTTP)      |
| `laminas-mail/`    | Modernes E-Mail-Framework                |
| `mpdf/`            | PDF-Generierung                          |
| `fpdf/`            | Alternatives PDF-Framework              |
| `i18n/`            | Internationalisierung                    |
| `upgrader/`        | Datenbank-Migrationssystem               |

---

## AJAX-Handler

Dateien `/include/ajax.*.php` – geroutet über `ajax.php` (Client) bzw. `scp/ajax.php` (Staff):

| Datei                  | Größe   | Zweck                                    |
|------------------------|---------|------------------------------------------|
| `ajax.tickets.php`     | 81 KB   | Ticket-Operationen (grösste Datei)       |
| `ajax.tasks.php`       | 34 KB   | Aufgaben-Verwaltung                      |
| `ajax.draft.php`       | 13 KB   | Entwurf-Speicherung / Anhang-Upload      |
| `ajax.users.php`       | –       | Benutzer-Operationen                     |
| `ajax.staff.php`       | –       | Agenten-Operationen                      |
| `ajax.orgs.php`        | –       | Organisations-Verwaltung                 |
| `ajax.search.php`      | –       | Suche                                    |
| `ajax.forms.php`       | –       | Dynamische Formulare                     |
| `ajax.filter.php`      | –       | Ticket-Filter                            |
| `ajax.kbase.php`       | –       | Knowledge Base                           |
| `ajax.thread.php`      | –       | Thread/Antworten                         |
| `ajax.note.php`        | –       | Interne Notizen                          |
| `ajax.email.php`       | –       | E-Mail-Konfiguration                     |
| `ajax.admin.php`       | –       | Admin-Funktionen                         |
| `ajax.config.php`      | –       | Konfigurationsoperationen                |
| `ajax.content.php`     | –       | Content-Verwaltung                       |
| `ajax.export.php`      | –       | Datenexport                              |
| `ajax.i18n.php`        | –       | Übersetzungen                            |
| `ajax.plugins.php`     | –       | Plugin-Verwaltung                        |
| `ajax.schedule.php`    | –       | Planung/Zeitplan                         |
| `ajax.sequence.php`    | –       | Reihenfolge-Verwaltung                   |
| `ajax.tips.php`        | –       | Hilfe-Tooltips                           |
| `ajax.upgrader.php`    | –       | Upgrade-Prozess                          |

---

## Staff Control Panel (`/scp/`)

Wichtigste Dateien im Admin/Agenten-Bereich:

| Kategorie         | Dateien                                                              |
|-------------------|----------------------------------------------------------------------|
| **Tickets**       | `tickets.php` (25KB), `ticket-view.php`                             |
| **Benutzer**      | `users.php`, `staff.php`, `roles.php`                               |
| **Struktur**      | `departments.php`, `helptopics.php`, `queues.php`                   |
| **E-Mail**        | `emails.php`, `emailsettings.php`, `emailtest.php`, `templates.php` |
| **Konfiguration** | `admin.php`, `settings.php`, `system.php`                           |
| **Sicherheit**    | `apikeys.php`, `filters.php`, `slas.php`                            |
| **Inhalt**        | `kb.php`, `faq.php`, `pages.php`, `categories.php`                  |
| **Reporting**     | `logs.php`, `audits.php`, `export.php`                              |
| **Wartung**       | `upgrade.php`, `autocron.php`                                       |
| **SCP-Dispatcher**| `apps/dispatcher.php` – MVC-Router für moderne App-Seiten           |

---

## API

**Verzeichnis:** `/var/www/osticket/api/`

| Datei          | Zweck                                                                 |
|----------------|-----------------------------------------------------------------------|
| `http.php`     | HTTP REST API Handler (JSON/XML)                                      |
| `pipe.php`     | E-Mail-Pipe-Handler (eingehende E-Mails als Tickets)                  |
| `cron.php`     | Cron-Trigger über HTTP-Aufruf                                         |
| `api.inc.php`  | API Bootstrap (definiert `API_SESSION`, `APICALL` Konstanten)         |
| `index.php`    | Weiterleitung zur Root-Seite                                          |

**Routing:** `.htaccess` leitet alle nicht-dateibasierten Anfragen an `http.php/$1` weiter.

---

## CLI-Module

**Pfad:** `/var/www/osticket/include/cli/modules/`

| Modul          | Zweck                        |
|----------------|------------------------------|
| `agent.php`    | Agenten/Staff-Verwaltung     |
| `cron.php`     | Cronjob-Ausführung           |
| `deploy.php`   | Deployment-Hilfsmittel       |
| `export.php`   | Datenexport                  |
| `file.php`     | Dateioperationen             |
| `i18n.php`     | Übersetzungs-Verwaltung      |
| `import.php`   | Datenimport                  |
| `list.php`     | Listenoperationen            |
| `org.php`      | Organisations-Verwaltung     |
| `package.php`  | Paket-Verwaltung             |
| `serve.php`    | Entwicklungs-Webserver       |
| `unpack.php`   | Paket entpacken              |
| `upgrade.php`  | System-Upgrades              |
| `user.php`     | Benutzer-Verwaltung          |

**Ausführung:** `include/cli/cli.inc.php` (setzt `DISABLE_SESSION` Flag für CLI-Kontext)

---

## Plugins

**Pfad:** `/var/www/osticket/include/plugins/`

### ai-reply-assistant

KI-gestützter Antwort-Assistent für Agenten:

| Datei/Verzeichnis       | Inhalt                                          |
|-------------------------|-------------------------------------------------|
| `class.AiReplyPlugin.php` | Haupt-Plugin-Klasse                           |
| `ajax.php`              | AJAX-Handler für KI-Antwortvorschläge           |
| `config.php`            | Plugin-Konfiguration                            |
| `classes/`              | Weitere Hilfsklassen                            |
| `migrations/`           | SQL-Datenbankmigrationen (z.B. Log-Tabelle)     |

---

## Assets & Frontend

### JavaScript (`/js/`)

| Bibliothek                          | Zweck                     |
|-------------------------------------|---------------------------|
| `jquery-3.7.0.min.js`              | jQuery Core               |
| `jquery-ui-1.13.2.custom.min.js`   | jQuery UI                 |
| `select2.min.js`                   | Dropdown-Auswahl-Widget   |
| `redactor.min.js`                  | Rich-Text-Editor          |
| `redactor-osticket.js`             | osTicket-Redactor-Anpassungen |
| `bootstrap-typeahead.js`           | Typeahead/Autocomplete    |
| `filedrop.field.js`                | Drag & Drop Dateiupload   |
| `jquery.pjax.js`                   | AJAX-Navigation           |
| `jstz.min.js`                      | Zeitzonenerkennung        |
| `fabric.min.js`                    | Canvas-Operationen        |
| `osticket.js`                      | Anwendungs-JS-Core        |

### CSS (`/css/`)

| Datei                                      | Zweck                  |
|--------------------------------------------|------------------------|
| `osticket.css`                             | Haupt-Stylesheet       |
| `ui-lightness/jquery-ui-*.custom.min.css`  | jQuery UI Theme        |
| `select2.min.css`                          | Select2 Styles         |
| `redactor.css`                             | Editor-Styles          |
| `thread.css`                               | Thread-Anzeige         |
| `flags.css`                                | Sprach-Flaggen         |
| `rtl.css`                                  | Right-to-Left Support  |
| `font-awesome.min.css`                     | Icon-Font              |

### Theme-Assets (`/assets/default/`)

- **CSS:** `theme.css`, `theme.min.css`, `print.css`
- **LESS-Quellen:** `base.less`, `theme.less`, `kb.less`, `ticket-forms.less`
- **Fonts:** FontAwesome in `/assets/font/` (eot, svg, ttf, woff)

---

## Konfiguration

| Datei                              | Zweck                                              |
|------------------------------------|----------------------------------------------------|
| `include/ost-config.php`           | **Aktive Konfiguration** (DB, Session, Salt)       |
| `include/ost-sampleconfig.php`     | Konfigurations-Vorlage                             |
| `bootstrap.php`                    | PHP-Runtime-Konfiguration, Konstanten              |
| `main.inc.php`                     | Master-Bootstrap: DB-Verbindung, i18n, CSRF        |
| `web.config`                       | IIS URL-Rewrite-Regeln (für Windows-Deployment)    |
| `include/upgrader/streams/core/`   | SQL-Patches für DB-Schema-Migrationen              |

> **Hinweis:** Keine `.env`-Datei, kein `composer.json` – Konfiguration erfolgt direkt in PHP-Dateien.

---

## .htaccess-Regeln

| Pfad                    | Regel                                                     |
|-------------------------|-----------------------------------------------------------|
| `include/.htaccess`     | `Deny from all` – kein direkter Zugriff auf Include-Dir   |
| `api/.htaccess`         | Rewrite → `api/http.php/$1` (REST-Routing)                |
| `pages/.htaccess`       | Rewrite → `pages/index.php/$1`                            |
| `apps/.htaccess`        | Rewrite → `apps/dispatcher.php/$1`                        |
| `scp/apps/.htaccess`    | Rewrite → `scp/apps/dispatcher.php/$1`                    |

Alle Rewrite-Regeln folgen dem Muster: Nicht-Datei/Nicht-Verzeichnis → PHP-Handler.

---

## Tools

### `/tools/kb_rag_service/`

Python-basierter RAG-Dienst (Retrieval-Augmented Generation) für die Knowledge Base:

| Datei                | Inhalt                                      |
|----------------------|---------------------------------------------|
| `app.py`             | Flask/FastAPI-Anwendung                     |
| `requirements.txt`   | Python-Abhängigkeiten                       |
| `*.service`          | Systemd-Service-Datei für Produktiv-Deploy  |
| `README`             | Dokumentation                               |

---

*Generiert am 2026-03-25 – osTicket v1.18-git*

# Abgabe Orbitalis

Dieser Ordner ist als eigenstaendige Abgabe vorbereitet.

## Inhalt

- `TicksystemOrbitalis/`  
  Vollstaendiger Projektstand (Klon des aktuellen Systems).
- `Eigenleistungen/`  
  Nachweisordner mit Eigenleistungen (inkl. `MANIFEST.csv`, `SUMMARY.md`, Baseline-Referenzen und Reports).

## GitHub-Repository (Ziel)

`https://github.com/YannickBeck/Abgabe_Orbitalis.git`

## Push-Befehle

1. In diesen Ordner wechseln:

```bash
cd "/osTicket/Abgabe Orbitalis"
```

2. Neues Git-Repository initialisieren:

```bash
git init
git add .
git commit -m "Initial submission package"
```

3. Branch auf `main` setzen:

```bash
git branch -M main
```

4. Remote setzen:

```bash
git remote add origin https://github.com/YannickBeck/Abgabe_Orbitalis.git
```

Falls `origin` bereits existiert:

```bash
git remote set-url origin https://github.com/YannickBeck/Abgabe_Orbitalis.git
```

5. Push:

```bash
git push -u origin main
```

## Hinweis

Dieser Abgabeordner ist getrennt vom bestehenden Projekt-Root `/osTicket` vorbereitet.

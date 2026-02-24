# 11 Known Issues and Roadmap

## Bekannte technische Punkte

## 1) Log-Schema Inkonsistenz

Beobachtung:

- Migration/Auto-Create verwenden Spalten wie `message_id`, `status`, `reason`, `hash_prompt`.
- `LogWriter` schreibt Felder wie `entry_id`, `event_type`, `reason_code`, `prompt_hash`.

Referenzen:

- Migration: `include/plugins/ai-reply-assistant/migrations/001-create-log-table.sql`
- Auto-Create: `include/plugins/ai-reply-assistant/class.AiReplyPlugin.php:174`
- LogWriter: `include/plugins/ai-reply-assistant/classes/LogWriter.php:43`

Risiko:

- Je nach realem DB-Schema koennen Inserts fehlschlagen oder unvollstaendig sein.

Roadmap:

1. Einheitliches Log-Schema definieren
2. DB-Migration fuer bestehende Installationen erstellen
3. Logger und Reader auf ein einheitliches Feldset umstellen

## 2) Lange Warm-up Phasen beim RAG Index

Beobachtung:

- Initialer Build kann je nach Datenmenge/Hardware deutlich dauern.

Referenzen:

- Initial Build Thread: `tools/kb_rag_service/app.py:803`
- Health status: `tools/kb_rag_service/app.py:820`

Roadmap:

1. Progress-Metriken in `/health`
2. Persistenter Vektorstore statt kompletter Rebuilds
3. Delta-Reindex statt Voll-Reindex

## 3) Retrieval ohne Mindestscore

Beobachtung:

- Treffer werden nach `top_k` geliefert, aber ohne harte Score-Schwelle.

Referenz:

- Query Ausgabe: `tools/kb_rag_service/app.py:776`

Roadmap:

1. Konfigurierbarer Score-Threshold
2. Fallback-Strategien bei nur schwachen Treffern

## 4) Strict Fail kann Drafts hart blockieren

Beobachtung:

- Bei RAG-Ausfall bricht Draft strikt ab.

Referenzen:

- Strict Mode: `include/plugins/ai-reply-assistant/classes/RagServiceClient.php:137`
- Fehlerbehandlung: `include/plugins/ai-reply-assistant/classes/EventRouter.php:483`

Roadmap:

1. Optionaler degradierter Betrieb per explizitem Soft-Mode
2. Bessere UI-Fehlermeldungen fuer Agenten

## 5) Multimodal Limitierungen

Beobachtung:

- Nur bestimmte Bild-MIME Typen und harte Groessenlimits.

Referenz:

- Attachment Handling: `include/plugins/ai-reply-assistant/classes/ContextBuilder.php:339`

Roadmap:

1. Optional OCR Preprocessing
2. Granulare Limits pro Department/Priority

## Priorisierte Naechste Schritte

1. Log-Schema konsolidieren (hoechste Prioritaet)
2. RAG Observability erweitern (`health` + metrics)
3. Retrieval-Qualitaet mit Score-Threshold verbessern
4. Verbesserte Betriebsdokumentation fuer Migrationspfade

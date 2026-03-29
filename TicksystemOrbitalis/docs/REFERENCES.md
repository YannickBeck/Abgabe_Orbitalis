# REFERENCES

## Externe Quellen (offiziell)

Stand der Sammlung: 2026-02-23.

### osTicket

- Produktseite: https://osticket.com/
- Dokumentation: https://docs.osticket.com/

### Ollama

- Produktseite: https://ollama.com/
- Dokumentation: https://docs.ollama.com/

### LlamaIndex

- Dokumentation: https://docs.llamaindex.ai/en/stable/
- Website: https://www.llamaindex.ai/

### FastAPI / Uvicorn

- FastAPI Doku: https://fastapi.tiangolo.com/
- Uvicorn Doku: https://www.uvicorn.org/

### Cloudflare Tunnel

- Cloudflare One Docs: https://developers.cloudflare.com/cloudflare-one/
- Tunnel Guides: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/

## Interne Cross-Reference Map

| Thema | Primaerer Codepfad |
|---|---|
| Plugin Bootstrap und Hooking | `include/plugins/ai-reply-assistant/class.AiReplyPlugin.php` |
| Pipeline Orchestrierung | `include/plugins/ai-reply-assistant/classes/EventRouter.php` |
| Gating | `include/plugins/ai-reply-assistant/classes/GatingLogic.php` |
| Prompt/Kontext/Bilder | `include/plugins/ai-reply-assistant/classes/ContextBuilder.php` |
| KB Retrieval/Source Links | `include/plugins/ai-reply-assistant/classes/KbRetriever.php` |
| LLM Transport | `include/plugins/ai-reply-assistant/classes/OpenAiClient.php` |
| RAG HTTP Client | `include/plugins/ai-reply-assistant/classes/RagServiceClient.php` |
| Internal Note | `include/plugins/ai-reply-assistant/classes/NoteWriter.php` |
| Audit Logging | `include/plugins/ai-reply-assistant/classes/LogWriter.php` |
| RAG Service Core | `tools/kb_rag_service/app.py` |
| RAG systemd Template | `tools/kb_rag_service/systemd/osticket-kb-rag.service` |
| KB Seeder | `seed_osticket_kb.py` |
| Demo Dataset | `kb_demo.json` |

## Dokumentinterne Referenzen

- Architektur: `docs/02_Architecture_and_Dataflow.md`
- Plugin Referenz: `docs/03_Plugin_Reference.md`
- RAG Referenz: `docs/04_RAG_Service_Reference.md`
- Seeder Referenz: `docs/05_KB_Seeder_Reference.md`
- Betrieb: `docs/07_Deployment_and_Operations.md`
- Tests: `docs/08_Testplan_and_Acceptance.md`
- Troubleshooting: `docs/09_Troubleshooting.md`
- Sicherheit: `docs/10_Security_Privacy_Limits.md`
- Known Issues: `docs/11_Known_Issues_and_Roadmap.md`
- Datenbank-Einbindung: `docs/12_Database_Handover_Guide.md`

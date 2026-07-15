# MelbAi-Hub - Project Index

**Tiedostonimi**: `MelbAi-Hub.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\MelbAi-Hub`  
**GitHub-repo**: [Tarkista repo-osoite GitHubista]  
**Status**: Aktiivinen  

---

## Yleiskuva

**Tyyppi**: Web  
**Teknologiat**: React 19 + Vite, TailwindCSS, Firebase (Auth/Firestore/Hosting/Functions/App Check), Gemini 2.5 Flash, GCS  
**Tarkoitus**: Melba Digitalin sisäinen AI-työkaluhubi (AsiakasChat + AI-Avustaja)  

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 2026-07-15  
**Viimeksi päivitetty**: 2026-07-15  

### Supabase MCP

- **Project ref**: `cklzrolyxbbiyqnwddzd`
- **URL**: `https://cklzrolyxbbiyqnwddzd.supabase.co`
- **MCP**: Konfiguroitu `mcpConfig.json`:ssa — `@supabase/mcp-server-supabase`
- **Anon key**: Hae MCP:llä (`get_project_api_keys`) ja täytä `.env`:ään — älä pyydä käyttäjää manuaalisesti

### Noudatetut määritykset

- [x] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [x] `01-workflows/workflow-rules.md` luettu
- [x] `03-configs/devin/ide-setup.md` luettu — Devin/Cascade-asetukset tarkistettu
- [x] `03-configs/devin/project-window-colors.md` luettu — kehysväri asetettu `.vscode/settings.json` (violetti #9B6AFF)
- [x] `03-configs/supabase/mcp-setup.md` mukana — Supabase MCP konfiguroitu
- N/A `03-configs/vercel/project-settings.md` — projekti käyttää Firebase Hostingia
- N/A `03-configs/vercel/mcp-setup.md` — Vercel ei käytössä
- [ ] `03-configs/supabase/keep-alive-heartbeat.md` — tarkistettava onko free-tier

### Dokumentoidut poikkeamat

| Kohta | Knowledgebase | Tämä projekti | Syy |
|-------|---------------|---------------|-----|
| Hosting | Vercel | Firebase Hosting | Projekti käyttää Google-työkaluja |

---

## Linkit

| Palvelu | URL |
|---------|-----|
| **Production** | |
| **GitHub** | https://github.com/[user]/MelbAi-Hub |

---

## Google AI Skills (asennettu)

| Skill | Käyttötarkoitus |
|-------|----------------|
| `gemini-api` | Gemini SDK, multimodal, tools — OKF-agentti + AI-Avustaja |
| `gcloud` | gcloud CLI (GCS, Secret Manager, IAM) |
| `agent-platform-inference` | Gemini-mallikutsut, SDK-konfiguraatio |
| `gemini-agents-api` | Agenttien hallinta (OKF-agentti) |
| `gemini-interactions-api` | Stateful multi-turn keskustelut |
| `agent-platform-rag-engine-management` | RAG Engine -hallinta |
| `cloud-run-basics` | Cloud Run -palvelut |
| `find-skills` | Uusien skillien löytäminen |

Lisäksi 12 Firebase/Genkit-skilliä (`firebase-basics`, `firebase-auth-basics`, `firebase-hosting-basics`, jne.)

## Muistiinpanot

- OKF Agent (Gemini Function Calling) korvasi Vertex AI Searchin 14.7.2026
- GCS-bucket: `melbai-documents` (ainoa aktiivinen)
- API-avaimet Secret Managerissa — ei frontendiin

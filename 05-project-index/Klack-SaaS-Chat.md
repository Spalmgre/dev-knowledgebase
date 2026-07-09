# Klack-SaaS-Chat - Project Index

**Tiedostonimi**: `Klack-SaaS-Chat.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Klack-SaaS-Chat`  
**GitHub-repo**: [Tarkista repo-osoite GitHubista]  
**Status**: Aktiivinen  

---

## Yleiskuva

**Tyyppi**: Web  
**Teknologiat**: [Tarkista projektista: Next.js / React / jne.]  
**Tarkoitus**: SaaS-chat-sovellus  

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: [Ei vielä merkitty - päivitä kun knowledgebase otetaan käyttöön]  
**Viimeksi päivitetty**: 2026-07-09  

### Noudatetut määritykset

- [ ] `01-workflows/new-project-setup.md` käytetty projektin luonnissa
- [ ] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [ ] `01-workflows/workflow-rules.md` luettu
- [ ] `03-configs/ARCHITECTURE.md` luettu ja noudatettu
- [ ] `03-configs/UI_UX_STANDARDS.md` luettu ja noudatettu
- [ ] `03-configs/MCP_INTEGRATION.md` luettu (jos MCP:tä käytetään)
- [ ] `03-configs/supabase/oauth-providers.md` mukana (jos Supabase käytössä)
- [x] `03-configs/supabase/keep-alive-heartbeat.md` mukana (Supabase free-tier)
- [x] `02-templates/github-actions/supabase-keep-alive.yml` kopioitu ja `HEARTBEAT_SECRET` lisätty
- [ ] `03-configs/vercel/project-settings.md` mukana (jos Vercel käytössä)
- [ ] `03-configs/supabase/mcp-setup.md` mukana (jos MCP:tä käytetään Supabasen kanssa)
- [ ] `03-configs/vercel/mcp-setup.md` mukana (jos MCP:tä käytetään Vercelin kanssa)

### Dokumentoidut poikkeamat

[ dokumentoi poikkeamat knowledgebase-määrityksistä ]

---

## Linkit

| Palvelu | URL | Huomiot |
|---------|-----|---------|
| **Production** | [Vercel-URL] | |
| **Supabase** | [Supabase-dashboard] | |
| **GitHub** | https://github.com/[user]/Klack-SaaS-Chat | |
| **Vercel** | https://vercel.com/[user]/[project] | |

---

## Asetukset

### Supabase (jos käytössä)

- **Project ID**: [tarkista dashboardista]
- **Region**: [eu-central-1 / jne.]
- **OAuth Providerit**: [GitHub / Google]

### Vercel (jos käytössä)

- **Project Name**: [nimi]
- **Framework**: [Next.js / React]
- **Build Command**: [next build]

---

## Ratkaistut ongelmat (tässä projektissa)

| Päivämäärä | Ongelma | Knowledgebase-dokumentti |
|------------|---------|--------------------------|
| 2026-07-06 | Supabase free-tier pausointi estetään DB-kyselyä tekevällä keep-alive workflowlla | `03-configs/supabase/keep-alive-heartbeat.md` |
| 2026-07-09 | Supabase & Vercel MCP -konfiguraatio puuttui knowledgebasesta | `03-configs/supabase/mcp-setup.md`, `03-configs/vercel/mcp-setup.md`, `04-issues-resolved/supabase-vercel-mcp-2026-07-09.md` |

---

## Muistiinpanot

- [Täydennä projektikohtaisilla tiedoilla kun knowledgebase otetaan käyttöön]

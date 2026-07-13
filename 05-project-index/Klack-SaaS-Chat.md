# Klack-SaaS-Chat - Project Index

**Tiedostonimi**: `Klack-SaaS-Chat.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Klack-SaaS-Chat`  
**GitHub-repo**: https://github.com/Spalmgre/Klack-SaaS-Chat  
**Status**: Aktiivinen  

---

## Yleiskuva

**Tyyppi**: Web  
**Teknologiat**: Next.js 14, React, TypeScript, Prisma, Supabase, TailwindCSS, framer-motion  
**Tarkoitus**: SaaS-chat-sovellus  

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 1.0  
**Viimeksi päivitetty**: 2026-07-12  

### Noudatetut määritykset

- [x] `03-configs/supabase/keep-alive-heartbeat.md` mukana (Supabase free-tier)
- [x] `02-templates/github-actions/supabase-keep-alive.yml` kopioitu ja `HEARTBEAT_SECRET` lisätty
- [x] `03-configs/supabase/mcp-setup.md` luettu (Supabase MCP/REST API -ohjeet)
- [x] `03-configs/vercel/mcp-setup.md` luettu (Vercel MCP/REST API -ohjeet)
- [x] `03-configs/vercel/project-settings.md` ja `environment-variables.md` huomioitu
- [ ] `03-configs/supabase/oauth-providers.md` mukana (ei vielä otettu käyttöön)
- [ ] `01-workflows/new-project-setup.md` käytetty projektin luonnissa (legacy)

### Dokumentoidut poikkeamat

[ dokumentoi poikkeamat knowledgebase-määrityksistä ]

---

## Linkit

| Palvelu | URL | Huomiot |
|---------|-----|---------|
| **Production** | https://klack-saas-chat.vercel.app | Vercel, tiimi `stefans-projects-edee8ecd` |
| **Supabase** | https://supabase.com/dashboard/project/fovohupqgjsvdlhynkqa | Project ref `fovohupqgjsvdlhynkqa` |
| **GitHub** | https://github.com/Spalmgre/Klack-SaaS-Chat | Private repo |
| **Vercel** | https://vercel.com/stefans-projects-edee8ecd/klack-saas-chat | Project ID `prj_Bfpz6n60O3PDEjaVZhazdgcUL7zH` |

---

## Asetukset

### Supabase

- **Project ref**: `fovohupqgjsvdlhynkqa`
- **Region**: `eu-central-1`
- **OAuth Providerit**: ei vielä käytössä

### Vercel

- **Project Name**: `klack-saas-chat`
- **Team ID**: `team_6mTwXImKbKZ4QuseCb3g4VmX`
- **Project ID**: `prj_Bfpz6n60O3PDEjaVZhazdgcUL7zH`
- **Framework**: Next.js
- **Build Command**: `prisma generate && next build`

---

## Ratkaistut ongelmat (tässä projektissa)

| Päivämäärä | Ongelma | Knowledgebase-dokumentti |
|------------|---------|--------------------------|
| 2026-07-06 | Supabase free-tier pausointi estetään DB-kyselyä tekevällä keep-alive workflowlla | `03-configs/supabase/keep-alive-heartbeat.md` |
| 2026-07-09 | Supabase & Vercel MCP -konfiguraatio puuttui knowledgebasesta | `03-configs/supabase/mcp-setup.md`, `03-configs/vercel/mcp-setup.md`, `04-issues-resolved/supabase-vercel-mcp-2026-07-09.md` |
| 2026-07-12 | Keep-alive endpoint palautti 401, koska `HEARTBEAT_SECRET` puuttui Vercel production-envistä | `04-issues-resolved/keep-alive-unauthorized-2026-07-12.md` |

---

## Muistiinpanot

- [Täydennä projektikohtaisilla tiedoilla kun knowledgebase otetaan käyttöön]

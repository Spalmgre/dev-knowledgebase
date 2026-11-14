# Klack-Tehdas - Project Index

**Tiedostonimi**: `Klack-Tehdas.md`  
**Projektin kansio**: `C:\TYO\GitHub Local\Klack-Tehdas`  
**GitHub-repo**: — (luodaan myöhemmin, `gh repo create Spalmgre/Klack-Tehdas --private`)  
**Status**: Kehitys (perustaminen, ennen Vaihetta 1)

---

## Yleiskuva

**Tyyppi**: Desktop/Local agenttiprojekti (paikallinen Markdown-tietovarasto, Obsidian-yhteensopiva)  
**Teknologiat**: paikalliset `.md`-tiedostot (memory/wiki), OpenRouter API (malliriippumaton LLM), MCP-wrapperit/CLI-integraatiot (Gmail, Drive, Calendar, Asana, Slack), Vercel-plugin taustapalveluille (Vaihe 4)  
**Tarkoitus**: Toimittajariippumaton **AI Second Brain** -järjestelmä neljän C:n viitekehyksellä (Context, Connections, Capabilities, Cadence). Vaiheistus: 1) muistikerros `/memory/`+`/wiki/`, 2) integraatiot Zero Trust -periaatteella, 3) skill-kevys + Eval suite, 4) Heartbeat-automaatio + Vercel-julkaisu.  
**Sukuprojekti**: sisällöllisesti jatkoa MyBrainSP:n AI Second Brain -toteutukselle (PRD-lähdeaineisto `docs/PRD.md.bak`).

---

## Knowledgebase-yhteensopivuus

**Knowledgebase-versio**: 1.1 (documentation-standard)  
**Viimeksi päivitetty**: 2026-11-13

### Noudatetut määritykset

- [x] `01-workflows/new-project-setup.md` — sovellettu (ei Next.js-pohjaa, ei Supabasea — agenttiprojekti)
- [x] `01-workflows/SYSTEM_INSTRUCTIONS.md` luettu
- [x] `01-workflows/workflow-rules.md` luettu (kirjattu AGENTS.md:hen "ei gitiä vielä" -tilalle soveltuvana)
- [x] `03-configs/documentation-standard.md` sovellettu 2026-11-13 (AGENTS.md, HANDOVER.md, viimeksi.md perustettu; poikkeamat alla)
- [x] `03-configs/devin/project-window-colors.md` — turkoosi `#1E4A47` asetettu `.vscode/settings.json`
- [x] `03-configs/ARCHITECTURE.md` / `UI_UX_STANDARDS.md` / `MCP_INTEGRATION.md` luettu (sovelletaan koodikannan rakentuessa)
- [ ] Ei sovellu vielä: Supabase, Vercel, OAuth, keep-alive (Vercel tulee Vaiheessa 4)

### Dokumentoidut poikkeamat

| Kohta | Knowledgebase | Tämä projekti | Syy |
|-------|---------------|---------------|-----|
| Versio | VERSION-vakio koodissa / juureen | **Ei vielä lainkaan** — aktivoidaan kun koodipohja syntyy (juuren VERSION-tiedosto ensin, Klack-SDD-malli) | Ei koodikantaa (päätös 2026-11-13) |
| Dumpit | Generoidut tai käsin, `docs/dumps/` | Kansio **tyhjä** nyt; täytetään Vaihe 1:n jälkeen; malli = **generoidut** (MelbAi-Hub) | Ei rakennetta kuvattavana (päätös 2026-11-13) |
| Git/GitHub | Repo alustettu + push-automaatio | **Ei git-repoksi vielä** | Päätös 2026-11-13; alustetaan Vaiheessa 0/1 |
| Hosting/Tietokanta | Vercel/Supabase | Paikallinen md-varasto nyt; Vercel Vaihe 4:ssä | Agenttiprojektin vaiheistus |
| PRD | `docs/PRD.md` toteutettuna | Tyhjä — kirjoitetaan ennen Vaihe 1:ää (lähde `PRD.md.bak`) | Lopullinen PRD-versio päivitetään |

---

## Linkit

| Palvelu | URL | Huomiot |
|---------|-----|---------|
| **Production** | — | paikallinen järjestelmä |
| **GitHub** | — | luotaessa: `https://github.com/Spalmgre/Klack-Tehdas` |

---

## Asetukset

Ei Supabase-/Vercel-määrityksiä vielä. Kehysväri: turkoosi `#1E4A47` (inactive `#143230`).

## Rakenteen erityispiirteet

- `.gitignore` jo valmiina (env, node_modules, `nul`-estoja) ennen git-initiä.
- `docs/` sisältää (2026-11-13): `PRD.md` (tyhjä), `PRD.md.bak` (12,7 kt Second Brain -määritelmä), `dumps/` (tyhjä), kaksi `mybrainsp-reference-*`-tiedostoa (MyBrainSP v1.40 -dumps-kappalekappaleet — odottavat lopullista poistopäätöstä; duplikaatteja MyBrainSP-reposta).
- Zero Trust -periaatteet kirjattu juuren AGENTS.md:hen (read-only integraatiot, ei suoraa lähetystä, work/private-erottelu).

## Ratkaistut ongelmat (tässä projektissa)

| Päivämäärä | Ongelma | Knowledgebase-dokumentti |
|------------|---------|--------------------------|
| — | (ei vielä) | — |

---

## Muistiinpanot

- Aiemmin sessiossa (2026-11-13) luotu: AGENTS.md, HANDOVER.md, viimeksi.md, README.md, .gitignore, .vscode/settings.json.
- Seuraavat askeleet: HANDOVER.md §4 (PRD-sisältö → git-init → memory/wiki-runko + VERSION).

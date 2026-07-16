# Devin / Cascade - IDE-asetukset

Tämä tiedosto sisältää kaikki Devin/Cascade-asetukset jotka eivät kulje projektin git-repon mukana. Nämä on asetettava kerran käyttäjän Devin-työtilassa.

**Tärkeää:** Knowledgebase (`dev-knowledgebase`) voi jakaa ohjeet, mutta ei itse asetuksia. Lue tämä tiedosto jokaiselle uudelle työasennolle tai kun uusi agentti-ominaisuus otetaan käyttöön.

---

## Mistä asetukset löytyvät

1. Avaa Devin-asetukset: **Devin - Settings** → **Advanced Settings**
2. Vasemmasta valikosta osio **Cascade** → **Configuration**

---

## Pakolliset asetukset

### 1. Allow list (Auto-execute commands)

Lisää seuraavat patternit rivi kerrallaan:

```
git *
npm *
npx *
firebase *
```

Tämä sallii automaattisen suorituksen ilman "Run"-napin painamista.

### 2. Auto execution

Aseta: **`Auto`**

Turbo Mode ajaa kaikki komennot automaattisesti (myös vaaralliset). Älä käytä.

### 3. Auto-generate memories

Aseta: **Päällä**

Tallentaa tärkeän kontekstin automaattisesti.

### 4. Auto-open edited files

Aseta: **Päällä**

Avaa muokatut tiedostot taustalla.

### 5. Cascade in background

Aseta: **Päällä**

Mahdollistaa komentojen ajon kun vaihdat keskustelua.

---

## MCP-palvelimet

MCP-palvelimet asetetaan Devin-asetusten **MCP servers** -kohdassa. Projekti ei voi pakottaa näitä gitin kautta.

### Suositeltavat palvelimet kaikille projekteille

| Palvelin | Käyttötarkoitus | Pakollisuus |
|----------|----------------|-------------|
| Supabase MCP | Tietokannan hallinta | Vain Supabase-projekteille |
| Google Cloud MCP (gcloud + Cloud Storage) | Firebase / GCP-toiminnot | Vain Google-projekteille — katso `03-configs/google/mcp-setup.md` |

### Mitä EI asenneta globaalisti

- **Vercel MCP** — ei asenneta, ellei projekti käytä Verceliä
- **Ylimääräiset turvallisuusriskit** — älä asenna tuntemattomia palvelimia

---

## Google AI Skills

Skillit ovat Devinin sisäänrakennettuja tietolähteitä jotka tarjoavat ohjeita ja kontekstia tietyistä teknologioista. Ne rekisteröidään projektiin `.agents/skills/` ja `.claude/skills/` -hakemistoihin sekä `skills-lock.json` -tiedostoon.

### Saatavilla olevat Google/Cloud -skillit

| Skill | Käyttötarkoitus |
|-------|----------------|
| `gemini-api` | Gemini API + GenAI SDK (multimodal, tools, streaming) |
| `gcloud` | gcloud CLI -hallinta (turvallinen käyttö, denylist) |
| `agent-platform-inference` | Gemini + OpenMaaS mallikutsut, autentikointi |
| `gemini-agents-api` | Agenttien luonti & hallinta Agent Platformilla |
| `gemini-interactions-api` | Stateful multi-turn Interactions API |
| `agent-platform-rag-engine-management` | RAG Engine -hallinta |
| `cloud-run-basics` | Cloud Run services/jobs/worker pools |
| `find-skills` | Uusien skillien löytäminen ja asennus |

### Asennusohje uuteen projektiin

1. Luo tyhjät hakemistot: `.agents/skills/<skill-nimi>` ja `.claude/skills/<skill-nimi>`
2. Lisää `skills-lock.json`:ään entry source-tiedolla
3. Commitoi muutokset

### Firebase-skillit (automaattisesti mukana)

`firebase-basics`, `firebase-auth-basics`, `firebase-hosting-basics`, `firebase-app-hosting-basics`, `firebase-firestore-standard`, `firebase-firestore-enterprise-native-mode`, `firebase-data-connect`, `firebase-ai-logic`, `firestore-security-rules-auditor`, `developing-genkit-dart`, `developing-genkit-go`, `developing-genkit-js`

---

## Projekti- vs. IDE-asetusten erottelu

| Mitä | Missä | Synkkaako gitillä |
|------|-------|-------------------|
| `AGENTS.md` | Projektikansiossa | Kyllä |
| `.env` | Projektikansiossa (ei git) | Ei |
| Devin Allow list | IDE / `%APPDATA%\devin\config.json` | Ei |
| MCP-palvelimet | IDE-asetukset | Ei |
| Knowledgebase-ohjeet | `dev-knowledgebase` | Kyllä |

---

## Nopea tarkistuslista uudelle projektille

- [ ] Allow list: `git *`, `npm *`, `npx *`, `firebase *`
- [ ] Auto execution: `Auto`
- [ ] Auto-generate memories: päällä
- [ ] Auto-open edited files: päällä
- [ ] Cascade in background: päällä
- [ ] MCP-palvelimet projektin teknologioiden mukaan

---

## Jakelu uusille projekteille

1. Kopioi tämän tiedoston sisältö projektin `docs/devin-setup.md` -tiedostoon
2. Lisää projektin `AGENTS.md`:n pakolliseen alustukseen viittaus: *"Tarkista että Devin-asetukset on tehty ohjeen mukaan: `03-configs/devin/ide-setup.md`"*

---

**Päivitetty**: 2026-07-16  
**Versio**: 1.2

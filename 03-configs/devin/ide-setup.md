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
| gcloud / Google Storage | Firebase / GCP-toiminnot | Vain Google-projekteille |

### Mitä EI asenneta globaalisti

- **Vercel MCP** — ei asenneta, ellei projekti käytä Verceliä
- **Ylimääräiset turvallisuusriskit** — älä asenna tuntemattomia palvelimia

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

**Päivitetty**: 2026-07-13  
**Versio**: 1.0

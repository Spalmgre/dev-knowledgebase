# Devin / Cascade - IDE-asetukset

Tämä tiedosto sisältää kaikki Devin/Cascade-asetukset jotka eivät kulje projektin git-repon mukana. Nämä on asetettava kerran käyttäjän Devin-työtilassa.

**Tärkeää:** Knowledgebase (`dev-knowledgebase`) voi jakaa ohjeet, mutta ei itse asetuksia. Lue tämä tiedosto jokaiselle uudelle työasennolle tai kun uusi agentti-ominaisuus otetaan käyttöön.

---

## Kaksi eri agenttia — tarkista kumpaa ajat

| Agentti | Mistä tunnistat | Miten luvat asetetaan |
|---------|-----------------|------------------------|
| **Devin CLI (ACP)** — nykyinen | Chatissa näkyy permission mode ja `Shift+Tab` vaihtaa sitä | `config.json` → `permissions` + permission mode |
| **Legacy Cascade** — vanha | Asetuksissa "Allow list" ja "Auto execution" | Devin - Settings → Advanced Settings → Cascade |

**Tärkeää:** Devin CLI **ei lue** legacy Cascaden Allow listiä eikä `Auto execution` -asetusta. Jos ajat Devin CLI:tä, käytä alla olevaa permissions-mallia. Legacy-ohjeet ovat lopussa osiossa *Legacy Cascade*.

---

## Pakolliset asetukset (Devin CLI)

### 1. Permission mode

Vaihdetaan **`Shift+Tab`**illa tai slash-komennolla. Vaikuttaa vain nykyiseen istuntoon.

| Tila | Tiedostomuokkaus | Terminaalikomennot |
|------|------------------|--------------------|
| `normal` | kysyy | kysyy |
| `accept-edits` | auto (työtilassa) | kysyy |
| `bypass` (`/bypass`) | auto | auto |
| `autonomous` | kysyy | auto (vaatii `--sandbox`) |

**Suositus pitkiin kehitysajoihin:** `bypass` yhdessä `deny`-listan kanssa. Ilman deny-listaa bypass antaa agentille vapaat kädet koko koneelle.

### 2. Oletustila jokaiselle uudelle istunnolle

Tiedosto `%APPDATA%\devin\User\settings.json`:

```json
"devin.acp.agentPreferences": {
  "devin-cli": {
    "mode": "bypass",
    "model": "claude-opus-5-medium"
  }
}
```

Ilman tätä jokainen uusi istunto alkaa oletustilassa ja `Shift+Tab` pitää muistaa erikseen.

### 3. permissions-lista (allow / deny)

Käyttäjätasolla `%APPDATA%\devin\config.json`, projektitasolla `<projekti>\.devin\config.json` (kulkee gitissä).

Tarkistusjärjestys: **deny → ask → allow → oletus (kysy)**. Deny voittaa aina — **myös bypass-tilassa**. Siksi deny-lista on ainoa turvaverkko bypassia käytettäessä.

Syntaksi on prefix-pohjainen: `Exec(git)` kattaa `git status`, `git commit -m "..."` jne. Älä lisää kapeita sääntöjä kuten `Exec(git status)` — ne ovat turhia ja lista paisuu käyttökelvottomaksi.

Suositeltu projektipohja:

```json
{
  "permissions": {
    "allow": [
      "Exec(npm)", "Exec(npx)", "Exec(node)", "Exec(git)", "Exec(gh)",
      "Exec(firebase)", "Exec(gcloud)",
      "Exec(powershell)", "Exec(pwsh)",
      "Exec(Get-ChildItem)", "Exec(Get-Content)", "Exec(Select-String)",
      "Exec(Test-Path)", "Exec(cd)",
      "Write(C:\\TYO\\GitHub Local\\<projekti>\\**)"
    ],
    "deny": [
      "Exec(Remove-Item)", "Exec(rm)", "Exec(rmdir)", "Exec(del)",
      "Exec(git push --force)", "Exec(git reset --hard)", "Exec(git clean)",
      "Write(**/.env)", "Write(**/.env.*)", "Write(**/.git/**)"
    ]
  }
}
```

Varauma: deny on prefix-matchaava, joten se pysäyttää `Remove-Item -Recurse ...` mutta ei putkitettua muotoa `Get-ChildItem | Remove-Item`. Turvavyö, ei panssari — oikea suoja on tiheä commit-tahti.

**Wrapper-sudenkuoppa (v2.1):** Prefix-matchaus vertaa komennon alkua, joten mallin joskus tuottama kääre `powershell -Command "Get-Content ..."` **ei** matchaa `Exec(Get-Content)`-sääntöön — matchauksen kohde on sana `powershell`. Siksi pohjaan kuuluu `Exec(powershell)` ja `Exec(pwsh)`. Vastaavasti deny-lista ei suojaa wrapperin sisältä: `powershell -Command "Remove-Item ..."` menee läpi. Tämä on hyväksytty kompromissi — ks. `04-issues-resolved/powershell-command-kaare-estaa-prefix-match-2026-08-06.md`. Ohjeista mallia AGENTS.md:ssä kutsumaan komentoja suoraan ilman wrapperia (shell on jo PowerShell).

### 4. Auto-continue (invocation limit)

Tiedosto `%APPDATA%\devin\User\settings.json`:

```json
"devin.autoContinue": 0
```

`0` tai negatiivinen = auto-continue **päällä** (agentti jatkaa rajattomasti). Positiivinen luku (oletus `40`) = agentti pysähtyy siihen määrään työkalukutsuja ja kysyy "jatketaanko". Vastaintuitiivinen: pienempi arvo = enemmän automaatiota.

### 5. Auto-generate memories

Aseta: **Päällä**

Tallentaa tärkeän kontekstin automaattisesti.

### 6. Auto-open edited files

Aseta: **Päällä**

Avaa muokatut tiedostot taustalla.

### 7. Cascade in background

Aseta: **Päällä**

Mahdollistaa komentojen ajon kun vaihdat keskustelua.

---

## Legacy Cascade (vain jos ajat vanhaa agenttia)

Nämä asetukset löytyvät: **Devin - Settings** → **Advanced Settings** → **Cascade** → **Configuration**.

- **Allow list**: `git *`, `npm *`, `npx *`, `firebase *`
- **Auto execution**: `Auto` (Turbo ajaa kaikki komennot, myös vaaralliset — älä käytä)

Devin CLI ei lue näitä. Jos komennot kysyvät lupaa vaikka Allow list on kunnossa, ajat Devin CLI:tä ja korjaus on `permissions`-listassa (osio 3).

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
| Devin `permissions` (käyttäjä) | `%APPDATA%\devin\config.json` | Ei |
| Devin `permissions` (projekti) | `<projekti>\.devin\config.json` | Kyllä |
| Permission mode -oletus | `%APPDATA%\devin\User\settings.json` | Ei |
| MCP-palvelimet | IDE-asetukset | Ei |
| Knowledgebase-ohjeet | `dev-knowledgebase` | Kyllä |

---

## Nopea tarkistuslista uudelle projektille

- [ ] `<projekti>\.devin\config.json`: `permissions.allow` projektin toolchainille + `permissions.deny` tuhoaville komennoille
- [ ] `%APPDATA%\devin\User\settings.json`: `mode` = `bypass` (tai `accept-edits` jos haluat vahvistaa komennot)
- [ ] `%APPDATA%\devin\User\settings.json`: `devin.autoContinue` = `0`
- [ ] Auto-generate memories: päällä
- [ ] Auto-open edited files: päällä
- [ ] Cascade in background: päällä
- [ ] MCP-palvelimet projektin teknologioiden mukaan

---

## Jakelu uusille projekteille

1. Kopioi tämän tiedoston sisältö projektin `docs/devin-setup.md` -tiedostoon
2. Lisää projektin `AGENTS.md`:n pakolliseen alustukseen viittaus: *"Tarkista että Devin-asetukset on tehty ohjeen mukaan: `03-configs/devin/ide-setup.md`"*

---

**Päivitetty**: 2026-08-06  
**Versio**: 2.1 (lisätty `Exec(powershell)`/`Exec(pwsh)` pohjaan + wrapper-sudenkuoppa-osio; v2.0: Devin CLI permission modet + `permissions`-lista)

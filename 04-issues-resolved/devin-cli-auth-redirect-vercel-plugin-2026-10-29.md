# Devin CLI:n selainkirjautuminen rikki (OAuth”loopback/callback) — Vercel-plugin asennettiin Desktopin UI:sta ilman CLI:ää

## Ongelma

Haluttiin asentaa Vercel-plugin AI-koodausagentille. Vercelin virallinen dokumentaatio
(`vercel.com/docs/agent-resources/vercel-plugin`) ohjaa asennukseen komennolla
`npx plugins add vercel/vercel-plugin`, mutta:

- **Devin ei ole pluginin tuettujen työkalujen listalla** (tuetut: ChatGPT, Claude Code,
  Codex, Cursor, Copilot, Grok Build, Kimi, Kiro, OpenCode, VS Code) — komento ei tunnista
  Deviniä asennuskohteeksi.
- Komento vaatii lisäksi **Bun**-runtimen, jota ei ollut asennettuna.
- Devinin oma `devin.exe plugins install vercel/vercel-plugin` olisi toiminut
  (repo sisältää `.claude-plugin/plugin.json`-manifestin, jonka Devinin plugin-lataaja tukee),
  mutta plugin-hallinta vaatii CLI-kirjautumisen — ja CLI:n auth on rikki.

## Oireet

1. `devin.exe auth login` → "Log in with browser" → selain näytti **"Invalid redirect URI"**
2. `devin.exe auth login --force-manual-token-flow` → token-tulo onnistui
   ("Login successful! Credentials stored."), jättämällä `credentials.toml`:iin
   `windsurf_api_key = "devin-session-token$..."` + `api_server_url = https://server.codeium.com`
   — legacy Windsurf -tokeni, jota `auth status` ja `plugins list` **eivät hyväksy**
   ("Not logged in." / "You must be logged in to manage plugins.")
3. Toisella selainvirran yrityksellä selain sanoi **"Connected to Devin"**, mutta paikallinen
   CLI ei koskaan kirjoittanut uusia tunnisteita (`credentials.toml` koskematon) — OAuth
   loopback-callback ei saavuttanut CLI:ää.

## Juurisyy

Desktopiin paketoitu CLI-binaari
(`C:\Users\<user>\AppData\Local\Programs\Devin\resources\app\extensions\windsurf\devin\bin\devin.exe`,
versio 3000.11.216) kärsi OAuth-virran paikallisesta callback-käsittelystä: kirjautumisen
serveripuoli onnistui, mutta loopback-redirect paikalliseen prosessiin ei toiminut.
Plugin-hallinta hyväksyy vain uudentyyppisen Devin-kirjautumisen — manuaalisen virtauksen
tuottama legacy Windsurf -session-tokeni ei riitä.

## Ratkaisu (kiertoreitti, joka toimii)

**Pluginit voi asentaa Devin Desktopin omaan kirjautumiseen perustuvalla
"Customize → Plugins" -näkymällä ilman toimivaa CLI-authia:**

1. Devin Desktop: vasemman reunan **Customize → Plugins**-välilehti
2. Valitse marketplace'sta/syötä **Vercel** (repo `vercel/vercel-plugin`, polku `plugins/vercel`)
   tai **Add plugin → From repository** → `vercel/vercel-plugin`
3. Asenna **Personal**-scopella → koskee kaikkia koneen projekteja ja synkkaa pilvisessioihin
4. Pluginin mukana tuleva **vercel-MCP** (`https://mcp.vercel.com`) tulee aktivoida
   Customize-näkymän MCP-lohkossa — OAuth-linkitys tehdään yhdellä klikkauksella
   ("MCP account linked successfully")
5. Pluginin **skills ja slash-komennot latautuvat vasta uusien sessioiden käynnistyessä**;
   MCP sen sijaan aktivoitui ajossa olevaan sessioon heti

Varmistus:

- MCP: `mcp_list_tools` palvelimelle `devin/vercel` → täysi työkalusetti
  (search_vercel_documentation, deployments, runtime logs, env vars, jne.)
- Skills: Desktopin plugin-näkymä näyttää 33 skilliä (build-agents, vercel-storage,
  react-best-practices, vercel-firewall, knowledge-update, routing-middleware, ...)
- Ei MCP-duplikaatiota: pluginin tuoma `vercel`-MCP oli sessiossa ainoa Vercel-MCP

## Konteksti

- Projekti: dev-knowledgebase / kaikki projektit (globaali ratkaisu)
- Päivämäärä: 2026-10-29 (ratkaistu ja kirjattu samana päivänä)
- Kone: Windows, Devin Desktop, CLI 3000.11.216, Node.js v22.23.4 (Bunia ei asennettu)
- Plugin pinned SHA asennushetkellä: `cbcae3bbf36b5cb77e85689956fa2a8d3ae35565`
- Liittyy: `03-configs/vercel/vercel-plugin-2026-10-29.md` (globaali asennustila ja käyttö)
- Avoin jatkokeissi CLI:lle: jos CLI:n omat toiminnot (`devin plugins` komentoriviltä)
  tarvitaan myöhemmin, kokeile ensin Devin Desktopin Command Palette → **Install Devin CLI**
  (virallinen asennus PATH:iin) ja sitten `devin auth login`; ellei auta, tukipyyntö
  windsurf.com/support (mainitse: OAuth loopback callback ei saavuta CLI:tä,
  "Invalid redirect URI" / callback-putki katkeaa).

## Avainsanat

vercel plugin, Vercel, plugin asennus, Devin Desktop, Customize Plugins, Personal scope,
devin auth login, Invalid redirect URI, OAuth, loopback, callback, manual token flow,
force-manual-token-flow, Not logged in, plugins install, MCP, mcp.vercel.com, skills,
slash commands, Bun, npx plugins, marketplace

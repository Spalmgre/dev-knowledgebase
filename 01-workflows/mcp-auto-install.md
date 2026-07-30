# MCP-palvelimien automaattinen tarkistus ja asennus

Pakollinen menettely kaikille agenteille: jos projekti käyttää Supabasea tai Verceliä, agentti tarkistaa vastaavan MCP-palvelimen saatavuuden ja asentaa sen itse. Käyttäjää pyydetään vain välttämättömiin kertatoimenpiteisiin (OAuth-kirjautuminen, PAT-tokenin luonti, IDE:n uudelleenkäynnistys).

---

## Vaihe 1: Tunnista projektin palvelut

Tutki projektin teknologiat:

- **Supabase:** `package.json` riippuvuudet `@supabase/*`, `.env`-avaimet `SUPABASE_*` tai `NEXT_PUBLIC_SUPABASE_*`
- **Vercel:** `vercel.json`, `.vercel/`-kansio, `VERCEL_*` env-avaimet, tai Vercel-maininnat dokumentaatiossa
- Jos **kumpaakaan ei ole** → ohita tämä workflow kokonaan

**Tarkistus:** Olet varma käyttääkö projekti Supabasea tai Verceliä.

---

## Vaihe 2: Tarkista MCP-työkalujen saatavuus

Katso oma työkaluluettelosi tässä istunnossa:

- **Supabase MCP** → pitäisi näkyä työkaluja kuten `list_projects`, `execute_sql`
- **Vercel MCP** → pitäisi näkyä työkaluja kuten `list_deployments`

Jos työkalut **näkyvät** → MCP on kunnossa, jatka normaaliin työhön. Ohita loput vaiheet.
Jos työkalut **ei näy** → jatka Vaiheeseen 3.

**Tarkistus:** Tiedät onko MCP asennettu vai ei.

---

## Vaihe 3: Asenna MCP itse (agentti tekee)

Devinin MCP-asetukset ovat tiedostossa `%APPDATA%\devin\config.json` (Windows). Agentti voi muokata tätä tiedostoa suoraan.

### Vercel (suositeltu: OAuth, ei tokenia tiedostoon)

Lisää `mcpServers`-lohkoon:

```json
{
  "mcpServers": {
    "vercel": {
      "type": "http",
      "url": "https://mcp.vercel.com"
    }
  }
}
```

OAuth-kirjautuminen tapahtuu selaimessa kun Devin käynnistyy uudelleen.

### Supabase (suositeltu: OAuth)

```json
{
  "mcpServers": {
    "supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp"
    }
  }
}
```

### Supabase (vaihtoehto: PAT, jos OAuth ei toimi)

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--project-ref=<PROJECT_REF>"
      ],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<PAT_TOKEN>"
      }
    }
  }
}
```

**Tärkeät säännöt:**
- Älä koskaan kirjoita tokenia chat-historiaan tai versionhallintaan
- Käytä aina `--project-ref` rajamaan yhteen projektiin
- Säilytä `config.json`:n muut asetukset (permissions, version jne.) ennallaan — lisää vain `mcpServers`-avain tai yksi palvelin sen alle

**Tarkistus:** `config.json` sisältää oikean MCP-palvelimen ja tiedoston JSON on validi.

---

## Vaihe 4: Käyttäjän kertatoimenpide (vain jos pakollinen)

Pyydä käyttäjää tekemään **vain** jokin näistä, ei muuta:

- **OAuth-palvelimet (Vercel, Supabase):** "Käynnistä Devin uudelleen. Selain avautuu kirjautumiseen — kirjaudu ja hyväksy."
- **Supabase PAT (vain jos OAuth ei toimi):** "Mene https://supabase.com/dashboard/account/tokens, klikkaa Generate new token, kopioi se ja liitä tähän viestiin." (Agentti lisää tokenin config.json:ään, ei käyttäjä.)
- **IDE-restart:** "Sulje Devin kokonaan (kaikki ikkunat) ja käynnistä uudelleen."

**Tarkistus:** Käyttäjä on tehnyt pyydetyn toimenpiteen.

---

## Vaihe 5: Varmistus

Seuraavassa istunnossa (IDE-restartin jälkeen):

1. Tarkista että MCP-työkalut näkyvät työkaluluettelossa
2. Kokeile yksinkertaista kyselyä:
   - Supabase: `list_projects` → varmista oikea projekti
   - Vercel: `list_deployments` → varmista oikea projekti
3. Jos työkalut näkyvät → MCP on valmis, jatka varsinaiseen tehtävään

**Tarkistus:** MCP-työkalut toimivat ja oikea projekti on näkyvissä.

---

## Vianmääritys

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| Työkalut ei näy restartin jälkeen | JSON-syntaksivirhe config.json:ssa | Tarkista JSON-validiteetti (`node -e "JSON.parse(require('fs').readFileSync(...))"`) |
| "Unauthorized" | Token vanhentunut tai väärä | Luo uusi PAT, päivitä config.json |
| OAuth-kirjautuminen ei avaudu | Devin ei tue http-tyyppistä MCP:tä | Käytä npx/PAT-vaihtoehtoa Supabaselle |
| Projektia ei löydy | Väärä `project-ref` | Tarkista Supabase Dashboardista Project ID |

---

## Palvelukohtaiset yksityiskohdat

- Supabase MCP: `03-configs/supabase/mcp-setup.md`
- Vercel MCP: `03-configs/vercel/mcp-setup.md`

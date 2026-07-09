# Vercel MCP - Config

Vercel-integraatio tekoälyagenteille. Mahdollistaa deploymenttien, projektien, ympäristömuuttujien ja lokien hallinnan suoraan keskustelusta.

**Päivitetty**: 2026-07-09  
**Versio**: 1.0

---

## Suositeltu tapa 1: Vercelin virallinen MCP (etäpalvelin + OAuth)

Vercel ylläpitää virallista MCP-päätettä osoitteessa `https://mcp.vercel.com`. Se tukee uusinta OAuth- ja Streamable HTTP -määritystä.

### Automaattinen asennus

Useat asiakkaat tunnistavat palvelimen automaattisesti:

```bash
npx add-mcp https://mcp.vercel.com
```

tai Claude Code -käyttäjille:

```bash
claude mcp add --transport http vercel https://mcp.vercel.com
```

### Manuaalinen asennus

Jos asiakas tukee HTTP-tyyppistä MCP-palvelinta, lisää konfiguraatioon:

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

Tarkista aina että käytät virallista päätettä: `https://mcp.vercel.com`.

### Tunnistautuminen

Asiakas ohjaa selaimella Vercelin OAuth-kirjautumiseen. Myönnä vaaditut oikeudet. Token hallitaan OAuth-virran kautta, eikä sitä tarvitse kopioida konfiguraatioon.

---

## Vaihtoehtoinen tapa 2: Paikallinen adapteri API-tokenilla

Jos asiakas ei tue Vercelin OAuth-MCP:tä, käytä npm-pakettia `@vercel/mcp-adapter` henkilökohtaisella API-tokenilla.

### 1. Luo Vercel API token

1. Mene https://vercel.com/account/tokens
2. Luo uusi token (anna kuvaava nimi, esim. "Agent MCP")
3. Kopioi token heti (ei näy myöhemmin uudelleen)

### 2. Lisää token ympäristömuuttujaksi

```bash
# .env.local (tai käyttöjärjestelmän env)
VERCEL_API_TOKEN=vercel_api_token_tähän
```

Jos adapteri valittaa muuttujan nimestä, kokeile myös `VERCEL_TOKEN`.

### 3. MCP-konfiguraatio

#### Cursor

Tiedosto: `.cursor/mcp.json`

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp-adapter"],
      "env": {
        "VERCEL_API_TOKEN": "${VERCEL_API_TOKEN}"
      }
    }
  }
}
```

Huom: Cursor ei välttämättä laajenna `${VERCEL_API_TOKEN}` automaattisesti. Jos niin käy, korvaa suoraan token-arvolla (älä commitoi).

#### Claude Desktop / Claude Code

Tiedosto: `~/.claude/mcp.json`

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp-adapter"],
      "env": {
        "VERCEL_API_TOKEN": "<your-vercel-api-token>"
      }
    }
  }
}
```

#### Tiimin kanssa

Jos projekti kuuluu tiimille, lisää myös tiimi-ID:

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["-y", "@vercel/mcp-adapter"],
      "env": {
        "VERCEL_API_TOKEN": "<your-vercel-api-token>",
        "VERCEL_TEAM_ID": "<team-id>"
      }
    }
  }
}
```

Tiimin ID:n näet Vercel Dashboardin URL:sta: `https://vercel.com/<team-id>/<project>`.

### 4. Tarkistus

1. Käynnistä IDE / MCP-asiakas uudelleen.
2. Tarkista että Vercel-työkalut ilmestyvät.
3. Kokeile:
   ```
   Listaa viimeisimmät deploymentit tästä projektista.
   ```

---

## Vaihtoehto 3: Suora Vercel REST API

Jos MCP:ää ei voi käyttää, voit kutsua Vercelin REST API:a suoraan API-tokenilla.

### Esimerkki: hae projektin deploymentit

```bash
curl -G "https://api.vercel.com/v6/deployments" \
  -H "Authorization: Bearer $VERCEL_API_TOKEN" \
  -d "projectId=$VERCEL_PROJECT_ID" \
  -d "limit=5"
```

### Tarvittavat muuttujat

```env
VERCEL_API_TOKEN=<token>
VERCEL_PROJECT_ID=<project-id>
VERCEL_TEAM_ID=<team-id>   # vain tiimiprojekteille
```

- `VERCEL_PROJECT_ID`: Vercel Dashboard → Project Settings → General → Project ID
- `VERCEL_TEAM_ID`: Vercel Dashboard URL:sta (jos tiimi)

---

## Yleiset ympäristömuuttujat projektiin

```env
VERCEL_API_TOKEN=<token>        # vain paikalliselle adapterille / suorille API-kutsuille
VERCEL_PROJECT_ID=<project-id>
VERCEL_TEAM_ID=<team-id>        # tarvittaessa
```

---

## Turvallisuusohjeet

- **API token on henkilökohtainen**: Älä jaa sitä tiimin ulkopuolelle äläkä commitoi.
- **Rajoita oikeudet**: Luo token vain tarvittavilla scopella (yleensä "Read/Write Projects" riittää agentille).
- **Aseta vanhenemisaika**: Käytä 90 päivää tai vähemmän; poista token jos et enää tarvitse MCP:itä.
- **OAuth on turvallisin**: Käytä virallista `https://mcp.vercel.com` -päätettä kun mahdollista.
- **Älä commitoi** `.cursor/mcp.json`, `.claude/mcp.json` tai vastaavia jos niissä on tokeneita.

---

## Vianmääritys

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| "Unauthorized" / 401 | Token vanhentunut tai väärä | Luo uusi token ja päivitä konfiguraatio |
| "Team required" | Projekti kuuluu tiimille | Lisää `VERCEL_TEAM_ID` |
| "Project not found" | Väärä `VERCEL_PROJECT_ID` | Tarkista Project Settings → General |
| MCP-työkalut eivät näy | Asiakas ei lataa palvelinta | Käynnistä IDE uudelleen, tarkista JSON |
| `npx @vercel/mcp-adapter` epäonnistuu | Verkko-ongelma / väärä paketti | Varmista `@vercel/mcp-adapter` eikä kolmannen osapuolen paketti |

---

## Tarkistuslista

- [ ] Vercel API token luotu
- [ ] Token tallennettu turvallisesti (`.env.local` / salaisuuksien hallinta)
- [ ] Virallinen MCP (`https://mcp.vercel.com`) tai adapteri konfiguroitu
- [ ] Tiimi-ID lisätty jos tarpeen
- [ ] MCP-työkalut näkyvät asiakkaassa
- [ ] Testikomento ajettu onnistuneesti

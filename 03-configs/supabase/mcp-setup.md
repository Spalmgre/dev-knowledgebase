# Supabase MCP & Agent API - Config

Supabase-integraatio tekoälyagenteille. Mahdollistaa tietokannan hallinnan, kyselyt ja skeemamuutokset suoraan keskustelusta.

**Päivitetty**: 2026-07-09  
**Versio**: 1.0

---

## Suositeltu tapa: Supabase MCP Server

Supabasen virallinen MCP-palvelin tarjoaa yli 20 työkalua: taulujen hallinta, SQL-kyselyt, RLS-politiikat, Edge-funktiot, tyyppigenerointi jne.

### 1. Tarvittavat tiedot

Hae Supabase Dashboardista:

- **Project ref**: `abcdefgh12345678` (osana URL:ää `https://<project-ref>.supabase.co`)
- **Personal Access Token (PAT)**: Supabase Dashboard → Account → Access Tokens
  - Tai **Service Role Key**: Project Settings → API → `service_role` key
- Huomaa: service role key ohittaa kaiken RLS:n — käsittele kuin pääkäyttäjän salasanaa

### 2. Asetukset asiakaskohtaisesti

#### Cursor

Tiedosto: `.cursor/mcp.json` projektin juuressa.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--read-only",
        "--project-ref=<your-project-ref>"
      ],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<your-personal-access-token>"
      }
    }
  }
}
```

Kirjoitusoikeuksilla (vain kehitykseen / ei production-tietokantoihin):

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--project-ref=<your-project-ref>"
      ],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<your-personal-access-token>"
      }
    }
  }
}
```

#### Claude Desktop / Claude Code

Tiedosto: `~/.claude/mcp.json` tai `claude_desktop_config.json`.

```json
{
  "mcpServers": {
    "supabase": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest",
        "--read-only",
        "--project-ref=<your-project-ref>"
      ],
      "env": {
        "SUPABASE_ACCESS_TOKEN": "<your-personal-access-token>"
      }
    }
  }
}
```

#### Virallinen etäpääte (OAuth / streamable HTTP)

Joillain asiakkailla voi käyttää suoraan Supabasen isännöimää MCP-päätettä:

```json
{
  "mcpServers": {
    "supabase": {
      "type": "http",
      "url": "https://mcp.supabase.com/mcp?project_ref=<your-project-ref>&read_only=true",
      "headers": {
        "Authorization": "Bearer <your-personal-access-token>"
      }
    }
  }
}
```

### 3. Tarkistus

1. Käynnistä IDE / MCP-asiakas uudelleen.
2. Tarkista että Supabase-työkalut ilmestyvät työkalulistaan.
3. Kokeile kyselyä:
   ```sql
   SELECT * FROM "ChatSession" LIMIT 5;
   ```

### 4. Ympäristömuuttujat projektiin

```env
NEXT_PUBLIC_SUPABASE_URL=https://<your-project-ref>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon-public-key>
SUPABASE_SERVICE_ROLE_KEY=<service-role-key>   # vain server-side, ei MCP-konfiguraatioon tarvittaessa
```

---

## Vaihtoehto: Suora Supabase REST API

Jos MCP-palvelinta ei voi asentaa (esim. rajoitettu ympäristö), voit kutsua Supabase REST API:a suoraan service role key:llä. Tämä ei vaadi MCP:itä.

### 1. Endpoint

```
https://<your-project-ref>.supabase.co/rest/v1/<table-or-view>
```

### 2. Headers

```
apikey: <anon-public-key>
Authorization: Bearer <service-role-key>
Content-Type: application/json
```

### 3. Esimerkki: listaa taulu (Node.js / fetch)

```typescript
const url = `https://<your-project-ref>.supabase.co/rest/v1/ChatSession?select=*&limit=5`;
const res = await fetch(url, {
  headers: {
    apikey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    Authorization: `Bearer ${process.env.SUPABASE_SERVICE_ROLE_KEY!}`,
    'Content-Type': 'application/json',
  },
});
const data = await res.json();
```

### 4. Esimerkki: Supabase JS client server-side

```typescript
import { createClient } from '@supabase/supabase-js';

const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!,
  { auth: { autoRefreshToken: false, persistSession: false } }
);

const { data, error } = await supabaseAdmin
  .from('ChatSession')
  .select('*')
  .limit(5);
```

### 5. Raja-arvot ja turvallisuus

- Käytä service role keyä **vain server-side**.
- Säilytä avain `.env.local`:ssa tai salaisuuksien hallinnassa.
- Älä lähetä avainta clientille tai tallenna versionhallintaan.
- Suojaa REST-kutsut omalla API-reitillä äläkä kutsu suoraan selaimesta.

---

## Turvallisuusohjeet

- **Read-only ensin**: Käytä aina `--read-only` tai `read_only=true` production-tietokantoihin.
- **Project scope**: Rajaa MCP yhteen projektiin `--project-ref` / `project_ref` -parametrillä.
- **Service role key**: Ohittaa RLS:n. Älä käytä jollet hallitse agentin toimia.
- **PAT (Personal Access Token)**: Antaa tilikohtaisen pääsyn; rajaa scope mahdollisuuksien mukaan.
- **Älä commitoi** MCP-asetuksia, joissa on avaimia.

---

## Vianmääritys

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| "Authentication failed" | Väärä token tai service role key | Tarkista `SUPABASE_ACCESS_TOKEN` tai service role key |
| "Project not found" | Väärä `project-ref` | Tarkista project reference Dashboardista |
| MCP-työkalut eivät näy | Asiakas ei tunnistanut palvelinta | Käynnistä IDE uudelleen, tarkista JSON-syntaksi |
| RLS ei vaikuta | Agentti käyttää service roleä | Oikein MCP:ssä, mutta tarkista oikeudet manuaalisesti |
| Read-only rikkoo kirjoitusoperaatiot | Read-only päällä | Poista `--read-only` vain kehityksessä |

---

## Tarkistuslista

- [ ] Project ref varmistettu
- [ ] PAT tai service role key luotu ja turvallisesti tallennettu
- [ ] `.cursor/mcp.json` (tai vastaava) lisätty projektiin
- [ ] Read-only asetettu production-tietokantoihin
- [ ] MCP-työkalut näkyvät asiakkaassa
- [ ] Testikysely ajettu onnistuneesti

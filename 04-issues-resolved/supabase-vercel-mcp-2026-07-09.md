# Supabase & Vercel MCP - Ratkaistu Tarve

**Ongelma**: Knowledgebasessa ei ollut valmista konfiguraatiota Supabase- ja Vercel-MCP:iden käyttöön tekoälyagenttien kanssa  
**Ratkaistu**: 2026-07-09  
**Projekti**: Klack-SaaS-Chat (huomio havaittu tässä projektissa, sovellettavissa kaikkiin)  
**Avainsanat**: supabase, vercel, mcp, model context protocol, agent, cursor, claude, devin, service role key, rest api, deployment

---

## Ongelma

Kun Klack-SaaS-Chat -projektissa pyydettiin tekoälyagenttia hallitsemaan Supabase-tietokantaa ja Vercel-deploymenteja, agentti vastasi että knowledgebase ei sisällä valmista MCP-konfiguraatiota. Tarvittiin ohjeistus ja kopioitavat asetukset, jotta samat ratkaisut ovat jatkossa käytettävissä kaikissa projekteissa.

## Oireet

- Agentti ei löytänyt Supabase MCP -asetuksia knowledgebasesta.
- Agentti ei löytänyt Vercel MCP -asetuksia knowledgebasesta.
- Ratkaisua haettiin manuaalisesti projektikohtaisesti.

## Juurisyy

Knowledgebase sisälsi Supabase- ja Vercel-asetukset (OAuth, env-muuttujat, deployment), mutta ei MCP-protokollan kautta tapahtuvaa agentti-integraatiota eikä varavaihtoehtoista suoraa REST API -käyttöä.

## Ratkaisu

Lisätty knowledgebaseen kaksi uutta konfiguratiedostoa ja niihin viittaava ongelmatietue.

### 1. Supabase MCP -asetukset

Tiedosto: `03-configs/supabase/mcp-setup.md`

Sisältää:
- Supabasen virallisen MCP-palvelimen asennuksen (`@supabase/mcp-server-supabase`)
- Konfiguraatioesimerkit Cursorille, Claude Desktopille ja streamable HTTP -päätteelle
- Project scoping (`--project-ref`) ja read-only -tilan käytön
- Vaihtoehtoisen suoran Supabase REST API -käytön service role key:llä
- Turvallisuusohjeet service role keylle ja PAT-tokenille

### 2. Vercel MCP -asetukset

Tiedosto: `03-configs/vercel/mcp-setup.md`

Sisältää:
- Virallisen Vercel MCP -päätteen `https://mcp.vercel.com` (OAuth)
- Paikallisen adapterin `@vercel/mcp-adapter` API-tokenilla
- Konfiguraatioesimerkit Cursorille ja Claude Code -käyttäjille
- Tiimi-ID:n käytön tiimiprojekteissa
- Vaihtoehtoisen suoran Vercel REST API -käytön

### 3. Konfiguraatiotiedostojen linkitys

Päivitetty:
- `03-configs/supabase/AGENTS.md` → `mcp-setup.md` listattu ja käyttöohjeessa mainittu
- `03-configs/vercel/AGENTS.md` → `mcp-setup.md` listattu ja käyttöohjeessa mainittu

## Konteksti

- Havainto tehtiin Klack-SaaS-Chat -projektissa, kun agentti tarvitsi tietokanta- ja deployment-hallintaa.
- Ratkaisu tehtiin globaalisti knowledgebaseen, jotta kaikki nykyiset ja tulevat projektit voivat kopioida asetukset.

## Lopputulos

Nyt knowledgebase sisältää valmiit, kopioitavat Supabase- ja Vercel-MCP-konfiguraatiot. Agentit voivat jatkossa viitata niihin suoraan.

---

**Testattu ja dokumentoitu:**
- [x] Klack-SaaS-Chat -kontekstiin perustuva ratkaisu
- [x] Konfiguraatiot tallennettu `03-configs/` -kansioon

**Mahdollisia parannuksia:**
- Päivitetään tiedostoja kun Supabase / Vercel julkaisee MCP-asetuksiin muutoksia.
- Lisätään asiakaskohtaisia esimerkkejä (Devin, VS Code Copilot) tarvittaessa.

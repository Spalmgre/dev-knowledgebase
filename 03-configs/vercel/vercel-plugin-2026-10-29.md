# Vercel-plugin (agent-tietosisältö) — globaali asennustila

**Päivitetty**: 2026-10-29
**Tila**: Asennettu Personal-scopella (koskee automaattisesti kaikkia projekteja)

> Tämä dokumentti täydentää `mcp-setup.md`-tiedostoa. `mcp-setup.md` kuvaa MCP:n
> asentamisen perinteisesti; tässä kuvattu plugin-polku on ylempänä oleva, helpompi reitti,
> sampar sisältää MCP:n lisäksi myös Vercel-skills-opit agenttiin.
>
> Edelleen voimassa: ohita kokonaan, jos projekti ei käytä Verceliä.

---

## Mitä plugin antaa agentille

Vercelin virallinen agent-plugin (repo `vercel/vercel-plugin`, polku `plugins/vercel`)
asennettuna Devin Desktopiin:

- **MCP**: `vercel` (`https://mcp.vercel.com`, OAuth-linkitys tehty Customize-näkymästä)
  — deployments, runtime logs, env vars, dokumentaatiohaku, jne.
- **33 skilliä**: mm. `deployments-cicd`, `env-vars`, `ai-sdk`, `vercel-functions`,
  `react-best-practices`, `vercel-storage`, `routing-middleware`, `bootstrap`
- **3 custom subagenttia**: `deployment-expert`, `performance-optimizer`, `ai-architect`
- **Slash-komennot**: `/vercel:deploy [prod]`, `/vercel:env`, `/vercel:bootstrap`,
  `/vercel:status` (jos namespace ei toimi, kokeile `/vercel-plugin:`-etuliitettä)

## Asennettu tila (referenssi)

| Kohde | Arvo |
|---|---|
| Scope | Personal (käyttäjätaso → kaikki projektit + pilvisessiot samalla tilillä) |
| Repo | `vercel/vercel-plugin`, polku `plugins/vercel` |
| Pinned SHA | `cbcae3bbf36b5cb77e85689956fa2a8d3ae35565` |
| Asennustapa | Devin Desktop: **Customize → Plugins → Vercel** |
| MCP | Aktivoitu Customize-näkymästä, OAuth linkitetty |

## Käyttöönotto uudessa projektissa / uudella koneella

1. Plugin on jo asennettu — **ei mitään projektikohtaista tekemistä**.
2. Agentti saa skilleissä Vercel-kontekstin automaattisesti uudessa sessiossa kaikista
   projektikansioista; komennot toimivat `/vercel:...`-muodossa tarpeen tullen.
3. Projektin `AGENTS.md`-tiedostoa ei tarvitse päivittää pluginin takia.
4. Uudella koneella: plugin synkkaa Personal-manifestin kautta kirjautumalla; jos synkka
   ei tapahdu, asenna Desktopin Customize → Plugins -näkymästä.
5. Session-start-kontekstin automaattinen injektointi aktivoituu vain tyhjissä
   hakemistoissa ja havaituissa Vercel/Next.js/eve-projekteissa — muussa tapauksessa
   skillit ovat silti saatavilla on-demand.

## Huom: älä asenna `npx plugins`-reittiä Devinin puolesta

Vercelin dokumentaation komento `npx plugins add vercel/vercel-plugin` ei tue Deviniä ja
vaatii Bunin; Devinissä vastaava on Desktopin Customize → Plugins (tai toimivalla CLI
-kirjautumisella `devin plugins install vercel/vercel-plugin`). Yksityiskohdat CLI-auth-ongelmasta:
`04-issues-resolved/devin-cli-auth-redirect-vercel-plugin-2026-10-29.md`.

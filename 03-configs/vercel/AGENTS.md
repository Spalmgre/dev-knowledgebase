# Vercel Configs - Agent Instructions

Toimivat Vercel-asetukset ja -määritykset.

## Saatavilla olevat tiedostot

| Tiedosto | Sisältö |
|----------|---------|
| `project-settings.md` | Vercel-projektin perusasetukset |
| `environment-variables.md` | Required env-muuttujat |
| `mcp-setup.md` | MCP-integraatio tekoälyagenteille + suora REST API -varavaihtoehto |

## Käyttö

Uudessa projektissa:
1. Lue `project-settings.md` ja konfiguroi asetukset
2. Lisää kaikki env-muuttujat `environment-variables.md` listasta
3. Testaa deployment
4. Jos käytät tekoälyagentteja Vercelin hallintaan, lue `mcp-setup.md`

## Huomioitavaa

- **Git-integraatio** on tärkein - varmista että push triggeröi deploymentin
- **Build cache** voi aiheuttaa ongelmia - käytä "Redeploy without cache" jos ongelmia
- **Environment variables** täytyy lisätä erikseen jokaiseen ympäristöön

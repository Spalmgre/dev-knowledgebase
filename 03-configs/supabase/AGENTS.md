# Supabase Configs - Agent Instructions

Toimivat Supabase-asetukset ja -määritykset.

## Saatavilla olevat tiedostot

| Tiedosto                  | Sisältö                                                                |
| ------------------------- | ---------------------------------------------------------------------- |
| `oauth-providers.md`      | GitHub & Google OAuth setup                                            |
| `rls-templates.sql`       | Valmiit RLS-politiikkapohjat                                           |
| `schema-patterns.md`      | Yleiset tietokantamallit                                               |
| `keep-alive-heartbeat.md` | Ilmaistason projektin pausetuksen esto (GitHub Action + Edge Function) |
| `mcp-setup.md`            | MCP-integraatio tekoälyagenteille + suora REST API -varavaihtoehto       |

## Käyttö

Uudessa projektissa:

1. Lue `oauth-providers.md` ja konfiguroi providerit
2. Kopioi tarvittavat RLS-politiikat `rls-templates.sql` tiedostosta
3. Suunnittele skeema `schema-patterns.md` avulla
4. Jos käytät tekoälyagentteja tietokannan kanssa, lue `mcp-setup.md`

## Huomioitavaa

- **RLS pitää olla aina päällä** production-tauluissa
- **OAuth callback URL:t** täytyy olla täsmälleen oikein
- **Region-valinta**: Frankfurt (eu-central-1) vähentää viivettä

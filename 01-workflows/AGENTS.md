# 01-workflows - Agent Instructions

Tämä kansio sisältää vaiheittaiset prosessit ja työnkulut.

## Säännöt

- **Lue aina kokonainen workflow** ennen aloittamista
- **Seuraa vaiheet numerojärjestyksessä** - älä skipaa vaiheita
- **Merkitse valmiiksi** kunkin vaiheen kohdalle kun se on tehty
- **Jos kohtaat virheen** → pysäytä ja raportoi käyttäjälle

## Saatavilla olevat workflowt

| Tiedosto                        | Käyttötarkoitus                                                     |
| ------------------------------- | ------------------------------------------------------------------- |
| `new-project-setup.md`          | Uuden projektin perustaminen tyhjästä (Next.js-pohja)               |
| `SYSTEM_INSTRUCTIONS.md`        | Käyttöohjeet kaikille agenteille kaikissa projekteissa              |
| `workflow-rules.md`             | Git-automaatio, deploy-lokien tarkistus ja knowledgebase-auto-commit  |
| `expo-vercel-web-deploy.md`     | Expo / react-native-web -sovelluksen julkaisu web-PWA:na Vercelillä |
| `supabase-oauth-setup.md`       | OAuth-kirjautumisen asennus Supabaseen                              |
| `vercel-github-troubleshoot.md` | Vercel + GitHub ongelmien debug (myös deploymentin korjaus)         |

## Kun lisäät uuden workflowin

1. Noudata samaa rakennetta: Ongelma → Vaiheet → Tarkistus
2. Käytä numeroituja listoja (1., 2., 3.)
3. Lisää "Tarkistus"-kohta jokaisen vaiheen lopuksi
4. Päivitä tämä AGENTS.md uuden workflowin tiedoilla

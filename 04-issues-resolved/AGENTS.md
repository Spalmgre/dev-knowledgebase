# 04-issues-resolved - Agent Instructions

Tämä kansio sisältää ratkaistut ongelmat ja niiden ratkaisut.

## Säännöt

- **Tarkista aina ensin** kun kohtaat ongelman - onko ratkaisu jo täällä?
- **Lue koko dokumentti** - ratkaisu voi olla lopussa
- **Päivitä dokumentti** jos löydät paremman ratkaisun
- **Sovella ratkaisu** sellaisenaan ellei konteksti vaadi muutoksia

## Dokumenttien rakenne

Jokaisessa dokumentissa pitää olla:

1. **Ongelma**: Mitä yritettiin ratkaista
2. **Oireet**: Miten ongelma ilmeni
3. **Juurisyy**: Mikä aiheutti ongelman (jos tiedossa)
4. **Ratkaisu**: Tarkat askeleet ratkaisuun
5. **Konteksti**: Mikä projekti, milloin, kuka ratkaisi
6. **Avainsanat**: Hakusanat (vercel, github, deployment, jne.)

## Kun lisäät uuden dokumentin

1. Käyttäjä sanoo: "Lisää knowledgebaseen" tai "Tämä on globaalisti käytettävä"
2. Luo tiedosto: `[kuvaava-nimi]-[YYYY-MM-DD].md`
3. Noudata yllä olevaa rakennetta
4. Ilmoita käyttäjälle: "Kirjattu knowledgebaseen: [tiedostonimi]"

## Olemassa olevat ratkaisut

| Tiedosto                                      | Ongelma                                                |
| --------------------------------------------- | ------------------------------------------------------ |
| `vercel-github-trigger-2025-06-16.md`         | Vercel ei triggeröitynyt GitHub-pushista               |
| `git-push-vaatii-ide-allowlist-2026-06-23.md` | Git push -auto vaatii Devinin allowlistin (`git *`) |
| `supabase-vercel-mcp-2026-07-09.md`           | Supabase & Vercel MCP -konfiguraatio puuttui           |
| `vercel-eve-agent-framework-2026-07-16.md`    | EVE-agenttikehyksen arviointi ja käyttöönotto          |

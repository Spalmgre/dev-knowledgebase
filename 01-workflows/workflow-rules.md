# Työnkulun säännöt

## Git-automaatio

Git push tehdään automaattisesti ilman erillistä kysymistä, kun:
1. Koodimuutokset on tehty
2. `npm run build` onnistuu (exit 0)

// turbo
Komento: `git add -A && git commit -m "[viesti]" && git push`

Tämä koskee kaikkia projekteja.

**IDE-asetus (tee kerran):** Lisää Windsurf/Cascade-asetuksiin auto-run allowlist pattern `git *` jotta git-komennot eivät vaadi napinpainallusta. Settings → Cascade → Auto-run Commands.

## Deploy-lokien tarkistus

Agentin on aina tarkistettava lokit itsenäisesti deployn jälkeen ilman käyttäjän erillistä pyyntöä.

Firebase Functions: `firebase functions:log --only <funktio>`
Yleinen tarkistus: `firebase functions:log`

Tarkistus tehdään ennen tehtävän sulkemista. Jos lokeissa on virheitä, raportoi ne käyttäjälle ja korjaa ennen jatkoa.

## Knowledgebase-muutosten automaattinen commit

Aina kun dev-knowledgebase-kansion tiedostoja päivitetään, agentin on automaattisesti commitoitava ja pushattava muutokset GitHubiin ilman käyttäjän erillistä pyyntöä.

Komento: `git add -A && git commit -m "docs: päivitä workflow-rules.md" && git push`

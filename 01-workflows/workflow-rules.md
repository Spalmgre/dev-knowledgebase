# Työnkulun säännöt

## Git-automaatio ja muutosten omistajuus

Git push tehdään automaattisesti ilman erillistä kysymistä, kun:
1. Agentin oma tehtävämuutos on valmis ja validoitu.
2. Projektin vaadittu tarkistus, kuten `npm run build`, onnistuu.
3. Commitiin on stagettu **vain agentin tässä tehtävässä muuttamat tiedostot**.

### Pakollinen menettely jaetussa työpuussa

1. Suorita työn alussa `git status --short` ja käsittele tulosta lähtötilana.
2. Älä muuta, stagetä, commitoi, stäshää, palauta tai poista lähtötilassa olleita muutoksia tai tiedostoja.
3. Työn valmistuttua suorita `git status --short` uudelleen ja stagetä omat tiedostot nimetyillä poluilla, esimerkiksi `git add src/feature.ts README.md`.
4. Tarkista staged sisältö komennolla `git diff --cached --check` ennen committia.
5. Commitoi ja pushaa vain staged muutos. Käytä `git add -A`, `git add .` tai `git commit -a` **vain**, jos käyttäjä on nimenomaisesti vahvistanut, että kaikki työpuun muutokset kuuluvat samaan tehtävään.
6. Raportoi lopuksi erikseen muut lähtötilasta jääneet muutokset. Älä kysy, pitääkö tunnistamattomat muutokset viedä eteenpäin; jätä ne koskematta, ellei käyttäjä erikseen pyydä niiden käsittelyä.

Tämä koskee kaikkia projekteja ja myös `dev-knowledgebase`-repositorya.

**IDE-asetus (tee kerran):** Lisää Devin/Cascade-asetuksiin auto-run allowlist pattern `git *` jotta git-komennot eivät vaadi napinpainallusta. Settings → Cascade → Auto-run Commands.

## Deploy-lokien tarkistus

Agentin on aina tarkistettava lokit itsenäisesti deployn jälkeen ilman käyttäjän erillistä pyyntöä.

Firebase Functions: `firebase functions:log --only <funktio>`
Yleinen tarkistus: `firebase functions:log`

Tarkistus tehdään ennen tehtävän sulkemista. Jos lokeissa on virheitä, raportoi ne käyttäjälle ja korjaa ennen jatkoa.

## Knowledgebase-muutosten automaattinen commit

Aina kun agentti päivittää `dev-knowledgebase`-kansion tiedostoja, sen on automaattisesti commitoitava ja pushattava **vain omat dokumentoidut muutoksensa** GitHubiin ilman käyttäjän erillistä pyyntöä.

Käytä nimettyä stagingia, esimerkiksi `git add 01-workflows/workflow-rules.md 04-issues-resolved/[tiedosto].md && git commit -m "docs: päivitä workflow-rules" && git push`. Noudata aina yllä olevaa jaetun työpuun menettelyä.

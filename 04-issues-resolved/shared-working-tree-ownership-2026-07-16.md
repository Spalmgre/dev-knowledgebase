# Jaetun työpuun keskeneräisten muutosten suojaus

## Ongelma

Agentin globaali Git-ohje käytti `git add -A` -komentoa kaikissa projekteissa. Jaetussa työpuussa komento voi sisällyttää samaan committiin toisen agentin, toisen tehtävän tai käyttäjän keskeneräiset muutokset.

## Oireet

- Agentti löytää `git status --short` -tuloksesta muutoksia, joita se ei itse tehnyt.
- Agentti pyytää käyttäjää päättämään tuntemattomien muutosten käsittelystä sen sijaan, että säilyttäisi ne.
- Laaja staging voi vahingossa julkaista epävalmiita tai asiaankuulumattomia tiedostoja.

## Juurisyy

`01-workflows/workflow-rules.md` määräsi blanket-stagingin (`git add -A`) eikä määritellyt työpuun lähtötilan, tiedostojen omistajuuden tai rajatun stagingin menettelyä.

## Ratkaisu

1. Tallenna jokaisen tehtävän alussa `git status --short` -lähtötila.
2. Kohtele kaikkia ennestään muuttuneita tai uusia tiedostoja muiden työnä, ellei käyttäjä nimenomaisesti nimeä niitä tehtävän osaksi.
3. Älä muuta, stagetä, commitoi, stäshää, palauta tai poista lähtötilan tiedostoja.
4. Stagetä tehtävän valmistuttua vain omat tiedostot nimetyillä poluilla.
5. Tarkista staged muutos `git diff --cached --check` -komennolla, commitoi ja pushaa vain se.
6. Raportoi lopuksi lähtötilasta jääneet muutokset, mutta jätä ne koskematta ilman erillistä käyttäjäkysymystä.

## Konteksti

- Knowledgebase: `dev-knowledgebase`
- Koskee: kaikkia knowledgebasen ohjeita käyttäviä projekteja
- Päivämäärä: 2026-07-16
- Päivitetyt ohjeet: `AGENTS.md`, `01-workflows/SYSTEM_INSTRUCTIONS.md`, `01-workflows/workflow-rules.md`

## Avainsanat

jaettu työpuu, git status, git add -A, staging, commit, push, muutosten omistajuus, keskeneräiset muutokset, agenttien yhteistyö

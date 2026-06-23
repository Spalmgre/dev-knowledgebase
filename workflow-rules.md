# Työnkulun säännöt

## Git-automaatio

Git push tehdään automaattisesti ilman erillistä kysymistä, kun:
1. Koodimuutokset on tehty
2. `npm run build` onnistuu (exit 0)

Komento: `git add -A && git commit && git push`

Tämä koskee kaikkia projekteja.

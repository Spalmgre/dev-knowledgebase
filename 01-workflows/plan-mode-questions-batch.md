# Plan-tilan selventävät kysymykset: esitä kaikki kerralla

**Päivämäärä**: 2026-08-23
**Konteksti**: Globaali toimintatapa, tallennettu myös Cascaden `global_rules.md`-tiedostoon
**Avainsanat**: plan mode, clarifying questions, batch, copy-paste, ask_user_question, arkkitehtiassistentti

---

## Ongelma

Käyttäjä kopioi Plan-tilan tuottamat selventävät kysymykset (a, b, c -vastausvaihtoehtoineen) toiseen AI-chattiin, joka toimii hänen arkkitehtiassistenttinaan. Kun kysymykset esitetään yksi kerrallaan, käyttäjä joutuu tekemään copy-pasten useita kertoja.

## Ratkaisu (globaali toimintatapa)

### Oletus: kaikki kysymykset kerralla yhtenä kopioitavana kokonaisuutena

- Kun Plan-tilassa tarvitaan useampia selventäviä kysymyksiä, esitä ne kaikki samassa viestissä yhtenä tekstinä - älä yksi kerrallaan.
- Muoto: numeroitu lista kysymyksistä, jokaisen kysymyksen alla vastausvaihtoehdot a), b), c) ...
- Kirjoita kysymykset ja vaihtoehdot tavallisena chattitekstinä (ei pelkästään `ask_user_question`-työkalun UI-valintoina), jotta käyttäjä voi kopioida koko blokin yhdellä kertaa toiseen AI-chattiin.
- Käyttäjä palauttaa yhden vastauspromptin, jossa vastataan kaikkiin kysymyksiin kerralla (esim. "1: b, 2: a, 3: c"). Tulkitse tällaiset vastaukset kaikkiin kysymyksiin kerralla.

### Poikkeus: ketjutetut kysymykset yksi kerrallaan

- Jos kysymysten välillä on riippuvuus (edellisen kysymyksen vastaus ohjaa seuraavan kysymyksen sisältöä tai vaihtoehtoja), esitä kysymykset yksi kerrallaan.
- Ilmoita tällöin selkeästi, että kyseessä on ketjutettu kysymys ja seuraava kysymys esitetään vastauksen jälkeen.

## Esimerkkimuoto

```
Selventävät kysymykset suunnitelmaa varten:

1. Mihin sääntö tallennetaan?
   a) Molempiin: global_rules.md + knowledgebase
   b) Vain global_rules.md
   c) Vain knowledgebase

2. Käytetäänkö kysymyksiin ask_user_question-työkalua lisäksi?
   a) Kyllä, työkalu + teksti
   b) Ei, vain tekstinä
```

Käyttäjän vastaus: `1: a, 2: b`

## Tallennuspaikat

- Cascade'n globaalit säännöt: `C:\Users\stefa\.codeium\windsurf\memories\global_rules.md` (lohko "PLAN MODE - SELVENTÄVÄT KYSYMYKSET")
- Tämä dokumentti: `01-workflows/plan-mode-questions-batch.md`

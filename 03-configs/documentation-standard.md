# Dokumentaatiostandardi — kaikki projektit

Tämä dokumentti määrittelee yhtenäiset dokumentaatiokäytännöt, jotka ovat voimassa kaikissa `C:\TYO\GitHub Local`-kansion projekteissa. Tavoite: dokumentaatio on joka hetki mahdollisimman ajantasainen, eikä sen ylläpito jää sattuman varaan.

**Pakollinen alustus:** aja aina ensin `cd "C:\TYO\GitHub Local\dev-knowledgebase" && git pull origin main`, jotta projekti toimii uusimman standardin mukaan.

---

## Neljä pakollista artefaktia

| Artefakti | Sijainti | Milloin päivitetään |
|-----------|----------|---------------------|
| **Versio** | Sovelluksen `VERSION`-vakio (koodissa) + maininta HANDOVER.md:ssä | Jokaisessa deployssa ja jokaisen julkaistavan version kohdalla |
| **AGENTS.md** | Projekti juuressa + lähin AGENTS.md kansiokohtaisesti | Jokaisen valmistuneen featuren jälkeen |
| **HANDOVER.md** | Projektin juuressa | Jokaisen merkittävän vaiheen valmistuttua: nykytila, korjatut bugit, tunnetut rajoitteet, seuraavat askeleet |
| **Kaksi dumppia** | `docs/dump/ARCHITECTURE_DUMP.md` + `docs/dump/UI_UX_DUMP.md` | Aina kun versiota nostetaan — **samassa commitissa** kuin versiotarkennus (ja lisäksi ennen jokaista julkaisua) |

### Perustelut

- **Versio** kertoo käyttäjälle ja agenteille mikä versio on missäkin ajossa (MelbAi-Hub: `const VERSION` App.jsx:ssä; MyBrainSP: `npm run status` näyttää v1.00+).
- **AGENTS.md** (DOX-ketju) on ainoa paikka josta toinen agentti-ikkuna löytää projektin säännöt ilman että käyttäjä toistaa niitä.
- **HANDOVER.md** on sessioiden välinen tilannekuva — uusi agenttisessio alkaa sen lukemisella, ei kontekstin arvaamisella.
- **Dumpit** ovat käyttäjän näkymä järjestelmään (esittely, NotebookLM/Gemini-lähteet): arkkitehtuuri + käyttäjänäkökulma. Epäjatkuvuus dumppeihin on regressiopoikkeama ja korjataan heti.

### Projektikohtaiset variaatiot

- MelbAi-Hub: dumpit **generoidaan** (`npm run generate-dumps`) — niitä ei koskaan muokata käsin; eivät ole osa `npm run verify`ä eikä kunkin commitin gatea.
- MyBrainSP: dumpit ylläpidetään käsin samassa commitissa versionnoston kanssa (`docs/dump/`), lisäksi loppuraportti `### LOPPURAPORTTI – VAIHE X VALMIS` Markdown-koodilohkona.
- Uudet projektit valitsevat mallin (generoidut vs käsin) ja kirjataan valinta omaan AGENTS.md:hen.

---

## Kopioitava prompti projektin omaan agentti-ikkunaan

**Tärkeä rajoitus:** dokumentaatiokäytäntöjen tarkistus pitää ajaa projektin omassa ikkunassa — toinen agentti-ikkuna ei voi varmistaa kohdeprojektin tilaa (vrt. title bar -värien snapshot-mekanismi).

```text
Yhtenäistä tämän projektin dokumentaatiokäytäntö knowledgebase-standardin mukaan:

1. Aja ensin: cd "C:\TYO\GitHub Local\dev-knowledgebase" && git pull origin main
2. Lue C:\TYO\GitHub Local\dev-knowledgebase\03-configs\documentation-standard.md
3. Tarkista ja täydennä projektin juuren AGENTS.md sisältämään nämä käytännöt
   (soveltaen projektin rakenteisiin, älä muuta koodia):
   - Versio nostetaan jokaisessa deployssa (VERSION-vakio koodissa) ja merkitään HANDOVER.md:hen
   - Lähin AGENTS.md päivitetään jokaisen featuren valmistuttua
   - HANDOVER.md juuressa päivitetään merkittävien vaiheiden yhteydessä:
     nykytila, korjatut bugit, tunnetut rajoitteet, seuraavat askeleet
   - docs/dump/ARCHITECTURE_DUMP.md ja docs/dump/UI_UX_DUMP.md päivitetään
     aina versionnoston yhteydessä samassa commitissa
4. Luo puuttuvat tiedostot (HANDOVER.md, docs/dump/) mallin mukaan, jos niitä ei ole.
5. Commitoi ja pushaa oman repon sääntöjen mukaan.
```

---

## Tarkistuslista projektia aloitettaessa

- [ ] `git pull origin main` ajettu knowledgebasessa
- [ ] Tämä dokumentti luettu
- [ ] AGENTS.md sisältää neljä pakollista dokumentaatiokäytäntöä
- [ ] HANDOVER.md olemassa ja ajantasainen
- [ ] Dump-tiedostot olemassa tai malli (generointi/käsin) valittu ja kirjattu AGENTS.md:hen
- [ ] Versiokäytäntö koodattu (VERSION-vakio) ja testattu

---

**Päivitetty**: 2026-11-06
**Versio**: 1.0

# viimeksi.md — sessioiden tehtävästatus-muistio ("tauko"-triggeri)

Globaali konventio: **jokaisen projektin juuressa on oma `viimeksi.md`**, joka kertoo yhdellä silmäyksellä missä työ menee ja mikä jää kesken (esim. työpäivä loppui tai sessio vaihtui toiseen ikkunaan).

## Tarkoitus

- Käyttäjä lukee tiedoston **ensimmäisenä** palatessa töihin — siirtää näkee heti kesken jääneet työt ja viimeisimmät sessiot.
- Tarkempi tieto haetaan tarvittaessa varsinaisesta sessiosta tai projektin omista dokumenteista (esim. HANDOVER.md, Projectlog.md) — viimeksi.md sisältää **vain lyhyet rivit**.

## Rakenne

```markdown
# viimeksi.md — missä mennään?

Lyhyt muistio työn etenemisestä. Palaessa töihin lue tämä ensin.
Päivitys: kirjoita "tauko" → Devin päivittää tämän tiedoston automaattisesti.
Rivimuoto: PVM: lyhyt kuvaus — status — seuraava askel

---

## 🔶 KESKEN
- 22.10.: v2.77 julkaistu — kesken: käyttäjän selaintestit — seuraava askel: aja HANDOVER.md:n testilista a–e

---

## VIIMEISIMMÄT SESSIOT (uusin ylimpänä)
- 22.10.: v2.77 julkaisu — valmis
- 21.10.: v2.76 korjaukset — valmis
```

### Säännöt

1. **KESKEN-osio on aina ylimpänä.** Rivimuoto: `PVM: lyhyt kuvaus — status — seuraava askel` (max yksi rivi).
2. **Historia** sisältää vain ~5–8 viimeisintä riviä, uusin ylimpänä; status "valmis" = commitoitu/julkaistu.
3. **Ei duplikointia** — jos projektissa on tarkempi dokumentti (HANDOVER.md, Projectlog.md, memory-bank/), viimeksi.md viittaa siihen rivittäin sen sijaan että kopiisi yksityiskohtia.
4. Suomeksi, sama sävy kuin muukin projektidokumentaatio.

## Päivityskäytäntö ("tauko"-triggeri)

Kun käyttäjä kirjoittaa **"tauko"**:

1. Päivitä projektin `viimeksi.md` **ENNEN muita toimia**:
   - Kesken jäänyt työ → merkintä KESKEN-osioon (kuvaus, status, seuraava askel).
   - Sessiossa valmistunut työ → rivi historiaan (uusin ylimmäksi); jos se oli KESKEN-osiossa, siirrä rivi sieltä.
2. Commitoi päivitys osana projektin tavallista git-työnkulkua.

Ilman sanaa "tauko" tiedostoa ei päivitetä jatkuvasti — triggeri pitää ylläpidon kevyenä. Jos kesken-listalla oleva asia viedään loppuun ilman "tauko"-merkintää, seuraava agentti saa siirtää rivin historiaan kun havaitsee sen.

## Käyttöönotto projektissa

1. Luo `viimeksi.md` repon juureen yllä olevan rakenteen mukaan.
2. Seeda historia: `git log --format="%ad %s" --date=format:"%d.%m." -8` → lyhyet rivit, status "valmis".
3. Jos `git status --short` näyttää commitoimattomia muutoksia → merkintä KESKEN-osioon ("commitoimattomia muutoksia työpuussa", listaa polut lyhyesti).
4. Kirjaa käytäntö myös projektin oman `AGENTS.md`:n jos käyttäjä sitä haluaa — globaali sääntö riittää kun knowledgebase-init suoritetaan (kaikki projektit vaativat sen).

# viimeksi.md — sessioiden tehtävästatus-muistio ("tauko"-triggeri)

Globaali konventio: **jokaisen projektin juuressa on oma `viimeksi.md`**, joka muistuttaa käyttäjää yhdellä silmäyksellä mistä kussakin sessiossa oli kyse ja mihin työ jäi — jotta käyttäjä tietää mistä jatkaa palatessaan takaisin Deviniin.

## Tarkoitus

- Käyttäjä lukee tiedoston **ensimmäisenä** palatessa töihin — pitää ymmärtää heti, mistä sessiossa oli kyse, ilman että pitää muistella teknisiä yksityiskohtia.
- Kirjoitustyyli on **käyttäjälle luettavaa proosaa**: ei koodinpätkiä, ei kansiopolkuja, ei päivämääriä. Tekniset yksityiskohdat jäävät varsinaisiin sessioihin ja projektin omiin dokumentteihin (esim. HANDOVER.md, Projectlog.md).

## Rakenne

Jokainen sessio on oma pieni kappaleensa kolmella osalla:

1. **Session nimi** (otsikko)
2. **Rivinvaihto, sitten pari lausetta** siitä, millä promptilla sessio aloitettiin — tämä antaa parhaan ymmärryksen siitä, mitä ollaan tekemässä
3. **Uudelle riville yhteenveto** siitä, mihin vaiheeseen sessio päättyi

```markdown
# viimeksi.md — missä mennään?

Lyhyt muistio työn etenemisestä. Palaessa töihin lue tämä ensin.
Päivitys: kirjoita "tauko" → Devin päivittää tämän tiedoston automaattisesti.

---

## 🔶 KESKEN

### Käyttäjätestauksen korjaukset v2.77 julkaisuun

Sessio aloitettiin pyynnöllä käydä läpi käyttäjän selaintesteissä löytyneet viat ja korjata ne ennen julkaisua. Töissä keskityttiin kirjautumisvirheeseen ja mobiilinäkymän rikkoutuvaan valikkoon.

Sessio päättyi siihen, että korjaukset on tehty ja julkaisu ajossa — seuraavaksi käyttäjä ajaa testilistan loppuun omassa selaimessaan.

---

## VIIMEISIMMÄT SESSIOT (uusin ylimpänä)

### v2.77 julkaisu

Sessio aloitettiin pyynnöllä viedä valmiit korjaukset julkaisuun ja varmistaa että kauppalupa toimii.

Julkaisu meni läpi ja sivusto toimii — työ valmis.

### Mobiilinäkymän viilaus

Sessio aloitettiin pyynnöllä parantaa sivuston ulkonäköä puhelimella, koska tekstit ahtautuivat liian pieneen tilaan.

Ulkoasu saatiin kuntoon ja muutokset julkaistu — työ valmis.
```

### Säännöt

1. **KESKEN-osio on aina ylimpänä.** Kesken oleva sessio merkitään sinne samalla kolmen osan muodolla (nimi, aloitusprompti parina lauseena, loppuvaiheen yhteenveto).
2. **Historia** sisältää vain ~5–8 viimeisintä sessiota, uusin ylimpänä.
3. **Ei päivämääriä, ei koodia, ei tiedosto- tai kansiopolkuja** — pelkkää selkeää suomea, josta käyttäjä tunnistaa asian. Tarkempi tieto haetaan tarvittaessa varsinaisesta sessiosta tai projektin omista dokumenteista.
4. **Ei duplikointia** — jos projektissa on tarkempi dokumentti (HANDOVER.md, Projectlog.md, memory-bank/), sitä ei kopioida viimeksi.md:hen.
5. Suomeksi, sama sävy kuin muukin projektidokumentaatio.

## Päivityskäytäntö ("tauko"-triggeri)

Kun käyttäjä kirjoittaa **"tauko"**:

1. Päivitä projektin `viimeksi.md` **ENNEN muita toimia**:
   - Kesken jäänyt sessio → kappale KESKEN-osioon: session nimi, pari lausetta alkuperäisestä promptista ja yhteenveto siitä mihin vaiheeseen jäätiin (mukaan luontevasti se, mistä jatketaan).
   - Sessiossa valmistunut työ → kappale historiaan (uusin ylimmäksi); jos se oli KESKEN-osiossa, siirrä kappale sieltä.
2. Kirjoita kappaleet käyttäjän näkökulmasta: mistä asiasta oli kyse ja missä mennään — älä teknisenä toteutuslistana.
3. Commitoi päivitys osana projektin tavallista git-työnkulkua.

Ilman sanaa "tauko" tiedostoa ei päivitetä jatkuvasti — triggeri pitää ylläpidon kevyenä. Jos kesken-listalla oleva asia viedään loppuun ilman "tauko"-merkintää, seuraava agentti saa siirtää kappaleen historiaan kun havaitsee sen.

## Käyttöönotto projektissa

1. Luo `viimeksi.md` repon juureen yllä olevan rakenteen mukaan.
2. Seeda historia muutaman viimeisimmän työvaiheen perusteella (esim. git-historiasta tai projektin dokumenteista) — lyhyet kappaleet yllä olevassa muodossa.
3. Jos työpuussa on kesken olevaa työtä → kappale KESKEN-osioon (kerro sanallisesti mitä ollaan tekemässä, älä listaa tiedostopolkuja).
4. Kirjaa käytäntö myös projektin oman `AGENTS.md`:n jos käyttäjä sitä haluaa — globaali sääntö riittää kun knowledgebase-init suoritetaan (kaikki projektit vaativat sen).

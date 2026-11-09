# Loppuraportti aina yhtenä kopioitavana tekstikoodilohkona

**Päivämäärä**: 2026-11-08
**Projekti**: MyBrainSP (toistuva käyttäjän kierto vaativimpien raporttien kanssa)

## Ongelma

Käyttäjä kokoaa joka istunnon päättyessä agentin lopputuloksia eri paikkoihin ja keskusteluihin. Kun lopputulos näkyy normaalina chat-tekstinä, sen kopiointi ohjelmistosta toisiin välineisiin riippuu yleensä tekstilohkojen manuaalisesta valinnasta — tämä osoittautui kömpelöksi.

## Ratkaisu

Jokaisen valmistuvan työn päätteeksi agentti kirjoittaa lopuksi raportin yhden ainoan tekstikoodilohkon (```` ```text ... ``` ````) sisään, joka alkaa rivillä `=== KOPIOI TÄSTÄ ALKAEN ===` ja loppuu riviin `=== KOPIOI TÄHÄN ASTI ===`. Sisältö:

- otsikko `### LOPPURAPORTTI – <TEHTÄVÄN NIMI>` (tai `### TILANNERAPORTTI – ODOTTAA OHJEITA`)
- commit-hash (jos tehtiin)
- testitulokset taulukkona
- mitä tehtiin + mitä seuraavaksi

Koskee kaikkia projekteja. Ohitetaan vain jos käyttäjä eksplisiittisesti pyytää lyhyttä vastausta ilman raporttia ("vastaa lyhyesti" tai vastaava).

Esimerkkimuoto:

````text
=== KOPIOI TÄSTÄ ALKAEN ===
### LOPPURAPORTTI – <TEHTÄVÄN NIMI>
- Juurisyy: ...
- Commit & Tag: <hash> ("<viesti>", N tiedostoa) → main → origin/main, tag vX.YY

### Tehdyt korjaukset
1. ...

### Testit ja tila
- typecheck: 0 virhettä
- testit: N/N PASS
- Työpuu: working tree clean, synkassa origin/main kanssa
- Käyttäjän seuraava askel: ...
=== KOPIOI TÄHÄN ASTI ===
````

## Konteksti

MyBrainSP-projektissa (v1.00→v1.20-sessiot) sääntö tuli AGENTS.md:n toimintatapasäännönä ja toimi moitteettomasti. MelbAi-JaKu-projekteissa on aikaisempi AGENTS.md-tapa "Vastausten pituus: vastaa vain kysyttyyn" — yhdistettävissä siten: lyhyt vastaus ensin, loppuun kopioitava raporttilohko.

Jotta promptia ei tarvitse toistaa joka sessiossa, lisää sääntö projektin omaan `AGENTS.md`-tiedostoon (vrt. MyBrainSP:n "Vuoron päättäminen (Pakollinen loppuraportti)" -kappale). Pysyvä muoto: `03-configs/documentation-standard.md` → "Pakollinen loppuraportti".

## Tallennuspaikat

- Devin (globaali, kaikki projektit): `~/.devin/global_rules.md` — osio "Pakollinen loppuraportti (koodituotanto)" (lisätty 2026-11-09)
- Projekteilla: kunkin projektin oma `AGENTS.md`
- Pysyvä standardi: `03-configs/documentation-standard.md`

## Avainsanat

loppuraportti, koodilohko, kopioi tästä, report block, agentti vastausmuoto

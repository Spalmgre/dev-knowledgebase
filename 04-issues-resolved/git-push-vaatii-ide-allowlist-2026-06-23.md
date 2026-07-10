# Git push vaatii napin painamisen (IDE allowlist)

## Ongelma

Agentti (Cascade/Devin) ei aja `git add -A && git commit && git push` -komentoa
automaattisesti, vaikka:

- globaali git-automaatiosääntö on kirjattu `workflow-rules.md`
- sääntö on agentin muistissa
- agentti merkitsee komennon automaattisesti ajettavaksi (`SafeToAutoRun=true`)

Käyttäjän pitää silti painaa hyväksyntänappia ("Run" / "Accept") joka kerta.

## Syy (juurisyy)

Komennon lopullinen auto-suoritus EI ole agentin päätettävissä. Se on IDE:n
turvaportin takana. Devin vaatii, että komento on käyttäjän hyväksymällä
**allowlistillä** TAI että **Turbo Mode** on päällä.

Tämä on tahallinen turvarajoitus: agentti ei voi itse ohittaa sitä, eikä mikään
muistiin tai knowledgebaseen kirjattu sääntö voi sitä kumota. Vain käyttäjä voi
sallia komennot asetuksista — kertaluonteisesti.

## Ratkaisu (käyttäjä tekee kerran) — VARMISTETTU TOIMIVAKSI 2026-06-23

TÄRKEÄÄ: Cascaden komento-allowlist EI ole tavallisessa VS Code Settings -haussa.
Hakusana "allow list" VS Code -asetuksissa näyttää vain Extensions/Terminal/Fonts
-tuloksia — ne ovat VÄÄRIÄ. Allowlist on Devinin omassa asetuspaneelissa.

### Tarkka polku (testattu, toimii)

1. Klikkaa ruudun **oikean alakulman statuspalkista** tekstiä **`Devin - Settings`**
   (se on `Pro`-tekstin ja `✓ Prettier`-tekstin välissä)
2. Avautuu Cascade-asetusvalikko. Klikkaa alhaalta **`Advanced Settings`**
3. Avautuu asetussivu. Vasemmasta valikosta osio **`Cascade`** → **`Configuration`**
4. Kohdassa **Allow list** ("Patterns for commands that are always auto-executed")
   klikkaa **`Add`**
5. Kirjoita riviksi:

   ```
   git *
   ```

   ('\*' lopussa = prefix matching → kattaa git add / commit / push / kaikki git-komennot)

6. Valmis. Ei erillistä tallennusnappia.

Lisäksi: varmista että samalla Cascade-sivulla **`Auto execution`** = **`Auto`**
(ei `Off`). Allowlist toimii Auto-tilassa.

### Vaihtoehto: täysi automaatio

`Auto execution` → **`Turbo`** ajaa KAIKKI komennot automaattisesti (myös vaaralliset
kuten tiedostojen poisto). Ei suositella; allowlist `git *` on turvallisempi.

### Vahvistus

Testattu 2026-06-23: `git add -A && git commit && git push` ajautui läpi
ILMAN "Run"-napin painamista heti kun `git *` lisättiin allowlistiin.

## Konteksti

- Projekti: Klack-Treeni (koskee kaikkia projekteja)
- Päivämäärä: 2026-06-23
- Liittyy: `workflow-rules.md` (globaali git-automaatiosääntö)

## Avainsanat

allowlist, allow list, turbo mode, git push automaatio, SafeToAutoRun,
hyväksyntä, auto-execute, Cascade terminal, Devin settings, ei pushaa,
nappi, run nappi

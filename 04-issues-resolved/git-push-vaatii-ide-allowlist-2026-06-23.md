# Git push vaatii napin painamisen (IDE allowlist)

## Ongelma

Agentti (Cascade/Windsurf) ei aja `git add -A && git commit && git push` -komentoa
automaattisesti, vaikka:
- globaali git-automaatiosääntö on kirjattu `workflow-rules.md`
- sääntö on agentin muistissa
- agentti merkitsee komennon automaattisesti ajettavaksi (`SafeToAutoRun=true`)

Käyttäjän pitää silti painaa hyväksyntänappia ("Run" / "Accept") joka kerta.

## Syy (juurisyy)

Komennon lopullinen auto-suoritus EI ole agentin päätettävissä. Se on IDE:n
turvaportin takana. Windsurf vaatii, että komento on käyttäjän hyväksymällä
**allowlistillä** TAI että **Turbo Mode** on päällä.

Tämä on tahallinen turvarajoitus: agentti ei voi itse ohittaa sitä, eikä mikään
muistiin tai knowledgebaseen kirjattu sääntö voi sitä kumota. Vain käyttäjä voi
sallia komennot asetuksista — kertaluonteisesti.

## Ratkaisu (käyttäjä tekee kerran)

### Mistä löydän Allow Listin (Windsurf)

Kaksi vaihtoehtoa:

**A) Turbo Mode (nopein, sallii kaiken auto-runin)**
1. Avaa Cascade-paneeli (chat oikealla)
2. Paneelin **alareunassa** syöttökentän vieressä on tila-valitsin:
   `Chat` / `Write` ja sen lähellä komentojen suoritustila
3. Vaihda tilaksi **Turbo** (tunnetaan myös "auto-execute commands")
4. Tämän jälkeen kaikki agentin turvalliseksi merkitsemät komennot ajetaan ilman nappia

**B) Allow List (turvallisempi, vain git sallitaan)**
1. Avaa **Windsurf Settings**:
   - Valikko: `File → Preferences → Settings` TAI pikanäppäin `Ctrl + ,`
   - TAI Windsurf-kuvake vasemmasta alakulmasta → **Advanced Settings**
2. Hae hakukentästä: **`allow list`** tai **`Cascade Terminal`**
3. Etsi osio **Cascade → Terminal → Allow List** (ja Deny List)
4. Lisää allowlistiin komentojen alkuosat:
   - `git add`
   - `git commit`
   - `git push`
5. Tallenna. Nämä komennot ajetaan jatkossa automaattisesti ilman hyväksyntää;
   muut potentiaalisesti vaaralliset komennot pyytävät edelleen vahvistuksen.

Suositus: **B (Allow List)** — turvallisin, koska vain git menee läpi.

## Konteksti

- Projekti: Klack-Treeni (koskee kaikkia projekteja)
- Päivämäärä: 2026-06-23
- Liittyy: `workflow-rules.md` (globaali git-automaatiosääntö)

## Avainsanat

allowlist, allow list, turbo mode, git push automaatio, SafeToAutoRun,
hyväksyntä, auto-execute, Cascade terminal, Windsurf settings, ei pushaa,
nappi, run nappi

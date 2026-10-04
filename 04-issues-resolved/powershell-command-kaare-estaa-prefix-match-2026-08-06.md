# powershell -Command -kääre estää prefix-matchauksen — luvat katoavat uudelleen

## Ongelma

Agentti pysähtyi jälleen lupapyyntöihin, vaikka 31.7.2026 oli tehty täydellinen
korjaus (permission mode + laajat allow-prefixit, ks.
`agentti-kysyy-lupaa-jokaiseen-komentoon-2026-07-31.md`). Ongelma palasi
toistuvasti.

## Oireet

- Komennot kuten `powershell -Command "Get-Content '...' -Tail 35"` kysyivät
  lupaa, vaikka `Exec(Get-Content)` oli allow-listalla
- Lupapyynnöt ilmaantuivat satunnaisesti — osa komennoista meni läpi, osa ei

## Juurisyy

Kaksi erillistä syytä:

1. **Wrapper-kääre rikkoo prefix-matchauksen.** `Exec()`-säännöt vertaavat
   komennon **alkua** kokonaisena sanana. Kun malli käärii komennon muotoon
   `powershell -Command "..."`, vertailun kohde on sana `powershell` — ei
   wrapperin sisällä oleva cmdlet. `powershell`/`pwsh` eivät olleet
   allow-listalla → lupapyyntö.
2. **Oletustila oli vaihtunut takaisin.** `%APPDATA%\devin\User\settings.json`
   sisälsi `"mode": "plan"` — 31.7. asetettu `"bypass"` oli kadonnut (muuttunut
   myöhemmin istunnon aikana). Ilman bypassia jokainen matchaamaton komento
   kysyy lupaa.

## Ratkaisu

### 1. Oletustila takaisin bypassiin

`%APPDATA%\devin\User\settings.json`:

```json
"devin.acp.agentPreferences": {
  "devin-cli": {
    "mode": "bypass"
  }
}
```

### 2. Salli shell-wrapperit allow-listalla

Lisää sekä käyttäjätason `%APPDATA%\devin\config.json` että projektitason
`.devin/config.json` allow-listaan:

```json
"Exec(powershell)", "Exec(pwsh)", "Exec(cmd)"
```

Nämä toimivat varmuudeksi tilanteisiin joissa tila ei ole bypass.

### 3. Deny-pariteetti

Varmista että projektitason deny-lista on yhtenäinen käyttäjätason kanssa
(MelbAi-Hubista puuttui `Exec(Remove-Item)`).

## Tietoturvarajauma — lue tämä

`Exec(powershell)` sallii **kaiken wrapperin sisällä**, koska deny-matchaus
kohdistuu ulompaan komentoon. `powershell -Command "Remove-Item -Recurse ..."`
menee siis läpi deny-listan ohi. Tämä on tietoisesti hyväksytty kompromissi:
käyttäjän prioriteetti on ettei agentti koskaan pysähdy lupapyyntöön.

Käytännön suoja:
- Tiheä commit-tahti — kaikki työ on gitissä ja palautettavissa
- Deny-lista suojaa edelleen suoria komentoja (`Remove-Item ...` ilman wrapperia)
- Changelogin mukaan deny-säännöt tunnistavat kielletyt komennot
  `&&`/`||`/`&`-ketjujen sisällä, mutta **ei** `powershell -Command "..."`
  -merkkijonon sisällä

## Miten estät wrapper-käyttäytymisen lievästi

AGENTS.md-ohjeistus mallille: "Älä kääri komentoja `powershell -Command`iin —
shell on jo PowerShell." Vähentää tapauksia mutta ei poista niitä kokonaan;
siksi allow-sääntö on tarvittava varmuus.

## Toistuminen: 2026-10-04

Mode-driifti tapahtui toisen kerran: `%APPDATA%\devin\User\settings.json` →
`agentPreferences.devin-cli.mode` oli jälleen `"plan"` (oli ollut `"bypass"`).
Oireena agentti kyseli jatkuvasti etenemislupia ja uudet istunnot avautuivat
Plan-tilaan. Korjaus oli sama: mode takaisin `"bypass"`:iin. Permissions-listat
olivat tällä kertaa kunnossa koko ajan — eli jos lupakyselyt palaavat,
**tarkista aina ensin mode** ennen listojen muokkausta. Muistutus driifistä
lisätty `03-configs/devin/ide-setup.md`:ään (v2.4).

## Konteksti

- Projekti: MelbAi-Hub (ratkaisu koskee kaikkia projekteja)
- Päivämäärä: 2026-08-06 (toistunut 2026-10-04, ks. yllä)
- Tehdyt muutokset:
  - `%APPDATA%\devin\User\settings.json` → `mode: "bypass"` (oli muuttunut `plan`:iksi)
  - `%APPDATA%\devin\config.json` → lisätty `Exec(powershell)`, `Exec(pwsh)`, `Exec(cmd)`
  - `MelbAi-Hub\.devin\config.json` → lisätty `Exec(powershell)`, `Exec(pwsh)` allow'hun ja `Exec(Remove-Item)` deny'hyn
  - `03-configs/devin/ide-setup.md` → v2.1
- Liittyy: `agentti-kysyy-lupaa-jokaiseen-komentoon-2026-07-31.md`

## Avainsanat

powershell -Command, pwsh, wrapper, kääre, prefix matching, Exec(powershell),
lupapyyntö palasi, permission denied, bypass-tila kadonnut, mode plan,
settings.json, allow-lista ei toimi, deny bypass, agentti pysähtyy taas

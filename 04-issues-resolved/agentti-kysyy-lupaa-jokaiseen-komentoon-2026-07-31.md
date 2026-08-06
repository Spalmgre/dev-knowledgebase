# Agentti kysyy lupaa jokaiseen komentoon — permission mode ja permissions-lista

## Ongelma

Pitkässä kehitysajossa (MelbAi-Hub) agentti pysähtyi jatkuvasti kysymään lupaa
terminaalikomentoihin. Käyttäjä vastasi joka kerta "kyllä", eli hyväksyntä ei
tuonut mitään turvaa — se vain pysäytti työn ja vaati jatkuvaa valvontaa.

## Oireet

- Jokainen `npm run ...`, `firebase ...`, `git ...` -variantti avasi hyväksyntädialogin
- "Always allow" -valinta auttoi vain kyseiseen komentoon; seuraava variantti kysyi taas
- `%APPDATA%\devin\config.json` oli paisunut 38 kapeaan sääntöön
  (`Exec(git status)`, `Exec(git log)`, `Exec(git add)`, `Exec(git commit)`, ...)
- Projektin `AGENTS.md`:n ohje "Allow list `git *` + Auto execution = Auto" ei auttanut

## Juurisyy

Kolme erillistä syytä:

1. **Väärä permission mode.** Käytössä oli `accept-edits`, joka hyväksyy
   tiedostomuokkaukset mutta **kysyy jokaisen terminaalikomennon**.
2. **Väärä ohje knowledgebasessa.** `03-configs/devin/ide-setup.md` (v1.2) neuvoi
   legacy Cascaden "Allow list" ja "Auto execution" -asetuksia. **Devin CLI (ACP)
   ei lue niitä lainkaan** — se käyttää `config.json` → `permissions` -osiota.
   Ohje oli siis oikea vanhalle agentille ja täysin tehoton nykyiselle.
3. **Kapeat allow-säännöt.** `permissions` on prefix-matchaava: `Exec(git)` kattaa
   jo kaikki git-komennot. Yksi kerrallaan "always allow" -napista kerätyt
   `Exec(git status)` -tyyppiset rivit ovat turhia, eivätkä kattaneet uusia
   komentovariantteja. Listalla oli myös virheellinen no-op-rivi `"*git"`.

Huom: `devin.autoContinue` **ei** liittynyt tähän. Arvo `0` tarkoittaa että
auto-continue on jo päällä (agentti jatkaa rajattomasti invocation-limitin yli).
Vastaintuitiivinen: positiivinen luku = pysähtyy ja kysyy.

## Ratkaisu

### 1. Oletustila bypass (poistaa kysymykset kokonaan)

`%APPDATA%\devin\User\settings.json`:

```json
"devin.acp.agentPreferences": {
  "devin-cli": {
    "mode": "bypass",
    "model": "claude-opus-5-medium"
  }
}
```

Ilman tätä oletustila palautuu joka istunnossa ja `Shift+Tab` pitää muistaa käsin.
Istuntokohtainen vaihto: `Shift+Tab` tai `/bypass`.

| Tila | Tiedostomuokkaus | Terminaalikomennot |
|------|------------------|--------------------|
| `normal` | kysyy | kysyy |
| `accept-edits` | auto | kysyy |
| `bypass` | auto | auto |
| `autonomous` | kysyy | auto (vaatii `--sandbox`) |

### 2. Deny-lista turvaverkoksi

**Deny voittaa aina, myös bypass-tilassa.** Tämä tekee bypassista riittävän
turvallisen: agentti saa vapaat kädet, mutta tuhoavat komennot on estetty.

Projektitasolla `<projekti>\.devin\config.json` (kulkee gitissä, koskee kaikkia
projektin agentteja):

```json
{
  "permissions": {
    "allow": [
      "Exec(npm)", "Exec(npx)", "Exec(node)", "Exec(git)", "Exec(gh)",
      "Exec(firebase)", "Exec(gcloud)", "Exec(gsutil)", "Exec(java)", "Exec(cd)",
      "Exec(Get-ChildItem)", "Exec(Get-Content)", "Exec(Select-String)",
      "Exec(Select-Object)", "Exec(Test-Path)", "Exec(Write-Output)",
      "Write(C:\\TYO\\GitHub Local\\<projekti>\\**)"
    ],
    "deny": [
      "Exec(Remove-Item)", "Exec(rm)", "Exec(rmdir)", "Exec(del)",
      "Exec(Clear-Content)", "Exec(Format-Volume)",
      "Exec(git push --force)", "Exec(git push -f)",
      "Exec(git reset --hard)", "Exec(git clean)",
      "Exec(gcloud projects delete)", "Exec(firebase projects:delete)",
      "Write(**/.env)", "Write(**/.env.*)", "Write(**/.git/**)"
    ]
  }
}
```

Käyttäjätasolla sama rakenne `%APPDATA%\devin\config.json`:iin (koskee kaikkia projekteja).

### 3. Siivoa kapeat säännöt

Poista kaikki `Exec(<komento> <alikomento>)` -rivit ja korvaa prefixillä:
`Exec(git status)` + `Exec(git add)` + `Exec(git commit)` → **`Exec(git)`**.
Poista myös epäkelvot rivit kuten `"*git"`.

### Tarkistusjärjestys (tärkeä ymmärtää)

```
deny  →  ask  →  allow  →  oletus (kysy)
```

## Rajoitukset — lue tämä

- Deny on **prefix-matchaava**. Se pysäyttää `Remove-Item -Recurse ...` mutta ei
  välttämättä putkitettua muotoa `Get-ChildItem | Remove-Item`. Turvavyö, ei panssari.
- Bypass-tilassa et näe komentoja ennakkoon, vain jälkikäteen. Oikea turvaverkko on
  tiheä commit-tahti ja se että työ on gitissä.
- Bypass **ei** ohita organisaation Team Settings -tasoisia deny/ask-sääntöjä.
- Peruminen on yhden rivin muutos: `"bypass"` → `"accept-edits"`.

## Konteksti

- Projekti: MelbAi-Hub (ratkaisu koskee kaikkia projekteja)
- Päivämäärä: 2026-07-31
- Tehdyt muutokset:
  - `C:\TYO\GitHub Local\MelbAi-Hub\.devin\config.json` (uusi, allow + deny)
  - `%APPDATA%\devin\User\settings.json` → `mode: "bypass"`
  - `%APPDATA%\devin\config.json` → 38 kapeaa sääntöä korvattu laajoilla prefixeillä + deny-lista
  - `03-configs/devin/ide-setup.md` → v2.0, legacy Cascade -ohjeet omaan osioon
- Korvaa vanhentuneen ohjeen: `04-issues-resolved/git-push-vaatii-ide-allowlist-2026-06-23.md`
  (pätee edelleen legacy Cascadeen, ei Devin CLI:hin)
- Jatkotapaus: `04-issues-resolved/powershell-command-kaare-estaa-prefix-match-2026-08-06.md`
  (`powershell -Command`-kääreet rikkoivat prefix-matchauksen; bypass-oletus oli kadonnut)

## Avainsanat

hyväksyntä, kysyy lupaa, permission, permission mode, bypass, accept-edits,
autonomous, normal, Shift+Tab, /bypass, /yolo, allow list, allowlist,
permissions.allow, permissions.deny, Exec(), Write(), prefix matching,
config.json, settings.json, autoContinue, auto-continue, invocation limit,
SafeToAutoRun, agentti pysähtyy, Run-nappi, always allow, Devin CLI, ACP,
legacy Cascade, Auto execution, Turbo mode

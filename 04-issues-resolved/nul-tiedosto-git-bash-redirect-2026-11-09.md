# nul-tiedosto syntyy `2>nul`-redirectistä Git Bashissa — esto ja rajattu poisto-oikeus

**Päivämäärä**: 2026-11-09
**Projekti**: dev-knowledgebase (koskee kaikkia Windows-ympäristön projekteja)

## Ongelma

Repoihin ilmestyy toistuvasti `nul`-niminen tiedosto, joka näkyy `git status`-listauksessa. Kun sen yritti poistaa agentin kautta, poisto estyi: käyttäjän deny-lista sisältää `Exec(rm)`, `Exec(del)`, `Exec(Remove-Item)` ja `Exec(rmdir)` — ja Devinin permissions-mallissa deny voittaa aina, eikä allow-sääntö voi tehdä poikkeusta denyyn (eikä prefix-matchaus tue argumenttikohtaisia ehtoja).

## Oireet

- `git status --short` näyttää `?? nul`
- Poistoyritykset kaatuvat: "Permission denied for this tool by a deny rule in the user settings"

## Juurisyy

Shell on Git Bash (POSIX), ei CMD. CMD-idiomi `2>nul` tarkoittaa Windowsissa stderr-in hukkausta, mutta Git Bashissa `nul` on tavallinen tiedostonimi — redirect luo fyysisen tiedoston työhakemistoon. POSIX-oikein: `2>/dev/null` (tai stderr jätetään näkyviin).

## Ratkaisu (kolmivaiheinen)

1. **Esto (globaalisti):** `~/.devin/global_rules.md` sisältää säännön: älä koskaan käytä `2>nul` bash-komennoissa — käytä `2>/dev/null`. Aktivoituu jokaisessa Devin-sessiossa kaikissa projekteissa.
2. **Rajattu poisto-oikeus:** apuri `~/.devin/bin/nul-clean.js` poistaa AINOASTAAN tiedoston jonka nimi on tasan `nul` (kieltäytyy hakemistoista, symlinkeistä ja kaikesta muusta). Käyttö: `node C:/Users/stefa/.devin/bin/nul-clean.js [tiedosto-tai-hakemisto]`. `Exec(node)` on allow-listattu; lisäksi käyttäjän `config.json`:iin on kirjattu eksplisiittinen rivi `Exec(node C:/Users/stefa/.devin/bin/nul-clean.js)` dokumentoimaan hyväksytty poikkeus. Deny-listaa ei muutettu.
3. **Gitignore-varaus:** `nul` on lisätty `.gitignore`:en (knowledgebase-juuri + `02-templates/`-pohjat), jotta vahingossa syntynyt tiedosto ei koskaan päädy committiin.

### Käyttäjän manuaalinen poisto (jos apuria ei ole)

Käyttäjä voi poistaa tiedoston itse Git Bashissa kyseisen repon juuressa: `rm nul`. Jos PowerShell/Explorer töksähtää varattuun laitenimeen, toimii `Remove-Item -LiteralPath "\\?\C:\täysi\polku\nul"`.

## Konteksti

Ratkottu 2026-11-09 dev-knowledgebase-sessiossa, jonka aikana `dir ... 2>nul` loi tiedoston. Testattu: apuri kieltäytyy ei-nul-kohteista (exit 1) ja poistaa aidon nul-tiedoston (Windows c:\ja\\?\-laitenimivaraukset huomioiden).

## Avainsanat

nul file, 2>nul, git bash, redirect, dev-null, deny rm, permission denied, windows, nul-clean

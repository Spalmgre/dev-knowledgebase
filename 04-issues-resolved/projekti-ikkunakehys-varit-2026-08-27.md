# Projekti-ikkunoiden erottelu title bar -värillä (Devin / VS Code)

**Päivämäärä**: 2026-08-27
**Projekti**: MelbAi-Hub, dev-knowledgebase, Klack-Treeni, Gemini Devin Karuselli

---

## Ongelma

Kun useita Devin-ikkunoita on auki yhtä aikaa, niitä on vaikea erottaa toisistaan — kaikki näyttävät samanlaisilta mustalla teemalla.

## Ratkaisu

Devin on VS Code -pohjainen, joten projektikohtainen `workbench.colorCustomizations` -asetus toimii sellaisenaan. Lisätään jokaisen projektin `.vscode/settings.json`-tiedostoon `titleBar`-värit ja commitoidaan tiedosto gitiin, jolloin väri kulkee repon mukana kaikille koneille ja agenteille.

Malli (esim. tumma sininen):

```json
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "#1F3B57",
    "titleBar.activeForeground": "#E6E6E6",
    "titleBar.inactiveBackground": "#16293C",
    "titleBar.inactiveForeground": "#A0A0A0"
  }
}
```

Käytännön huomiot:

- **TODELLINEN MEKANISMI (ratkaistu 2026-11-01, korjattu/todistettu 2026-11-03):** Devin Desktopin agentti-ikkunat (`workbenchMode: windsurf-agent-window`) ovat sisäisiä workspacceja, joiden asetukset ovat tiedostossa `%APPDATA%\devin\Workspaces\<id>\workspace.json`. **2026-11-03 tarkennus: ikkunan luonti EI kopioi repon `.vscode/settings.json`-värejä lainkaan** — todistettu levyaineistolla: `File / New Agent Window / Open Agent Window` -reitillä luodut snapshotit syntyvät aina ilman `settings`-lohkoa, vaikka väritys ollut repossa pitkään. "Oikeaa avaustapaa" ei siis ole; väri saadaan näkyviin vain tällä menettelyllä:
  1. Avaa agentti-ikkuna millä tavalla tahansa.
  2. Tunnista aktiivinen snapshot: `grep -l "<projektin-nimi>" %APPDATA%/devin/Workspaces/*/workspace.json`, valitse tuorein (uusin id = tuorein ikkuna).
  3. Kirjoita `settings.workbench.colorCustomizations`-lohko kyseisen snapshotin `workspace.json`:iin.
  4. **Lataa ikkuna uudelleen TODENTAMALLA lataus** — pelkkä `Developer: Reload Window` osoittautui epäluotettavaksi (17:12 editoituja värejä ei näkynyt reload-väittämän jälkeen, mutta näkyi myöhemmän aitoutetun latautuksen yhteydessä ilman yhtään tiedostomuutosta sen välissä). Luotettavin keino: sulje agentti-ikkuna ja avaa saman keskustelun uudelleen, tai käynnistä Devin uudestaan.
  - `workspace.json` luetaan vasta ikkunan latautuessa; muutokset eivät heijastu tallennuksesta — toisin kuin normaalissa folder-ikkunassa.
- **Jos projektikansiossa on `.code-workspace`-tiedosto** ja ikkuna avataan tavallisena folder-workspacena sen kautta, window-scopen asetukset luetaan workspace-tiedoston `settings`-lohkosta — `.vscode/settings.json` ohitetaan. Agentti-ikkunoissa tämä EI päde (ne käyttävät Devinin omaa snapshotia), mutta suorilla "Open Folder / Open Workspace" -ikkunoilla kyllä. Siksi värit säilytetään synkassa kolmessa paikassa: `.vscode/settings.json` + `*.code-workspace` + (ajan myötä syntyvä) Devin-snapshot.
- MelbAi-Hubissa `Klack-Treeni.code-workspace` on vahingossa nimetty Klack-Treeniksi (kopio) — tiedostonimi säilytetty, mutta sisäinen `"name"` korjattu MelbAi-Hubiksi 2026-11-01.
- Värjättiin **vain title bar** — ei activity/status baria, jotta musta teema säilyy muuten puhtaana.
- Inactive-sävy on hieman tummempi kuin active (n. 75 % kirkkaudesta), jotta fokusoitu ikkuna erottuu.
- Vaikutus on välitön tiedoston tallennuksesta — ei uudelleenkäynnistystä.
- Tarkista että `.gitignore` ei ohittaa `.vscode/settings.json`:ia. Jos `.vscode/*` on ignoorattu, lisää poikkeus: `!.vscode/settings.json`.

## Nykyinen värijako (tummat sävyt)

| Projekti | Väri | active | inactive |
|----------|------|--------|----------|
| MelbAi-Hub | Keltainen | `#8A6D1A` | `#5F4B13` |
| dev-knowledgebase | Vihreä | `#24432E` | `#1A3221` |
| Klack-Treeni | Oranssi | `#5A3A1E` | `#402A16` |
| Gemini Devin Karuselli | Keltainen | `#5C4D1E` | `#423718` |
| MyBrainSP | Sininen | `#1F3B57` | `#16293C` |

Päivitys 2026-10-31: MelbAi-Hub vaihdettiin sinisestä (`#1F3B57`) keltaiseksi (`#8A6D1A`, kirkkaampi sävy kuin Karusellin `#5C4D1E`, jotta ne erottuvat). MelbAi-Hubin vapautunut sininen siirtyi MyBrainSPlle.

Uudelle projektille: valitse vapaa tumma sävy joka ei ole jo käytössä, ja päivitä tämä taulukko.

## Konteksti

Toteutettu 27.8.2026 kaikkiin neljään aktiiviseen projektiin. MelbAi-Hubissa ja Klack-Treenissä oli aiemmin kirkkaat värit + activity/status bar -värjäys; ne korvattiin tällä hillityllä mallilla.

## Avainsanat

ikkunan väri, title bar, workbench.colorCustomizations, projektin erottelu, .vscode/settings.json, devin ikkuna, window color

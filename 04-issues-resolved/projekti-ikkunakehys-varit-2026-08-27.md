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

- Värjättiin **vain title bar** — ei activity/status baria, jotta musta teema säilyy muuten puhtaana.
- Inactive-sävy on hieman tummempi kuin active (n. 75 % kirkkaudesta), jotta fokusoitu ikkuna erottuu.
- Vaikutus on välitön tiedoston tallennuksesta — ei uudelleenkäynnistystä.
- Tarkista että `.gitignore` ei ohittaa `.vscode/settings.json`:ia. Jos `.vscode/*` on ignoorattu, lisää poikkeus: `!.vscode/settings.json`.

## Nykyinen värijako (tummat sävyt)

| Projekti | Väri | active | inactive |
|----------|------|--------|----------|
| MelbAi-Hub | Sininen | `#1F3B57` | `#16293C` |
| dev-knowledgebase | Vihreä | `#24432E` | `#1A3221` |
| Klack-Treeni | Oranssi | `#5A3A1E` | `#402A16` |
| Gemini Devin Karuselli | Keltainen | `#5C4D1E` | `#423718` |

Uudelle projektille: valitse vapaa tumma sävy joka ei ole jo käytössä, ja päivitä tämä taulukko.

## Konteksti

Toteutettu 27.8.2026 kaikkiin neljään aktiiviseen projektiin. MelbAi-Hubissa ja Klack-Treenissä oli aiemmin kirkkaat värit + activity/status bar -värjäys; ne korvattiin tällä hillityllä mallilla.

## Avainsanat

ikkunan väri, title bar, workbench.colorCustomizations, projektin erottelu, .vscode/settings.json, devin ikkuna, window color

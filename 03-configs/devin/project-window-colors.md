# Projektikohtainen ikkunan kehysväri

Jokaiselle projektille asetetaan oma tunnistettava väri Devin-/VSCode-ikkunan kehykseen. Tämä helpottaa erottamaan useat samanaikaiset projekti-ikkunat toisistaan.

---

## Mikä on kehysväri

Kehysväri värjää ikkunan reunaelementit:
- `titleBar.activeBackground` — aktiivisen ikkunan yläpalkki
- `titleBar.inactiveBackground` — epäaktiivisen ikkunan yläpalkki
- `activityBar.background` — vasemman sivupalkin tausta
- `statusBar.background` — alapalkin tausta

---

## Miten asetetaan

Luo tai muokkaa projektin tiedostoa `.vscode/settings.json` ja lisää:

```json
{
  "workbench.colorCustomizations": {
    "titleBar.activeBackground": "#9B6AFF",
    "titleBar.activeForeground": "#ffffff",
    "titleBar.inactiveBackground": "#7c4dff",
    "titleBar.inactiveForeground": "#e0e0e0",
    "activityBar.background": "#7c4dff",
    "activityBar.foreground": "#ffffff",
    "statusBar.background": "#9B6AFF",
    "statusBar.foreground": "#ffffff"
  }
}
```

Vaihda hex-värit projektin omaksi värjäksi.

---

## Projektikohtaiset värit

| Projekti | Väri | Hex |
|----------|------|-----|
| MelbAi-Hub | Keltainen | `#8A6D1A` |
| dev-knowledgebase | Vihreä | `#24432E` |
| Klack-Treeni | Oranssi | `#5A3A1E` |
| Gemini Devin Karuselli | Keltainen (himmeä) | `#5C4D1E` |
| MyBrainSP | Sininen | `#1F3B57` |
| Uusi projekti | Valitse erottuva väri | — |

---

## Prompt muiden projektien asettamiseen

Käytä tätä promptia agentille:

> "Aseta tämän projektin Devin-ikkunan kehysväri. Käytä värinä `[väri / hex]`. Muokkaa `.vscode/settings.json` ja lisää `workbench.colorCustomizations`. Ota mallia knowledgebase-dokumentista `03-configs/devin/project-window-colors.md`. Varmista että sekä titleBar, activityBar että statusBar saavat värin. Commitoi ja pushaa muutos."

---

## Tarkistuslista

- [ ] `.vscode/settings.json` on olemassa projektin juuressa
- [ ] `workbench.colorCustomizations` sisältää värin
- [ ] Väri on dokumentoitu `05-project-index/[projekti].md` -tiedostoon
- [ ] Muutos on commitoitu ja pushattu

---

**Päivitetty**: 2026-07-13  
**Versio**: 1.0

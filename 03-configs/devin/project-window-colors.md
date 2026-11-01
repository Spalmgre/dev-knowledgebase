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

> **Tärkeä varoitus (.code-workspace):** jos projektissa on `.code-workspace`-tiedosto, sen `settings`-lohko ohittaa `.vscode/settings.json`:n ikkunatason asetukset — väri täytyy lisätä MOLEMPIIN. Projekteissa joilla on workspace-tiedosto: MelbAi-Hub, Klack-Treeni, Klack-SaaS-Chat. Ks. yksityiskohdat: `04-issues-resolved/projekti-ikkunakehys-varit-2026-08-27.md`.

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

**Tärkeä rajoitus (varmistettu 2026-11-01):** title bar -väri on ikkunatason workspace-asetus. Väri NAKYY vain kun (a) tiedosto on projektin omalla levypolulla ja (b) kyseisen projektin OMA ikkuna on ladattu uudelleen. Toinen agentti-ikkuna ei voi pakottaa toisen ikkunan reloadia — prompti täytyy ajaa projektin omassa ikkunassa.

Käytä tätä promptia projektin omassa agentti-ikkunassa:

> "Tarkista ja korjaa tämän projektin title bar -väri knowledgebase-ohjeiden mukaan:
> 1. Raportoi ensin ikkunan työtilajuuri (`pwd` + Explorerin juurikansio). Jos se EI ole `C:\TYO\GitHub Local\<tämä projekti>`, kerro se ja LOPETA — asetuksia ajetaan silloin väärään paikkaan.
> 2. Lue `C:\TYO\GitHub Local\dev-knowledgebase\03-configs\devin\project-window-colors.md` ja `04-issues-resolved\projekti-ikkunakehys-varit-2026-08-27.md` — väri ja aktiivinen/inaktiivinen-sävy taulukosta.
> 3. Varmista että `workbench.colorCustomizations` on TÄYSIN SAMA kaikissa näistä joita projektissa on: `.vscode/settings.json` JA `*.code-workspace`:n `settings`-lohko (.code-workspace ohittaa .vscode:n kokonaan).
> 4. Commitoi ja pushaa oman repon sääntöjen mukaan.
> 5. Lopuksi ohjeista minua ajamaan Command Palette → Developer: Reload Window."

---

## Tarkistuslista

- [ ] `.vscode/settings.json` on olemassa projektin juuressa
- [ ] `workbench.colorCustomizations` sisältää värin
- [ ] Väri on dokumentoitu `05-project-index/[projekti].md` -tiedostoon
- [ ] Muutos on commitoitu ja pushattu

---

**Päivitetty**: 2026-07-13  
**Versio**: 1.0

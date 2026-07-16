# 03-configs - Agent Instructions

Tämä kansio sisältää toimivat määritykset ja asetukset.

## Säännöt

- **Älä muuta näitä tiedostoja** suoraan - lisää uusi versio jos asetus muuttuu
- **Käytä näitä pohjana** kun konfiguroit uuden projektin
- **Päivitä 04-issues-resolved/** jos asetusten muutos johtuu ongelman ratkaisusta

## Kansioiden sisältö

| Kansio | Sisältö |
|--------|---------|
| `supabase/` | OAuth-asetukset, RLS-politiikat, skeemat, MCP-konfiguraatio |
| `vercel/` | Project-asetukset, environment-muuttujat, MCP-konfiguraatio |
| `github/` | Actions workflowt, branch-suojaus |
| `google/` | Google Cloud / Firebase -MCP-palvelinten konfiguraatiot |
| `devin/` | Devin/Cascade-IDE-asetukset jotka eivät kulje gitin mukana |
| `devin/project-window-colors.md` | Projektikohtainen ikkunan kehysväri |

## Yleiset määritykset

| Tiedosto | Sisältö |
|----------|---------|
| `ARCHITECTURE.md` | Yhtenäiset arkkitehtuurimallit kaikille projekteille |
| `UI_UX_STANDARDS.md` | Design system, värit, typografia, komponentit, saavutettavuus |
| `MCP_INTEGRATION.md` | MCP-palvelinten ja Skills-kehityksen yleisohjeet |

## Päivitysprosessi

Kun asetus muuttuu globaalisti:
1. Lisää uusi dokumentti `04-issues-resolved/` kuvaamaan miksi muutos tehtiin
2. Päivitä tämän kansion asianmukainen tiedosto
3. Merkitse päivityspäivämäärä ja versio

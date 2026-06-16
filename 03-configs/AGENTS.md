# 03-configs - Agent Instructions

Tämä kansio sisältää toimivat määritykset ja asetukset.

## Säännöt

- **Älä muuta näitä tiedostoja** suoraan - lisää uusi versio jos asetus muuttuu
- **Käytä näitä pohjana** kun konfiguroit uuden projektin
- **Päivitä 04-issues-resolved/** jos asetusten muutos johtuu ongelman ratkaisusta

## Kansioiden sisältö

| Kansio | Sisältö |
|--------|---------|
| `supabase/` | OAuth-asetukset, RLS-politiikat, skeemat |
| `vercel/` | Project-asetukset, environment-muuttujat |
| `github/` | Actions workflowt, branch-suojaus |

## Päivitysprosessi

Kun asetus muuttuu globaalisti:
1. Lisää uusi dokumentti `04-issues-resolved/` kuvaamaan miksi muutos tehtiin
2. Päivitä tämän kansion asianmukainen tiedosto
3. Merkitse päivityspäivämäärä ja versio

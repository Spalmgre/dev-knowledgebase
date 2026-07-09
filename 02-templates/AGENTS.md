# 02-templates - Agent Instructions

Projektien kopioitavat pohjat.

## Säännöt

- **Kopioi aina koko kansio** uuteen projektiin
- **Päivitä projektikohtaiset nimet** kopioinnin jälkeen
- **Säilytä rakenne** - älä poista tiedostoja

## Noudatettavat knowledgebase-määritykset

Pohjat noudattavat ja viittaavat näihin globaaleihin määrityksiin. Älä kopioi niitä projektiin, vaan lue knowledgebasesta uusin versio:

- `AGENTS.md` (knowledgebase-juuri)
- `01-workflows/SYSTEM_INSTRUCTIONS.md`
- `01-workflows/workflow-rules.md`
- `03-configs/ARCHITECTURE.md`
- `03-configs/UI_UX_STANDARDS.md`
- `03-configs/MCP_INTEGRATION.md`

Jos projekti tarvitsee offline-kopion, kopioi lyhennelmä `docs/knowledgebase/`-kansioon ja viittaa alkuperäiseen tiedostoon.

## Saatavilla olevat pohjat

| Pohja | Käyttötarkoitus | Teknologiat |
|-------|-----------------|-------------|
| `nextjs-supabase/` | Full-stack web-sovellus | Next.js, Supabase, TypeScript |
| `react-vite-supabase/` | Client-only web-sovellus | React, Vite, Supabase |

## Kopioiminen

### Uusi projekti:

```bash
# Windows PowerShell
Copy-Item -Path "C:\TYO\GitHub Local\dev-knowledgebase\02-templates\nextjs-supabase\*" -Destination "C:\TYO\GitHub Local\[uusi-projekti]" -Recurse
```

### Kopioinnin jälkeen:

1. Päivitä `package.json` → name, version, description
2. Päivitä `README.md` → projektin kuvaus
3. Aseta Supabase (`03-configs/supabase/`)
4. Konfiguroi Vercel (`03-configs/vercel/`)

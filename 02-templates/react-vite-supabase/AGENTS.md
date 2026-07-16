# React + Vite + Supabase Template

Tämä pohja sisältää:
- React 18
- Vite (build tool)
- Supabase Auth (OAuth)
- TypeScript
- Perus hakemistorakenne

## Pakollinen alustus (tee aina ennen työn aloittamista)

1. Hae viimeisimmät knowledgebase-päivitykset:
   ```bash
   cd "C:\TYO\GitHub Local\dev-knowledgebase" && git pull origin main
   ```
2. Lue knowledgebase-määritykset:
   - `AGENTS.md`
   - `01-workflows/SYSTEM_INSTRUCTIONS.md`
   - `01-workflows/workflow-rules.md`
   - `03-configs/ARCHITECTURE.md`
   - `03-configs/UI_UX_STANDARDS.md`
   - `03-configs/MCP_INTEGRATION.md`
   - `03-configs/devin/ide-setup.md`
   - `03-configs/devin/project-window-colors.md`
3. Varmista että tämän projektin `AGENTS.md` on yhdenmukainen knowledgebasen kanssa. Jos knowledgebase on päivittynyt, päivitä myös tämä tiedosto.
4. Ennen muokkaamista tallenna `git status --short` -lähtötila. Stagetä ja commitoi vain oman tehtävän nimetyt tiedostot `01-workflows/workflow-rules.md`-ohjeen mukaisesti.
5. Aseta projektikohtainen kehysväri `.vscode/settings.json` -tiedostoon.

## Käyttötarkoitus

Tämä pohja on kevyempi vaihtoehto kun et tarvitse Next.js:n server-toimintoja (SSR, API routes).

## Kopiointi uuteen projektiin

1. Kopioi koko kansio sisältöineen
2. Lue knowledgebase-määritykset: `AGENTS.md`, `01-workflows/SYSTEM_INSTRUCTIONS.md`, `01-workflows/workflow-rules.md`, `03-configs/ARCHITECTURE.md`, `03-configs/UI_UX_STANDARDS.md`, `03-configs/MCP_INTEGRATION.md`
3. Asenna riippuvuudet: `npm install`
4. Konfiguroi Supabase (`03-configs/supabase/`)
5. Lisää env-muuttujat `.env.local`
6. Testaa: `npm run dev`

## Hakemistorakenne

```
src/
├── components/             # React komponentit
├── pages/                  # Sivukomponentit
├── lib/
│   └── supabase.ts         # Supabase client
├── types/                  # TypeScript tyypit
└── main.tsx                # App entry point
```

## Ero Next.js-pohjaan

- **Ei SSR**: Kaikki on client-side renderöityä
- **Ei API routes**: Käytä Supabase Functions tai erillinen backend
- **Keveämpi**: Pienempi bundle size, nopeampi käynnistys

## TODO kopioinnin jälkeen

- [ ] Päivitä package.json (name, description)
- [ ] Päivitä README.md
- [ ] Lisää Supabase URL ja key .env
- [ ] Konfiguroi OAuth providerit
- [ ] Testaa kirjautuminen

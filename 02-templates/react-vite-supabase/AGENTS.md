# React + Vite + Supabase Template

Tämä pohja sisältää:
- React 18
- Vite (build tool)
- Supabase Auth (OAuth)
- TypeScript
- Perus hakemistorakenne

## Käyttötarkoitus

Tämä pohja on kevyempi vaihtoehto kun et tarvitse Next.js:n server-toimintoja (SSR, API routes).

## Kopiointi uuteen projektiin

1. Kopioi koko kansio sisältöineen
2. Asenna riippuvuudet: `npm install`
3. Konfiguroi Supabase (`03-configs/supabase/`)
4. Lisää env-muuttujat `.env.local`
5. Testaa: `npm run dev`

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

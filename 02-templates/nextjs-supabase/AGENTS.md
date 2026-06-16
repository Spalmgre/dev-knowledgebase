# Next.js + Supabase Template

Tämä pohja sisältää:
- Next.js 14 (App Router)
- Supabase Auth (OAuth)
- TypeScript
- Tailwind CSS
- Perus hakemistorakenne

## Kopiointi uuteen projektiin

1. Kopioi koko kansio sisältöineen
2. Asenna riippuvuudet: `npm install`
3. Konfiguroi Supabase (`03-configs/supabase/`)
4. Lisää env-muuttujat `.env.local`
5. Testaa: `npm run dev`

## Hakemistorakenne

```
src/
├── app/                    # Next.js App Router
│   ├── auth/
│   │   └── callback/
│   │       └── route.ts    # OAuth callback handler
│   ├── layout.tsx          # Root layout
│   └── page.tsx            # Home page
├── components/             # React komponentit
├── lib/
│   └── supabase/           # Supabase clientit
│       ├── client.ts       # Browser client
│       └── server.ts       # Server client
└── types/                  # TypeScript tyypit
```

## TODO kopioinnin jälkeen

- [ ] Päivitä package.json (name, description)
- [ ] Päivitä README.md
- [ ] Lisää Supabase URL ja key .env.local
- [ ] Konfiguroi OAuth providerit
- [ ] Testaa kirjautuminen

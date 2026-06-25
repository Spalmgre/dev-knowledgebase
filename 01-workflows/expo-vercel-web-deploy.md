# Expo (react-native-web) → Vercel Web PWA - Workflow

Tämä workflow kuvaa, miten **Expo / React Native** -sovellus julkaistaan **web-PWA:na Vercelillä**.
Tämä on vaihtoehto Next.js-pohjalle silloin, kun sama koodikanta palvelee iOS/Android/Web.

> Lähde / referenssitoteutus: **Klack-Treeni** (Expo SDK 54, react-native-web 0.21).
> Todettu toimivaksi tuotannossa 2026-06.

---

## Milloin tätä käytetään

- Sovellus on **Expo + React Native** ja halutaan sama koodi myös webiin (`react-native-web`).
- Webiä tarjoillaan **staattisena SPA:na** (ei SSR). Vercel hostaa exportatut tiedostot.
- Native-buildit (iOS/Android) tehdään erikseen EAS:llä (`eas.json`), EI tässä workflowissa.

---

## Vaihe 1: Web-export -komennon varmistus

### Toimenpiteet:
1. Expo SDK 50+ exporttaa webin Metrolla: `npx expo export --platform web`
2. Tuloskansio on `dist/` (vanha `expo export:web` tuotti `web-build/` — älä käytä SDK 54:ssä)
3. Lisää `.gitignore`:en:
   ```
   .expo/
   dist/
   web-build/
   expo-env.d.ts
   ```

### Tarkistus:
- [ ] `npx expo export --platform web` tuottaa `dist/`-kansion paikallisesti
- [ ] `dist/` sisältää `index.html`:n ja `_expo/`-bundlet

---

## Vaihe 2: Vercel-projektin build-asetukset

Expo-web ei ole Vercelin valmis framework-preset → asetukset annetaan käsin.

### Toimenpiteet (Vercel Dashboard → Project → Settings → Build & Development):
1. **Framework Preset**: `Other`
2. **Build Command**: `npx expo export --platform web`
3. **Output Directory**: `dist`
4. **Install Command**: `npm install` (oletus)

### Suositus (toistettavuus): kirjaa samat `vercel.json`:iin
```json
{
  "buildCommand": "npx expo export --platform web",
  "outputDirectory": "dist",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### Tarkistus:
- [ ] Build-komento ja output-kansio asetettu (dashboard tai `vercel.json`)
- [ ] Build menee läpi Vercelillä ilman virheitä

---

## Vaihe 3: SPA-reititys (rewrite)

Client-side-reititys (esim. React Navigation) vaatii, että kaikki polut palauttavat `index.html`:n.

### Toimenpiteet:
1. Luo `vercel.json` projektin juureen:
   ```json
   {
     "rewrites": [
       { "source": "/(.*)", "destination": "/index.html" }
     ]
   }
   ```

### Tarkistus:
- [ ] Suora navigointi alasivulle (esim. `/dashboard`) ei anna 404:ää
- [ ] Sivun refresh säilyttää näkymän

---

## Vaihe 4: PWA-asetukset (`app.json` web-lohko)

### Toimenpiteet:
1. Lisää `app.json` → `expo.web`:
   ```json
   "web": {
     "favicon": "./assets/favicon.png",
     "name": "Sovelluksen nimi",
     "shortName": "Lyhyt",
     "display": "standalone",
     "backgroundColor": "#ffffff",
     "themeColor": "#ffaa00",
     "meta": {
       "apple": {
         "mobileWebAppCapable": "yes",
         "mobileWebAppStatusBarStyle": "black-translucent"
       }
     }
   }
   ```
2. (Valinnainen) Mukautettu HTML-pohja `public/index.html` + `public/apple-touch-icon.png`
   - react-native-web vaatii body full-height + `#root` flex -resetin (Expon oletuspohja sisältää tämän)

### Tarkistus:
- [ ] Selaimessa "Lisää aloitusnäyttöön" toimii (iOS/Android)
- [ ] Status bar / teemavärit oikein

---

## Vaihe 5: Supabase-asetukset webissä

HUOM: Expo-RN -projektissa Supabase-client konfiguroidaan KOODISSA, ei `NEXT_PUBLIC_*`-env-muuttujilla.

### Toimenpiteet (`config/supabase.ts`):
1. Aseta `SUPABASE_URL` ja `SUPABASE_ANON_KEY` (anon/publishable key on turvallinen client-puolelle RLS:n kanssa)
2. Käytä `AsyncStorage`-storagea (toimii sekä natiivilla että webissä)
3. **Tärkeä webille**: `detectSessionInUrl: Platform.OS === 'web'` (OAuth/magic-link redirect toimii vain webissä)
   ```ts
   export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
     auth: {
       storage: AsyncStorage,
       autoRefreshToken: true,
       persistSession: true,
       detectSessionInUrl: Platform.OS === 'web',
       lock: processLock,
     },
   })
   ```
4. Natiivilla: `startAutoRefresh`/`stopAutoRefresh` `AppState`-kuuntelijalla (ei webissä)

### Tarkistus:
- [ ] Kirjautuminen + session säilyvät sivun refreshissä webissä
- [ ] RLS on päällä kaikilla tauluilla (anon key paljastuu clientissä)

---

## Vaihe 6: GitHub auto-deploy + (valinnainen) Speed Insights

### Toimenpiteet:
1. Liitä Vercel-projekti GitHub-repoon → push `main`-branchiin triggeröi deployn
2. (Valinnainen) Lisää `@vercel/speed-insights` ja renderöi `<SpeedInsights />` web-puolella

### Tarkistus:
- [ ] `git push origin main` käynnistää automaattisen deploymentin
- [ ] Production-URL päivittyy

**Jos push ei triggeröi deploymentia** → `04-issues-resolved/vercel-github-trigger-2025-06-16.md`

---

## Lopputarkistus

- [ ] `npx expo export --platform web` toimii paikallisesti (`dist/`)
- [ ] Vercel build-komento + output `dist` asetettu
- [ ] SPA-rewrite estää 404:t alasivuilla
- [ ] PWA asennettavissa, teemavärit oikein
- [ ] Supabase-auth toimii webissä (`detectSessionInUrl`)
- [ ] Push triggeröi Vercel deploymentin

---

## Liittyvät kuviot

- **Supabase pysyy hereillä** (ilmaistason pausetuksen esto): `03-configs/supabase/keep-alive-heartbeat.md`
- **Vercel ei deployaa pushista**: `04-issues-resolved/vercel-github-trigger-2025-06-16.md`

---

## Erot Next.js-pohjaan (`new-project-setup.md`)

| Asia | Next.js-pohja | Expo + react-native-web |
|------|---------------|--------------------------|
| Build command | `next build` | `npx expo export --platform web` |
| Output dir | `.next` | `dist` |
| Supabase config | `NEXT_PUBLIC_*` env | kovakoodattu `config/supabase.ts` |
| Reititys | tiedostopohjainen + SSR | client-side SPA + rewrite `index.html` |
| Auth redirect | callback-route | `detectSessionInUrl` (vain web) |

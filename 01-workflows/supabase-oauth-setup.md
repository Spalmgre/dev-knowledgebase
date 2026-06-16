# Supabase OAuth Setup - Workflow

Tämä workflow konfiguroi OAuth-kirjautumisen (GitHub ja Google) Supabaseen.

---

## Yleiskuva

Käyttäjä kirjautuu sovellukseen OAuth-providerin kautta:
1. Käyttäjä click "Sign in with GitHub/Google"
2. Ohjataan providerin kirjautumissivulle
3. Auth onnistuu → ohjataan takaisin sovellukseen
4. Supabase luo käyttäjän ja session

---

## Vaihe 1: GitHub OAuth App

### Toimenpiteet:
1. Mene https://github.com/settings/developers
2. Click "New OAuth App"
3. Täytä tiedot:
   - **Application name**: [Projekti] Auth
   - **Homepage URL**: https://[vercel-domain].vercel.app
   - **Authorization callback URL**: `https://[supabase-project].supabase.co/auth/v1/callback`
4. Click "Register application"
5. Click "Generate a new client secret"
6. **Kopioi**: Client ID ja Client Secret

### Tarkistus:
- [ ] OAuth App näkyy GitHubissa
- [ ] Client ID ja Secret tallessa

---

## Vaihe 2: Google OAuth App

### Toimenpiteet:
1. Mene https://console.cloud.google.com/apis/credentials
2. Luo uusi projekti (tai valitse olemassaoleva)
3. Click "CREATE CREDENTIALS" → "OAuth client ID"
4. Valitse "Web application"
5. Täytä tiedot:
   - **Name**: [Projekti] Auth
   - **Authorized redirect URIs**: `https://[supabase-project].supabase.co/auth/v1/callback`
6. Click "Create"
7. **Kopioi**: Client ID ja Client Secret

### Tarkistus:
- [ ] OAuth 2.0 Client ID luotu
- [ ] Client ID ja Secret tallessa

---

## Vaihe 3: Supabase Provider-asetukset

### Toimenpiteet:
1. Mene https://supabase.com/dashboard → [projekti] → Authentication → Providers
2. **GitHub**:
   - Ota käyttöön: Enabled = true
   - Lisää Client ID
   - Lisää Client Secret
   - Click "Save"
3. **Google**:
   - Ota käyttöön: Enabled = true
   - Lisää Client ID
   - Lisää Client Secret
   - Click "Save"

### Tarkistus:
- [ ] Molemmat providerit näkyvät "Enabled"
- [ ] Client ID:t tallennettu

---

## Vaihe 4: Redirect URL:t

### Toimenpiteet:
1. Authentication → URL Configuration
2. **Site URL**: https://[vercel-domain].vercel.app
3. **Redirect URLs**:
   - Lisää: `https://[vercel-domain].vercel.app/auth/callback`
   - Lisää: `http://localhost:3000/auth/callback` (kehitystä varten)
4. Click "Save"

### Tarkistus:
- [ ] Site URL oikea
- [ ] Redirect URL:t lisätty

---

## Vaihe 5: Koodin implementointi

### Toimenpiteet:
Käytä Supabase Auth kirjastoa:

```typescript
// app/auth/callback/route.ts (Next.js)
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const requestUrl = new URL(request.url)
  const code = requestUrl.searchParams.get('code')

  if (code) {
    const supabase = createRouteHandlerClient({ cookies })
    await supabase.auth.exchangeCodeForSession(code)
  }

  return NextResponse.redirect(requestUrl.origin)
}
```

```typescript
// Login button
import { createClientComponentClient } from '@supabase/auth-helpers-nextjs'

const supabase = createClientComponentClient()

async function signInWithGithub() {
  await supabase.auth.signInWithOAuth({
    provider: 'github',
    options: {
      redirectTo: `${location.origin}/auth/callback`
    }
  })
}
```

### Tarkistus:
- [ ] Callback route luotu
- [ ] Login-nappi toimii ja ohjaa GitHubiin
- [ ] Auth onnistuu ja ohjaa takaisin sovellukseen

---

## Vaihe 6: Testaus

### Toimenpiteet:
1. Käynnistä sovellus: `npm run dev`
2. Avaa http://localhost:3000
3. Click "Sign in with GitHub"
4. Kirjaudu GitHub-tunnuksilla
5. Tarkista Supabase Dashboard → Authentication → Users

### Tarkistus:
- [ ] Uusi käyttäjä näkyy Supabasessa
- [ ] Session toimii (sivun refresh säilyttää kirjautumisen)

---

## Yleiset ongelmat ja ratkaisut

### "redirect_uri_mismatch"
- Tarkista että callback URL on **täsmälleen** oikea Supabasessa ja GitHubissa
- Huomioi http/https ja trailing slash

### "No user found"
- Tarkista että callback-route käsittelee code-parametrin oikein
- Varmista että `exchangeCodeForSession` kutsutaan

### "Provider not enabled"
- Supabase Dashboard → Providers → Enabled = true
- Varmista että client ID ja secret on tallennettu

---

## Lopputarkistus

- [ ] GitHub OAuth toimii
- [ ] Google OAuth toimii (jos konfiguroitu)
- [ ] Käyttäjä tallentuu Supabaseen
- [ ] Session säilyy sivun päivityksellä

**OAuth-kirjautuminen on nyt valmis!**

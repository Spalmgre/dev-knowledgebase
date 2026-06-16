# Supabase OAuth Providers - Config

Toimivat OAuth-asetukset GitHub ja Google kirjautumiselle.

**Päivitetty**: 2025-06-16  
**Versio**: 1.0

---

## GitHub OAuth

### 1. GitHub OAuth App luonti

URL: https://github.com/settings/developers

**Settings:**
- Application name: [Projekti]-Auth
- Homepage URL: https://[vercel-domain].vercel.app
- Authorization callback URL: `https://[supabase-project].supabase.co/auth/v1/callback`
- Enable Device Flow: No

### 2. Supabase Provider-asetukset

**GitHub Provider:**
- Enabled: ✅
- Client ID: [kopioi GitHubista]
- Client Secret: [kopioi GitHubista]
- Redirect URL: https://[vercel-domain].vercel.app/auth/callback

### 3. Testaus

```bash
# Käyttäjä näkee GitHub-kirjautumissivun
curl -I "https://[supabase-project].supabase.co/auth/v1/authorize?provider=github"
# HTTP/1.1 302 Found
# Location: https://github.com/login/oauth/authorize?...
```

---

## Google OAuth

### 1. Google Cloud Console luonti

URL: https://console.cloud.google.com/apis/credentials

**OAuth 2.0 Client ID:**
- Application type: Web application
- Name: [Projekti]-Auth
- Authorized redirect URIs:
  - `https://[supabase-project].supabase.co/auth/v1/callback`

### 2. Supabase Provider-asetukset

**Google Provider:**
- Enabled: ✅
- Client ID: [kopioi Google Cloud Consolesta]
- Client Secret: [kopioi Google Cloud Consolesta]
- Redirect URL: https://[vercel-domain].vercel.app/auth/callback

### 3. Huomioitavaa

- Google vaatii vahvistetun domainin production-käyttöön
- Testikäyttöön lisää testikäyttäjät Google Consoleen
- Consent screen täytyy konfiguroida

---

## Redirect URL:t (tärkeä!)

**Site URL** (Supabase → Authentication → URL Configuration):
```
https://[vercel-domain].vercel.app
```

**Redirect URLs:**
```
https://[vercel-domain].vercel.app/auth/callback
http://localhost:3000/auth/callback  # kehitystä varten
```

---

## Callback Route (Next.js)

```typescript
// app/auth/callback/route.ts
import { createRouteHandlerClient } from '@supabase/auth-helpers-nextjs'
import { cookies } from 'next/headers'
import { NextResponse } from 'next/server'

export async function GET(request: Request) {
  const requestUrl = new URL(request.url)
  const code = requestUrl.searchParams.get('code')

  if (code) {
    const cookieStore = cookies()
    const supabase = createRouteHandlerClient({ cookies: () => cookieStore })
    await supabase.auth.exchangeCodeForSession(code)
  }

  return NextResponse.redirect(requestUrl.origin)
}
```

---

## Ympäristömuuttujat

```env
NEXT_PUBLIC_SUPABASE_URL=https://[project].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-key]
```

---

## Troubleshooting

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| "redirect_uri_mismatch" | Callback URL väärä | Tarkista täsmällinen URL Supabasessa ja GitHubissa |
| "No user found" | Code exchange epäonnistuu | Tarkista callback-route |
| "Provider not enabled" | Provider ei aktiivinen | Supabase Dashboard → Providers → Enabled |
| Session ei säily | Cookie-asetus väärä | Tarkista `createClient` konfiguraatio |

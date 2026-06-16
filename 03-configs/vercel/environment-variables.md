# Environment Variables - Config

Vaaditut ja suositellut ympäristömuuttujat.

**Päivitetty**: 2025-06-16  ️
**Versio**: 1.0

---

## Pakolliset muuttujat

### Supabase

```env
NEXT_PUBLIC_SUPABASE_URL=https://[project-ref].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-public-key]
```

**Mistä saat:**
- Supabase Dashboard → Project Settings → API
- `Project URL` = NEXT_PUBLIC_SUPABASE_URL
- `Project API keys` → `anon public` = NEXT_PUBLIC_SUPABASE_ANON_KEY

### Service Role Key (vain server-side)

```env
SUPABASE_SERVICE_ROLE_KEY=[service-role-key]
```

**Käyttö:**
- Vain server-side koodissa (API routes, Server Components)
- **Älä lisää NEXT_PUBLIC_** - etuliitettä (turvallisuusriski!)
- Käyttö esim. admin-toiminnoissa

---

## Suositellut muuttujat

### Sovelluksen metatiedot

```env
NEXT_PUBLIC_APP_NAME="Sovelluksen Nimi"
NEXT_PUBLIC_APP_URL=https://[domain].vercel.app
```

### Feature flags (valinnainen)

```env
NEXT_PUBLIC_ENABLE_ANALYTICS=true
NEXT_PUBLIC_ENABLE_DEBUG=false
```

### Kolmannen osapuolen palvelut

```env
# Vercel Analytics (lisätään automaattisesti)
VERCEL_ANALYTICS_ID=[auto-generated]

# Resend (sähköpostit)
RESEND_API_KEY=[api-key]
```

---

## Lisääminen Verceliin

### 1. Vercel Dashboard

1. Mene https://vercel.com/dashboard → [projekti] → Settings → Environment Variables
2. Lisää jokainen muuttuja erikseen
3. Valitse ympäristöt (Production, Preview, Development)

### 2. Vercel CLI (vaihtoehto)

```bash
# Kirjaudu sisään
vercel login

# Lisää muuttuja Production-ympäristöön
vercel env add NEXT_PUBLIC_SUPABASE_URL production

# Tai kaikki ympäristöt kerralla
vercel env add NEXT_PUBLIC_SUPABASE_URL
```

---

## Turvallisuusohjeet

### Älä koskaan commitoi:

- ❌ SUPABASE_SERVICE_ROLE_KEY
- ❌ API avaimet (paitsi anonyymi public-key)
- ❌ Salasanat
- ❌ Private keyt

### NEXT_PUBLIC_ -etuliite:

- ✅ NEXT_PUBLIC_ = näkyy client-side (selain)
- ❌ Ilman etuliitettä = server-side only
- **Älä lisää NEXT_PUBLIC_ service role keylle!**

### .env.local:

```bash
# Oikein - ei versionhallintaan
echo ".env.local" >> .gitignore
echo ".env" >> .gitignore
```

---

## Vianmääritys

| Ongelma | Syy | Ratkaisu |
|---------|-----|----------|
| "env variable not found" | Muuttuja puuttuu Vercelistä | Lisää Environment Variables -kohtaan |
| "undefined" client-side | NEXT_PUBLIC_ puuttuu | Lisää NEXT_PUBLIC_ etuliite |
| "key exposed" varoitus | Service key client-side | Poista NEXT_PUBLIC_ service keyltä |
| Arvo ei päivity | Cache | Redeploy ilman cachea |

---

## Tarkistuslista

- [ ] NEXT_PUBLIC_SUPABASE_URL lisätty
- [ ] NEXT_PUBLIC_SUPABASE_ANON_KEY lisätty
- [ ] SUPABASE_SERVICE_ROLE_KEY lisätty (ilman NEXT_PUBLIC_)
- [ ] .env.local .gitignoressa
- [ ] Production-ympäristössä testattu

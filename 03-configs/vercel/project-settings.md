# Vercel Project Settings - Config

Toimivat Vercel-projektiasetukset.

**Päivitetty**: 2025-06-16  
**Versio**: 1.0

---

## Projektin luonti

1. Mene https://vercel.com/dashboard
2. Click "Add New..." → "Project"
3. Import GitHub-repository
4. Valitse oikea repo listasta

---

## Build & Development Settings

**Framework Preset:**
- Next.js (tunnistetaan automaattisesti)

**Build Command:**
```
next build
```

**Output Directory:**
```
.next
```

**Install Command:**
```
npm install
```

**Development Command:**
```
next dev
```

---

## Git Connection

**Connected Git Repository:**
- Owner: [github-username]
- Repository: [repo-name]
- Production Branch: `main`

**Tärkeät asetukset:**
- ✅ Production Branch: `main`
- ✅ Preview Deployments for: All Git branches
- ✅ Auto expose System Environment Variables

---

## Environment Variables

Lisää nämä Production-ympäristöön:

```
NEXT_PUBLIC_SUPABASE_URL=https://[project].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=[anon-key]
```

Lisää myös Preview- ja Development-ympäristöihin jos tarvitaan.

---

## Deployment Protection (valinnainen)

**Password Protection:**
- Voi ottaa käyttöön Previews-deploymenteille
- Estää satunnaiset kävijät näkemästä kehitysversiota

**Vercel Authentication:**
- Vaatii kirjautumisen Verceliin ennen näkemistä
- Hyödyllinen private-projekteille

---

## Build & Output Settings (erikoistapaukset)

**Jos käytät Node.js -versiota:**
```
18.x
```

**Jos käytät Yarn:**
- Install Command: `yarn install`

**Jos käytät pnpm:**
- Install Command: `pnpm install`

---

## Troubleshooting-asetukset

**Jos build epäonnistuu:**
1. Mene Settings → Build & Development Settings
2. Ota käyttöön "Override" ja kokeile:
   ```
   npm ci && next build
   ```

**Jos cache aiheuttaa ongelmia:**
- Redeploy → "Use existing Build Cache": No

---

## Tarkistuslista (uusi projekti)

- [ ] Repo connected oikein
- [ ] Production branch on "main"
- [ ] Framework preset oikein (Next.js)
- [ ] Build command oikein
- [ ] Env-muuttujat lisätty Production
- [ ] Testipush triggeröi deploymentin

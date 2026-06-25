# Vercel + GitHub Troubleshooting - Workflow

Tämä workflow auttaa kun GitHub push ei triggeröi Vercel deploymentia.

---

## Ongelma: Push tehty, mutta Vercelissä ei näy deploymentia

---

## Vaihe 1: Perustarkistukset

### Toimenpiteet:

1. Tarkista GitHub → repository → Settings → Webhooks
2. Etsi webhook jonka nimi on "Vercel"
3. Katso "Recent Deliveries" - näkyykö viimeisin push?

### Tulokset:

- **Näkyy ja status on vihreä** → Ongelma Vercel-puolella, siirry vaiheeseen 3
- **Näkyy ja status on punainen** → Webhook epäonnistuu, siirry vaiheeseen 2
- **Ei näy ollenkaan** → Webhook puuttuu, siirry vaiheeseen 2

---

## Vaihe 2: Webhookin tarkistus / uudelleenluonti

### Toimenpiteet:

1. Mene https://vercel.com/dashboard → [projekti] → Settings → Git
2. Scrollaa "Git Connection" -kohtaan
3. Tarkista "Connected Git Repository" näyttää oikean repon
4. Jos näyttää väärän tai "Not connected":
   - Click "Disconnect"
   - Click "Connect" ja valitse oikea repo

### Tarkistus:

- [ ] Git Connection näyttää oikean GitHub-repon
- [ ] "Production Branch" on "main" (tai oikea branch)

---

## Vaihe 3: Vercel build-asetukset

### Toimenpiteet:

1. Vercel Dashboard → [projekti] → Settings → Build & Development Settings
2. Tarkista:
   - **Framework Preset**: Next.js (tai oikea framework)
   - **Build Command**: `next build` (tai oletus)
   - **Output Directory**: `.next` (tai oletus)

### Tarkistus:

- [ ] Framework oikein
- [ ] Build command määritelty

---

## Vaihe 4: Environment-muuttujat

### Toimenpiteet:

1. Vercel Dashboard → [projekti] → Settings → Environment Variables
2. Tarkista että kaikki tarvittavat muuttujat on lisätty:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
3. Jos puuttuu → lisää ja redeploy

### Tarkistus:

- [ ] Kaikki env-muuttujat lisätty Production-ympäristöön

---

## Vaihe 5: Manuaalinen redeploy

### Toimenpiteet:

1. Vercel Dashboard → [projekti] → Deployments
2. Etsi viimeisin "Failed" tai "Canceled" deployment
3. Click kolme pistettä (...) → "Redeploy"
4. Valitse "Use existing Build Cache": No
5. Click "Redeploy"

### Tarkistus:

- [ ] Deployment käynnistyy
- [ ] Build log näyttää edistymistä

---

## Vaihe 6: Build-logien tarkistus

### Toimenpiteet:

1. Vercel Dashboard → [projekti] → Deployments → [viimeisin]
2. Click "Build Logs"
3. Etsi virheet:
   - "Module not found"
   - "Build failed"
   - "Error: "

### Yleiset virheet ja ratkaisut:

**"Cannot find module"**:

- Riippuvuus puuttuu → `npm install [paketti]` ja commit

**"Build failed" (yleinen)**:

- Tarkista että `next.config.js` on oikein
- Varmista että TypeScript-koodi kääntyy: `npx tsc --noEmit`

**"Environment variable not found"**:

- Lisää puuttuva env Vercelin asetuksiin (katso vaihe 4)

---

## Vaihe 7: GitHub-sovelluksen tarkistus

### Toimenpiteet:

1. Mene https://github.com/settings/installations
2. Etsi "Vercel"
3. Tarkista että sovelluksella on pääsy repositoryyn:
   - Click "Configure"
   - "Repository access" → "All repositories" TAI
   - "Only select repositories" ja varmista että oikea repo on listassa

### Tarkistus:

- [ ] Vercel-sovellus näkyy GitHubissa
- [ ] Oikea repo on sallittu

---

## Vaihe 8: Uudelleenintegraatio (viimeinen keino)

Jos mikään ei toimi, poista ja lisää uudelleen:

### Toimenpiteet:

1. Vercel Dashboard → [projekti] → Settings → Git
2. Click "Disconnect"
3. GitHub → repository → Settings → Webhooks
4. Poista "Vercel" -webhook
5. GitHub → Settings → Applications → Vercel → "Configure" → Poista repo käytöstä
6. Vercel Dashboard → "Add New..." → "Project"
7. Re-import GitHub-repo
8. Aseta environment variables uudelleen

### Tarkistus:

- [ ] Uusi connection luotu
- [ ] Push triggeröi deploymentin

---

## Jos mikään ei toimi

Lue täydellinen ratkaisu: `04-issues-resolved/vercel-github-trigger-2025-06-16.md`

Tämä sisältää:

- Tarkemmat webhook-asetukset
- GitHub Actions vaihtoehdon
- Manuaalinen deployment skripti

---

## Lopputarkistus (kun toimii)

- [ ] Git push triggeröi Vercel deploymentin automaattisesti
- [ ] Deployment näkyy vihreänä Vercel dashboardissa
- [ ] Production URL päivittyy

**Integraatio toimii nyt oikein!**

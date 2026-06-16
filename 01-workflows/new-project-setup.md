# Uuden Projektin Käynnistys - Workflow

Tämä workflow luo uuden projektin pohjasta ja konfiguroi kaikki tarvittavat palvelut.

---

## Vaihe 1: Projektin perustaminen

### Toimenpiteet:
1. Luo uusi kansio: `C:\TYO\GitHub Local\[projekti-nimi]`
2. Kopioi pohja `02-templates/nextjs-supabase/` tähän kansioon
3. Avaa kansio VS Code:ssa uutena ikkunana
4. Luo `README.md` projektin kuvauksella

### Tarkistus:
- [ ] Kansio luotu ja pohja kopioitu
- [ ] VS Code avattu oikeassa kansiossa
- [ ] README.md luotu

---

## Vaihe 2: GitHub-repositorion luonti

### Toimenpiteet:
1. Mene https://github.com/new
2. Anna repository-nimi (sama kuin kansio)
3. Valitse "Private" (tai "Public" jos tarvitaan)
4. Älä lisää README (jo luotu)
5. Luo repository
6. Kopioi komento: `git remote add origin https://github.com/[user]/[repo].git`

### Tarkistus:
- [ ] GitHub-repo luotu
- [ ] Remote lisätty paikalliseen projektiin

---

## Vaihe 3: Git-initialisointi ja ensimmäinen commit

### Toimenpiteet:
```bash
git init
git add .
git commit -m "Initial commit from template"
git branch -M main
git push -u origin main
```

### Tarkistus:
- [ ] `git status` näyttää "nothing to commit"
- [ ] GitHubissa näkyy tiedostot

---

## Vaihe 4: Supabase-projektin luonti

### Toimenpiteet:
1. Mene https://supabase.com/dashboard
2. Luo uusi organisaatio (jos ei ole) tai valitse olemassaoleva
3. Click "New Project"
4. Anna projektille nimi
5. Valitse region (suositus: Frankfurt eu-central-1)
6. Odota että projekti on valmis (n. 1-2 min)

### Tarkistus:
- [ ] Supabase-projekti näkyy dashboardissa
- [ ] Project URL ja API keys saatavilla Settings → API

---

## Vaihe 5: Supabase OAuth-konfiguraatio

### Toimenpiteet:
Lue ja seuraa: `03-configs/supabase/oauth-providers.md`

1. Mene Authentication → Providers
2. Ota käyttöön tarvittavat providerit (GitHub, Google)
3. Lisää callback URL:t
4. Kopioi client ID ja secret jokaiselle

### Tarkistus:
- [ ] Providerit näkyvät "Enabled"
- [ ] Testikirjautuminen toimii (Authentication → Users näyttää uuden käyttäjän)

---

## Vaihe 6: Environment-muuttujat

### Toimenpiteet:
1. Kopioi `.env.example` → `.env.local`
2. Lisää Supabase URL ja anon key:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://[project].supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=[key]
   ```
3. Lisää muut tarvittavat muuttujat

### Tarkistus:
- [ ] `.env.local` .gitignoressa (turvallisuus!)
- [ ] Sovellus käynnistyy ilman virheitä: `npm run dev`

---

## Vaihe 7: Vercel deployment

### Toimenpiteet:
Lue ja seuraa: `03-configs/vercel/project-settings.md`

1. Mene https://vercel.com/dashboard
2. Click "Add New..." → "Project"
3. Import GitHub-repository
4. Valitse framework (Next.js)
5. Lisää environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
6. Deploy

### Tarkistus:
- [ ] Vercel näyttää "Production Deployment" vihreänä
- [ ] URL toimii ja ohjaa oikein

**Jos ei toimi** → lue `04-issues-resolved/vercel-github-trigger.md`

---

## Vaihe 8: GitHub + Vercel integraation tarkistus

### Toimenpiteet:
1. Tee pieni muutos koodiin (esim. päivitä README)
2. Commit ja push: `git add . && git commit -m "Test push" && git push`
3. Tarkista Vercel dashboard → Deployments

### Tarkistus:
- [ ] Push triggeröi automaattisen deploymentin Vercelissä
- [ ] Uusi versio näkyy production URL:ssa

**Jos ei triggeröidy** → lue `01-workflows/vercel-github-troubleshoot.md`

---

## Lopputarkistus

Kaiken pitäisi nyt toimia:
- [ ] Paikallinen kehitys: `npm run dev` toimii
- [ ] Git push triggeröi Vercel deploymentin
- [ ] OAuth-kirjautuminen toimii
- [ ] Production URL toimii

**Onneksi olkoon! Projekti on valmis kehitykseen.**

---

## Seuraavat askeleet

1. Päivitä `05-project-index/[projekti].md` projektin tiedoilla
2. Aloita varsinaisen sovelluslogiikan kehitys
3. Kun ratkaiset ongelman joka voisi toistua → dokumentoi `04-issues-resolved/`

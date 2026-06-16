# Vercel GitHub Trigger - Ratkaistu Ongelma

**Ongelma**: Vercel ei käynnistänyt deploymentia kun push tehtiin GitHubiin  
**Ratkaistu**: 2025-06-16  
**Projekti**: [Edellinen projekti - nimi ei tiedossa]  
**Avainsanat**: vercel, github, deployment, webhook, trigger, push, not deploying, ci/cd

---

## Ongelma

GitHub-repoon push tehty, mutta Vercel dashboardissa ei näkynyt uutta deploymentia. Yhteys GitHubiin näytti toimivan, mutta deployment ei käynnistynyt automaattisesti.

## Oireet

- Git push onnistui GitHubiin
- Vercel Dashboard ei näyttänyt uutta deploymentia
- GitHub → repository → Settings → Webhooks näytti Vercel-webhookin olemassaololla
- Manuaalinen redeploy Vercelistä toimi

## Juurisyy (oletettu)

GitHubin ja Vercelin välinen webhook-integraatio ei toiminut oikein. Mahdollisia syitä:
1. Webhook oli vanhentunut tai vaurioitunut
2. Vercel-sovelluksella ei ollut oikeuksia repositoryyn
3. GitHub-repon asetukset estivät webhookin

## Ratkaisu

### Vaihe 1: Webhookin tarkistus

1. Mene GitHub → [repo] → Settings → Webhooks
2. Katso onko "Vercel" -webhook listassa
3. Jos on → avaa se ja katso "Recent Deliveries"
4. Jos deliveries näyttää punaisia (failed) → siirry vaiheeseen 2
5. Jos webhook puuttuu kokonaan → siirry vaiheeseen 3

### Vaihe 2: Webhookin korjaus (jos deliveries epäonnistuvat)

1. Avaa Vercel-webhook GitHubissa
2. Scrollaa alas → "Recent Deliveries"
3. Jos näkyy failed deliveries:
   - Click failed delivery → "Redeliver"
   - Jos ei toimi → "Delete webhook" ja siirry vaiheeseen 3

### Vaihe 3: Uudelleenintegraatio (lopullinen ratkaisu)

Tämä ratkaisi ongelman projektissa:

#### 3.1 Vercel-puolella:
1. Mene https://vercel.com/dashboard → [projekti] → Settings → Git
2. Click "Disconnect" (poista nykyinen Git-yhteys)
3. Odota hetki

#### 3.2 GitHub-puolella:
1. Mene https://github.com/settings/installations
2. Etsi "Vercel"
3. Click "Configure"
4. "Repository access" -kohdassa:
   - Jos "Only select repositories" → lisää/poista repo listalta ja lisää takaisin
   - Tai vaihda "All repositories" ja takaisin "Only select repositories"
5. Save

#### 3.3 Vercel-puolella uudelleen:
1. Mene https://vercel.com/dashboard → "Add New..." → "Project"
2. Import GitHub-repository (sama repo uudelleen)
3. Vercel tunnistaa olemassa olevan projektin ja tarjoaa "Link to Existing Project"
4. Valitse olemassa oleva projekti
5. Aseta environment variables uudelleen (jos katosivat)
6. Deploy

### Vaihe 4: Testaus

1. Tee pieni muutos koodiin (esim. päivitä README.md)
2. Commit ja push:
   ```bash
   git add .
   git commit -m "Test Vercel trigger"
   git push origin main
   ```
3. Tarkista Vercel Dashboard → Deployments
4. Deploymentin pitäisi ilmestyä automaattisesti (n. 10-30 sek viive)

## Vaihtoehtoinen ratkaisu: GitHub Actions

Jos webhook-integraatio ei toimi ollenkaan, käytä GitHub Actionsia:

1. Luo tiedosto `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Vercel CLI
        run: npm install --global vercel@latest
      
      - name: Deploy to Vercel
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
```

2. Lisää secrets GitHubiin:
   - `VERCEL_TOKEN`: Saat Vercel → Account Settings → Tokens
   - `VERCEL_ORG_ID` ja `VERCEL_PROJECT_ID`: Saat Vercel → Project Settings → General

## Ehkäisy (tulevaisuudessa)

1. **Aina kun luot uuden projektin**, testaa heti:
   ```bash
   echo "Test" >> README.md
   git add . && git commit -m "Test trigger" && git push
   ```
   - Tarkista että Vercel deployment käynnistyy

2. **Älä poista Vercel-asennusta** GitHubista ellei ole pakko

3. **Jos webhook epäonnistuu** toistuvasti → harkitse GitHub Actions -käyttöä

## Lopputulos

Uudelleenintegraatio ratkaisi ongelman. Push triggeröi nyt automaattisesti Vercel deploymentin.

---

**Testattu ja toimii projekteissa:**
- [x] [Projektin nimi jos haluat lisätä]

**Mahdollisia parannuksia:**
- Jos ongelma toistuu, vaihda kokonaan GitHub Actions -käyttöön
- Dokumentoi organisaation Vercel-asetukset tarkemmin

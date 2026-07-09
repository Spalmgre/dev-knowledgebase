# Automation Scripts

Tämä kansio sisältää standardoidut automaatiot skriptit kaikille projekteille. Nämä skriptit varmistavat johdonmukaisen ja luotettavan build- ja deployment-prosessin.

---

## Skriptien kuvaus

### build.sh
Automaattinen build-prosessi, joka sisältää:
- Ympäristön tarkistuksen
- Riippuvuuksien asennuksen
- Tyyppitarkistuksen
- Lintingin
- Testauksen (jos ei ohiteta)
- Build-prosessin
- Build-validoinnin

**Käyttö:**
```bash
# Development build
./scripts/build.sh

# Production build
NODE_ENV=production ./scripts/build.sh

# Skip tests
SKIP_TESTS=true ./scripts/build.sh
```

### deploy.sh
Deployment-prosessi, joka sisältää:
- Ympäristömuuttujien validoinnin
- Pre-deployment tarkistukset
- Deploymentin (production/preview)
- Post-deployment verifioinnin

**Käyttö:**
```bash
# Preview deployment
./scripts/deploy.sh

# Production deployment
NODE_ENV=production ./scripts/deploy.sh
```

**Vaaditut ympäristömuuttujat:**
- `VERCEL_TOKEN` - Vercel API token

### post-build.js
Post-build tehtävät, jotka suoritetaan buildin jälkeen:
- Build-infon luonti
- Metadata tallennus
- Versionhallinta tiedot

**Käyttö:**
```bash
node scripts/post-build.js
```

### setup-webhooks.js
Webhook-konfiguraation asennus:
- GitHub webhookien asennus
- Deployment-notifikaatioiden konfigurointi

**Käyttö:**
```bash
node scripts/setup-webhooks.js
```

**Vaaditut ympäristömuuttujat:**
- `GITHUB_REPOSITORY` - GitHub repository URL
- `VERCEL_PROJECT_ID` - Vercel projektin ID

### backup-deployment.js
Automaattinen backup-prosessi:
- Ympäristömuuttujien backup
- Build-artefaktien backup
- Konfiguraatiotiedostojen backup
- Vanhojen backupien siivous

**Käyttö:**
```bash
node scripts/backup-deployment.js
```

### rollback.sh
Rollback-prosessi aiempaan deploymentiin:
- Konfiguraatiotiedostojen palautus
- Build-artefaktien palautus
- Uudelleen-deployment

**Käyttö:**
```bash
./scripts/rollback.sh /path/to/backup/directory
```

---

## Integrointi package.jsoniin

Lisää seuraavat skriptit package.json-tiedostoosi:

```json
{
  "scripts": {
    "build": "bash scripts/build.sh",
    "deploy": "bash scripts/deploy.sh",
    "deploy:prod": "NODE_ENV=production bash scripts/deploy.sh",
    "postbuild": "node scripts/post-build.js",
    "backup": "node scripts/backup-deployment.js",
    "rollback": "bash scripts/rollback.sh",
    "setup-webhooks": "node scripts/setup-webhooks.js"
  }
}
```

---

## Ympäristömuuttujat

Luo .env.local-tiedosto projektisi juureen:

```bash
# Vercel configuration
VERCEL_TOKEN=your_vercel_token
VERCEL_PROJECT_ID=your_project_id

# GitHub configuration
GITHUB_REPOSITORY=your-username/your-repo

# Build configuration
NODE_ENV=development
SKIP_TESTS=false
```

---

## Käyttöohjeet

### 1. Uuden projektin alustus
```bash
# Asenna riippuvuudet
npm install

# Aseta webhooks
npm run setup-webhooks
```

### 2. Development-työnkulku
```bash
# Build ja testaa
npm run build

# Deploy preview-ympäristöön
npm run deploy
```

### 3. Production-deployment
```bash
# Luo backup ennen deploymentiä
npm run backup

# Deploy productioniin
npm run deploy:prod
```

### 4. Rollback tarvittaessa
```bash
# Listaa backupit
ls -la backups/

# Rollback haluttuun backuppiin
npm run rollback backups/2024-01-15T10-30-00Z
```

---

## Turvallisuus huomiot

1. **Älä koskaan lisää VERCEL_TOKEN** versionhallintaan
2. **Käytä ympäristökohtaisia muuttujia** herkkien tietojen tallentamiseen
3. **Varmista backup-oikeudet** palvelimella
4. **Testaa rollback-prosessi** säännöllisesti

---

## Vianmääritys

### Yleiset ongelmat

**Build epäonnistuu:**
- Tarkista Node.js versio: `node --version` (vaatii v18+)
- Varmista riippuvuudet: `rm -rf node_modules package-lock.json && npm install`
- Tarkista ympäristömuuttujat: `printenv | grep NODE_ENV`

**Deployment epäonnistuu:**
- Varmista VERCEL_TOKEN: `echo $VERCEL_TOKEN`
- Tarkista Vercel-yhteys: `vercel --version`
- Tarkista projektin ID: `vercel projects ls`

**Webhook asennus epäonnistuu:**
- Varmista GitHub-oikeudet
- Tarkista repository URL
- Varmista Vercel-projektin olemassaolo

### Lokit

Build- ja deployment-lokit löytyvät:
- Vercel: `vercel logs`
- Paikalliset buildit: `npm run build 2>&1 | tee build.log`
- Backupit: `backups/` kansio

---

## Tämä automaatiopaketti takaa:

1. **Johdonmukaisuus** - Standardoidut prosessit kaikille projekteille
2. **Luotettavuus** - Automatisoidut tarkistukset ja validoinnit
3. **Vikasietoisuus** - Backupit ja rollback-mahdollisuudet
4. **Tehokkuus** - Optimoidut build- ja deployment-prosessit
5. **Ylläpidettävyys** - Selkeä dokumentaatio ja käyttöohjeet

**Muista:** Päivitä skriptit säännöllisesti ja testaa ne huolellisesti ennen tuotantokäyttöä.

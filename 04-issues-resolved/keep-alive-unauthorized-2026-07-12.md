# Keep-alive endpoint palautti 401 — korjattu

**Ongelma**: Klack-SaaS-Chatin Supabase keep-alive -endpoint (`/api/keep-alive`) palautti `401 Unauthorized`, vaikka workflow lähetti `Authorization: Bearer <secret>` -headerin.  
**Päivämäärä**: 2026-07-12  
**Projekti**: Klack-SaaS-Chat  
**Avainsanat**: heartbeat, keep-alive, Vercel, environment variables, 401, unauthorized

---

## Oireet

- GitHub Actions -workflow `Supabase Keep Alive` epäonnistui `401 Unauthorized` -virheeseen.
- Paikallinen testi `Invoke-RestMethod https://klack-saas-chat.vercel.app/api/keep-alive` palautti saman virheen.
- Endpointin koodi vaati `HEARTBEAT_SECRET`, mutta Vercel production -ympäristössä muuttuja puuttui.

## Juurisyy

`HEARTBEAT_SECRET` oli määritetty ainoastaan paikallisessa `.env`-tiedostossa. Workflow kuitenkin pingasi production-URL:ia, joten secretin täytyy olla Vercelin production environment variables -asetuksissa. Vercel ei lisää uutta env-muuttujaa käyttöön automaattisesti vanhoihin serverless-instansseihin; tarvittiin redeploy.

## Ratkaisu

### 1. Generoi salainen avain

```powershell
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

### 2. Lisää muuttuja Verceliin

Kirjaudu Vercel CLI:llä ja linkitä projekti:

```powershell
vercel login
vercel link --scope stefans-projects-edee8ecd --project klack-saas-chat
```

Lisää secret production-ympäristöön:

```powershell
$secret = '<generoitu-arvo>'
Write-Output $secret | vercel env add HEARTBEAT_SECRET production
```

### 3. Redeploy production

Vercelin env-muutokset tulevat käyttöön uudessa deploymentissa. Redeploy viimeisin onnistunut build:

```powershell
vercel redeploy <deployment-id> --target production
```

### 4. Aseta sama secret GitHub Actions -secrettiin

Workflow tarvitsee secretin GitHubista, jotta curl-kutsu lähettää oikean `Authorization`-headerin:

```powershell
gh auth login
gh secret set HEARTBEAT_SECRET --body '<generoitu-arvo>' --repo Spalmgre/Klack-SaaS-Chat
```

Vaihtoehtoisesti: GitHub → Settings → Secrets and variables → Actions → New repository secret.

### 5. Testaa endpoint

```powershell
Invoke-RestMethod -Uri "https://klack-saas-chat.vercel.app/api/keep-alive" `
  -Method GET `
  -Headers @{"Authorization"="Bearer <generoitu-arvo>"}
```

Odotettu tulos:

```json
{
  "status": "ok",
  "timestamp": "2026-07-12T12:09:24.000Z"
}
```

## Oppimiset

- Vercel env-muuttujat täytyy lisätä erikseen production-, preview- ja development-ympäristöihin.
- Uusi env-muuttuja vaatii redeployn, jotta Next.js / serverless-funktio lataa sen runtimeen.
- GitHub Actions -workflown `secrets.HEARTBEAT_SECRET` ja Vercelin `HEARTBEAT_SECRET` täytyy olla sama arvo.
- Keep-alive secretia ei saa commitoida versionhallintaan; säilytä se salaisuuksien hallinnassa.

## Linkit

- `03-configs/supabase/keep-alive-heartbeat.md`
- `02-templates/github-actions/supabase-keep-alive.yml`
- `05-project-index/Klack-SaaS-Chat.md`

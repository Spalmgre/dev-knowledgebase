# Supabase Keep-Alive Heartbeat (ilmaistason pausetuksen esto)

> **PAKOLLINEN** kaikille Supabase free-tier -projekteille. Lisää heti kun projekti luodaan.

> ⚠️ **Huomio:** Pelkkä `/auth/v1/health` -ping ei riitä. Supabase laskee **todellisen tietokanta-aktiviteetin** (database queries). Käytä endpointtia joka tekee oikean DB-kyselyn.

Supabasen ilmaistaso **pausettaa projektin** ~7 päivän käyttämättömyyden jälkeen.
Tämä kuvio pitää projektin hereillä ajastetulla pingillä GitHub Actionsista.

---

## Vaihtoehto A: Vercel / Next.js endpoint (suositeltu)

Tee Next.js-sovellukseen endpoint joka tekee oikean DB-kyselyn, ja pingaa sitä GitHub Actionsista.

> Referenssitoteutus: **Klack-SaaS-Chat** (`src/app/api/keep-alive/route.ts` + `.github/workflows/supabase-keep-alive.yml`). Todettu toimivaksi 2026-07-06.

### 1. Endpoint (`src/app/api/keep-alive/route.ts`)

```typescript
import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(request: Request) {
  const secret = request.headers.get('authorization')?.replace('Bearer ', '') ?? '';
  if (secret !== process.env.HEARTBEAT_SECRET) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }
  await prisma.$queryRaw`SELECT 1`;
  return NextResponse.json({ status: 'ok', timestamp: new Date().toISOString() });
}
```

### 2. GitHub Action (`.github/workflows/supabase-keep-alive.yml`)

```yaml
name: Supabase Keep Alive

on:
  schedule:
    - cron: '0 6 */3 * *'  # Joka 3. päivä klo 06:00 UTC
  workflow_dispatch:

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping keep-alive endpoint (real DB query)
        run: |
          response=$(curl -s -o /dev/null -w "%{http_code}" \
            "https://<YOUR_VERCEL_DOMAIN>/api/keep-alive" \
            -H "Authorization: Bearer ${{ secrets.HEARTBEAT_SECRET }}")
          echo "Status: $response"
          if [ "$response" != "200" ]; then
            echo "::warning::Keep-alive ping failed with status $response"
            exit 1
          fi
```

### Vaiheet (Vaihtoehto A)

1. Lisää endpoint sovellukseen
2. Lisää `HEARTBEAT_SECRET` Vercelin ympäristömuuttujiin
3. Lisää `HEARTBEAT_SECRET` GitHub Actions Secrets -sivulle
4. Aja manuaalisesti Actions → Run workflow → tarkista vihreä ✅

---

## Vaihtoehto B: Edge Function (kehittyneempi)

Edge Function tekee kevyen DB-kyselyn — parempi kontrolli ja varmennus.

> Referenssitoteutus: **Klack-Treeni** (`.github/workflows/supabase-heartbeat.yml`
> + Supabase Edge Function `heartbeat`). Todettu toimivaksi 2026.

### Osat

1. **Supabase Edge Function** (`supabase/functions/heartbeat/`) joka tekee kevyen DB-kyselyn ja palauttaa 200.
2. **GitHub Action** joka pingaa funktiota ajastetusti (cron) ja epäonnistuu jos status != 200.
3. **GitHub Secrets**: `SUPABASE_ANON_KEY` ja `HEARTBEAT_SECRET`.

---

## GitHub Action (`.github/workflows/supabase-heartbeat.yml`)

```yaml
name: Supabase Heartbeat

on:
  schedule:
    - cron: "*/15 * * * *"   # 15 min välein (säädä tarpeen mukaan)
  workflow_dispatch:          # manuaalinen trigger

jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - name: Ping Supabase Health Endpoint
        env:
          HEARTBEAT_SECRET: ${{ secrets.HEARTBEAT_SECRET }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
        run: |
          set -euo pipefail
          URL="https://<PROJECT_REF>.supabase.co/functions/v1/heartbeat"
          response=$(curl --silent --show-error \
            -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
            -H "x-heartbeat-secret: ${HEARTBEAT_SECRET}" \
            -w "\n%{http_code}" \
            "$URL")
          http_code=$(echo "$response" | tail -n1)
          echo "HTTP Status: $http_code"
          if [ "$http_code" -ne 200 ]; then
            echo "❌ Health check failed!"; exit 1
          fi
          echo "✅ Health check succeeded"
```

---

## Vaiheet

### Vaihe 1: Edge Function
1. Luo `supabase/functions/heartbeat/index.ts` joka:
   - tarkistaa `x-heartbeat-secret` -headerin (estää väärinkäytön)
   - tekee kevyen kyselyn (esim. `select 1` tai `count` pienestä taulusta)
   - palauttaa `200 OK`
2. Deploy: `supabase functions deploy heartbeat`

### Vaihe 2: GitHub Secrets
1. Repo → Settings → Secrets and variables → Actions → New repository secret
2. Lisää `SUPABASE_ANON_KEY` (Supabase → Settings → API)
3. Lisää `HEARTBEAT_SECRET` (oma satunnainen merkkijono; sama arvo funktiossa)

### Vaihe 3: Workflow
1. Lisää yllä oleva yml `.github/workflows/`-kansioon, korvaa `<PROJECT_REF>`
2. Aja kerran manuaalisesti (Actions → Run workflow) ja varmista vihreä status

---

## Tarkistus

- [ ] `workflow_dispatch` -ajo palauttaa 200 ja onnistuu
- [ ] Cron-ajot näkyvät Actions-historiassa
- [ ] Supabase-projekti ei enää pausetu

---

## Huomioitavaa

- **Älä** pingaa liian usein turhaan; 15 min on reilusti riittävä (jopa kerran/pvä riittäisi pausetuksen estoon).
- `HEARTBEAT_SECRET` estää sen, että kuka tahansa voi kutsua funktiota anon-keyllä.
- Vaihtoehto Edge Functionille: suora REST-ping johonkin julkiseen RLS-suojattuun endpointtiin — mutta oma funktio on siistein ja kontrolloitu.

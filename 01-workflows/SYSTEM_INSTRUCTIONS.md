# System Instructions - Cross-Project Agent Guidelines

Tämä dokumentti määrittelee keskitetyt ohjeet kaikille agenteille, jotka työskentelevät missä tahansa valvotussa projektissa. Nämä säännöt ovat pakollisia ja ohittavat kaikki projektikohtaiset vastakkaiset ohjeet.

---

# Välttämättömät Toimenpiteet Ennen Työn Aloittamista

## 1. Knowledgebase-Synkronointi (Pakollinen)

**Jokaisen agentin on suoritettava nämä vaiheet ennen mitään muuta toimenpidettä:**

```bash
# Vaihda knowledgebase-kansioon
cd "C:\TYO\GitHub Local\dev-knowledgebase"

# Päivitä viimeisimmät muutokset
git pull origin main

# Lue uusimmat ohjeet
cat AGENTS.md
cat 01-workflows/SYSTEM_INSTRUCTIONS.md
cat 03-configs/ARCHITECTURE.md
```

## 2. Projektikohtainen Alustus

```bash
# Palaa projektiin
cd [PROJEKTIN_POLKU]

# Tarkista onko projektikohtaisia AGENTS.md-sääntöjä
ls -la | findstr AGENTS.md

# Jos löytyy, lue se ensin
type AGENTS.md
```

---

# Agentin Työnkulku

## Kun Aloitat Uutta Ominaisuutta

1. **Tarkista knowledgebase ensin:**
   ```bash
   cd "C:\TYO\GitHub Local\dev-knowledgebase"
   grep -r "avainsana" 04-issues-resolved/
   grep -r "avainsana" 01-workflows/
   ```

2. **Jos ratkaisu löytyy:** Sovella suoraan
3. **Jos ei löydy:** Ratkaise ongelma normaalisti

## Kun Ratkaiset Ongelman

**Välittömä ratkaisun jälkeen:**

1. **Kysy käyttäjältä:** "Tallennetaanko tämä ratkaisu knowledgebaseen jatkoa varten?"
2. **Jos kyllä:**
   - Luo dokumentti `04-issues-resolved/[kuvaava-nimi]-[YYYY-MM-DD].md`
   - Päivitä relevantit konfiguraatiot `03-configs/` kansioon
   - Commitoi knowledgebase-muutokset automaattisesti

## Kun Teet Konfiguraatiomuutoksia

**Ennen muutosta:**
- Tarkista `03-configs/` vastaavat pohjat
- Käytä standardoituja malleja

**Muutoksen jälkeen:**
- Päivitä knowledgebase-pohjat
- Dokumentoi uusi käytäntö

---

# Tekniset Standardit

## Package Management

### npm/npx -käytännöt

```json
{
  "package.json": {
    "scripts": {
      "dev": "next dev",
      "build": "next build",
      "start": "next start",
      "lint": "next lint",
      "type-check": "tsc --noEmit"
    }
  }
}
```

**Säännöt:**
- Käytä aina `npm install` ei `npm ci` kehityksessä
- Lisää uudet paketit `package.json` -versiolla
- Tarkista aina `npm audit` ennen commit

### TypeScript-Konfiguraatio

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

## Koodityylit

### Nimeämiskäytännöt

- **Komponentit:** PascalCase (`UserProfile.tsx`)
- **Funktiot:** camelCase (`getUserData`)
- **Konstantit:** UPPER_SNAKE_CASE (`API_BASE_URL`)
- **Tiedostot:** kebab-case (`user-profile.component.tsx`)

### Import-järjestys

```typescript
// 1. React & Next.js
import React from 'react';
import { useRouter } from 'next/router';

// 2. Third-party libraries
import { z } from 'zod';
import { createClient } from '@supabase/supabase-js';

// 3. Internal modules
import { Button } from '@/components/ui/button';
import { useAuth } from '@/hooks/use-auth';
```

---

# Palveluintegraatiot

## Supabase (vain jos projekti käyttää Supabasea)

> Jos projekti käyttää muuta tietokantaa tai backendpalvelua (Firebase, PlanetScale, MongoDB, jne.), **ohita tämä osio kokonaan**. Älä asenna `@supabase/supabase-js` jos Supabasea ei käytetä.

### Perusasetukset

```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
```

### RLS (Row Level Security) -standardit

```sql
-- Kaikissa tauluissa on oltava RLS päällä
ALTER TABLE "Profile" ENABLE ROW LEVEL SECURITY;

-- Oma data -policy
CREATE POLICY "Users can view own profile" ON "Profile"
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON "Profile"
  FOR UPDATE USING (auth.uid() = id);
```

## Vercel (vain jos projekti käyttää Verceliä)

> Jos projekti käyttää muuta hosting-alustaa (Firebase Hosting, Railway, Fly.io, Render, jne.), **ohita tämä osio kokonaan**. Älä asenna tai konfiguroi Vercel-integrointia jos Verceliä ei ole projektin teknologioissa.

### Environment Variables

```bash
# Pakolliset vain Vercel-projekteissa
NEXT_PUBLIC_APP_URL=https://your-domain.vercel.app
NODE_ENV=production
```

### Build-komennon standardointi

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "installCommand": "npm install"
}
```

---

# Virheenjäljitys ja Logging

## Virheenkäsittely

```typescript
// Standardoitu virheenkäsittely
class AppError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode: number = 500
  ) {
    super(message);
    this.name = 'AppError';
  }
}

// Käyttö
try {
  const result = await riskyOperation();
} catch (error) {
  if (error instanceof AppError) {
    console.error(`[${error.code}] ${error.message}`);
  }
  throw error;
}
```

## Logging-standardit

```typescript
// Käytä aina structured logging
console.log(JSON.stringify({
  event: 'user_action',
  action: 'login',
  userId: user.id,
  timestamp: new Date().toISOString(),
  metadata: { source: 'web' }
}));
```

---

# Turvallisuus

### API Keys & Secrets

```typescript
// Älä koskaan paljasta client-salaisuuksia
const config = {
  public: {
    supabaseUrl: process.env.NEXT_PUBLIC_SUPABASE_URL,
    supabaseAnonKey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
  },
  private: {
    supabaseServiceKey: process.env.SUPABASE_SERVICE_ROLE_KEY
  }
};
```

### Input Validation

```typescript
import { z } from 'zod';

const UserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2).max(50)
});

// Käytä aina validointia
const validatedUser = UserSchema.parse(userData);
```

---

# Testaus

### Unit Tests

```typescript
// Käytä Jest + React Testing Library
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

test('renders button with text', () => {
  render(<Button>Click me</Button>);
  expect(screen.getByText('Click me')).toBeInTheDocument();
});
```

### Integration Tests

```typescript
// Supabase-integraatiotestit
import { supabase } from '@/lib/supabase';

test('can create and read user profile', async () => {
  const profile = await createTestProfile();
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', profile.id)
    .single();
  
  expect(error).toBeNull();
  expect(data).toMatchObject(profile);
});
```

---

# Suorituskyky

### React Optimization

```typescript
// Käytä memo ja useCallback optimointiin
const ExpensiveComponent = React.memo(({ data }) => {
  return <div>{/* expensive rendering */}</div>;
});

const ParentComponent = () => {
  const handleClick = useCallback(() => {
    // handler logic
  }, []);
  
  return <ExpensiveComponent data={data} onClick={handleClick} />;
};
```

### Database Optimization

```sql
-- Lisää indeksit usein querytuihin kenttiin
CREATE INDEX "profiles_user_id_idx" ON "profiles"("user_id");
CREATE INDEX "messages_created_at_idx" ON "messages"("created_at" DESC);
```

---

# Deployment

### Pre-deploy Checklist

1. **Build test:**
   ```bash
   npm run build
   npm run type-check
   npm run lint
   ```

2. **Environment check (käytä vain jos alla oleva palvelu on käytössä):**
   ```bash
   # Vercel-projekteille
   vercel env ls

   # Firebase-projekteille
   firebase apps:list
   ```

3. **Database migration (vain jos Supabase käytössä):**
   ```bash
   supabase db push
   ```

### Post-deploy Verification

1. **Tarkista build lokit**
2. **Testaa kriittiset toiminnot**
3. **Varmista database-yhteys (vain jos tietokanta käytössä)**
4. **Validoi environment variables**

---

# Tiedonhallinta

## Kun Löydät Uuden Parhaan Käytännön

1. **Dokumentoi välittömästi:**
   - Luo uusi tiedosto `04-issues-resolved/`
   - Päivitä relevantit workflowt
   - Lisää `AGENTS.md` viittaukset

2. **Levitä muihin projekteihin:**
   - Tarkista vastaavat konfiguraatiot muissa projekteissa
   - Päivitä tarvittaessa
   - Dokumentoi muutokset

## Kun Projekti Muuttuu

1. **Päivitä project index:**
   - Muokkaa `05-project-index/[project].md`
   - Lisää uudet riippuvuudet
   - Päivitä status

2. **Synkronoi knowledgebase:**
   - Commitoi muutokset
   - Pushaa GitHubiin
   - Ilmoita muista agenteista

---

# Kriittiset Säännöt (ÄLÄ KOSKAAN RIKOI)

1. **Älä koskaan commitoi salaisuuksia** (API keys, passwords)
2. **Aina tarkista knowledgebase ensin** ennen uuden ratkaisun luomista
3. **Päivitä knowledgebase välittömästi** kun löydät uuden ratkaisun
4. **Käytä aina standardoituja konfiguraatioita** `03-configs/` kansiosta
5. **Testaa build ennen jokaista commit**
6. **Dokumentoi kaikki poikkeukset** standardikäytännöistä
7. **Älä pyydä käyttäjää hakemaan tietoja manuaalisesti jos MCP tai muu työkalu voi hakea ne** — esim. Supabase anon key MCP:llä, Vercel project ID API:lla. Pyydä käyttäjää vain jos automaattinen haku epäonnistuu.
8. **Käytä Devin-nimeä, ei Windsurf** kaikessa dokumentaatiossa ja viestinnässä.

---

# Häiriötilanteet

## Jos Knowledgebase ei ole Ajan Tasalla

1. **Päivitä ensin knowledgebase:**
   ```bash
   cd "C:\TYO\GitHub Local\dev-knowledgebase"
   git pull origin main
   ```

2. **Jos konflikti:**
   - Ratkaise manuaalisesti
   - Kysy käyttäjältä ohjeita
   - Älä jatka ennen kuin knowledgebase on ajantasalla

## Jos Projektikohtaiset Säännöt Ristiriidassa

1. **Knowledgebase-säännöt voittavat aina**
2. **Päivitä projektikohtaiset säännöt**
3. **Dokumentoi muutos

---

# Yhteystiedot ja Tuki

**Jos kohtaat ongelman jota et ratkaise:**
1. Tarkista `04-issues-resolved/` ensin
2. Luo uusi issue-dokumentti
3. Pyydä käyttäjältä apua

**Muista:** Tämä knowledgebase on elävä dokumentti. Pidä sitä ajan tasalla ja kaikki projektit toimivat saumattomasti yhdessä.

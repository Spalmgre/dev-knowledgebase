# Vercel Deployment Patterns - Standardized Configuration

Tämä dokumentti sisältää standardoidut Vercel-deploymenet konfiguraatiot ja parhaat käytännöt kaikille projekteille. Nämä mallit varmistavat johdonmukaisen, nopean ja luotettavan deployment-prosessin.

---

# Perusarkkitehtuuri

## Vercel-konfiguraation rakenne

```
project-root/
├── vercel.json              # Pääkonfiguraatiotiedosto
├── .vercelignore           # Ignoroitavat tiedostot
├── public/                 # Staattiset assets
│   ├── _redirects          # URL-uudelleenohjaukset
│   └── _headers            # HTTP-otsakkeet
├── api/                    # Serverless functions
│   └── (functions)/
├── scripts/                # Build-skriptit
│   ├── build.sh
│   ├── deploy.sh
│   └── post-deploy.sh
└── .env.example            # Environment-muuttujien malli
```

---

# Standardoitu vercel.json

## Peruskonfiguraatio

```json
{
  "version": 2,
  "name": "{{project-name}}",
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "installCommand": "npm install",
  "framework": "nextjs",
  "regions": ["hnd1"],
  "functions": {
    "app/api/**/*.ts": {
      "maxDuration": 30,
      "memory": 1024
    },
    "pages/api/**/*.ts": {
      "maxDuration": 30,
      "memory": 1024
    }
  },
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "s-maxage=86400"
        }
      ]
    },
    {
      "source": "/_next/static/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ],
  "redirects": [
    {
      "source": "/home",
      "destination": "/",
      "permanent": true
    },
    {
      "source": "/dashboard",
      "destination": "/app/dashboard",
      "permanent": true
    }
  ],
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "/api/:path*"
    }
  ]
}
```

## Ympäristökohtainen konfiguraatio

```json
{
  "version": 2,
  "env": {
    "DEVELOPMENT": {
      "buildCommand": "npm run build:dev",
      "outputDirectory": ".next",
      "installCommand": "npm install",
      "framework": "nextjs"
    },
    "PRODUCTION": {
      "buildCommand": "npm run build:prod",
      "outputDirectory": ".next",
      "installCommand": "npm ci",
      "framework": "nextjs",
      "functions": {
        "app/api/**/*.ts": {
          "maxDuration": 60,
          "memory": 2048
        }
      }
    },
    "PREVIEW": {
      "buildCommand": "npm run build:preview",
      "outputDirectory": ".next",
      "installCommand": "npm ci",
      "framework": "nextjs"
    }
  }
}
```

---

# Environment Variables

## Standardoidut ympäristömuuttujat

```bash
# .env.production
# Core application
NEXT_PUBLIC_APP_URL=https://your-domain.vercel.app
NEXT_PUBLIC_API_URL=https://your-domain.vercel.app/api
NODE_ENV=production

# Supabase configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Authentication
NEXTAUTH_URL=https://your-domain.vercel.app
NEXTAUTH_SECRET=your_nextauth_secret

# Analytics and monitoring
NEXT_PUBLIC_ANALYTICS_ID=your_analytics_id
SENTRY_DSN=your_sentry_dsn
VERCEL_ANALYTICS_ID=your_vercel_analytics_id

# External services
RESEND_API_KEY=your_resend_api_key
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret

# Development overrides
NEXT_PUBLIC_DEV_MODE=false
NEXT_PUBLIC_DEBUG=false
```

```bash
# .env.development
NEXT_PUBLIC_APP_URL=http://localhost:3000
NEXT_PUBLIC_API_URL=http://localhost:3000/api
NODE_ENV=development

# Supabase development
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_dev_anon_key

# Development features
NEXT_PUBLIC_DEV_MODE=true
NEXT_PUBLIC_DEBUG=true
```

---

# Build-skriptit

## Standardoitu package.json

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "build:dev": "NODE_ENV=development next build",
    "build:prod": "NODE_ENV=production next build",
    "build:preview": "NODE_ENV=production next build",
    "start": "next start",
    "lint": "next lint",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "prepare": "husky install",
    "prebuild": "npm run lint && npm run type-check",
    "postbuild": "node scripts/post-build.js",
    "deploy:prod": "vercel --prod",
    "deploy:preview": "vercel",
    "logs:prod": "vercel logs --prod",
    "logs:preview": "vercel logs"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "^14.0.0",
    "husky": "^8.0.0",
    "jest": "^29.0.0",
    "lint-staged": "^13.0.0",
    "prettier": "^3.0.0",
    "typescript": "^5.0.0"
  }
}
```

## Build-skriptit

```bash
#!/bin/bash
# scripts/build.sh

set -e

echo "🚀 Starting build process..."

# Environment check
if [ "$NODE_ENV" = "production" ]; then
  echo "📦 Production build"
  npm ci --only=production
else
  echo "🔧 Development build"
  npm install
fi

# Type checking
echo "🔍 Running type check..."
npm run type-check

# Linting
echo "🧹 Running linter..."
npm run lint

# Testing
if [ "$SKIP_TESTS" != "true" ]; then
  echo "🧪 Running tests..."
  npm run test
fi

# Build
echo "🏗️ Building application..."
npm run build

# Post-build validation
echo "✅ Validating build..."
if [ ! -d ".next" ]; then
  echo "❌ Build failed: .next directory not found"
  exit 1
fi

echo "✅ Build completed successfully!"
```

```bash
#!/bin/bash
# scripts/deploy.sh

set -e

echo "🚀 Starting deployment..."

# Environment validation
if [ -z "$VERCEL_TOKEN" ]; then
  echo "❌ VERCEL_TOKEN environment variable is required"
  exit 1
fi

# Pre-deployment checks
echo "🔍 Running pre-deployment checks..."
npm run prebuild

# Deploy based on environment
if [ "$NODE_ENV" = "production" ]; then
  echo "🌐 Deploying to production..."
  vercel --prod --token="$VERCEL_TOKEN"
else
  echo "👀 Deploying to preview..."
  vercel --token="$VERCEL_TOKEN"
fi

# Post-deployment verification
echo "✅ Running post-deployment verification..."
npm run post-deploy

echo "🎉 Deployment completed successfully!"
```

```javascript
// scripts/post-build.js
const fs = require('fs');
const path = require('path');

console.log('🔧 Running post-build tasks...');

// Create build info
const buildInfo = {
  buildTime: new Date().toISOString(),
  version: process.env.npm_package_version,
  environment: process.env.NODE_ENV,
  commit: process.env.VERCEL_GIT_COMMIT_SHA || 'local',
  branch: process.env.VERCEL_GIT_COMMIT_REF || 'main',
};

// Write build info to public directory
fs.writeFileSync(
  path.join(process.cwd(), 'public', 'build-info.json'),
  JSON.stringify(buildInfo, null, 2)
);

console.log('✅ Post-build tasks completed');
```

---

# Advanced Configuration

## Monorepo-tuki

```json
{
  "version": 2,
  "buildCommand": "npm run build:workspace",
  "outputDirectory": "apps/web/.next",
  "installCommand": "npm install",
  "framework": "nextjs",
  "workspace": "apps/web",
  "functions": {
    "apps/web/app/api/**/*.ts": {
      "maxDuration": 30,
      "memory": 1024
    }
  }
}
```

## Edge Functions

```json
{
  "functions": {
    "app/api/edge/**/*.ts": {
      "runtime": "edge",
      "maxDuration": 30
    }
  },
  "routes": [
    {
      "src": "/api/edge/(.*)",
      "dest": "/api/edge/$1"
    }
  ]
}
```

## Image Optimization

```json
{
  "images": {
    "domains": [
      "images.unsplash.com",
      "avatars.githubusercontent.com",
      "cdn.example.com"
    ],
    "formats": ["image/webp", "image/avif"],
    "minimumCacheTTL": 86400,
    "deviceSizes": [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
    "imageSizes": [16, 32, 48, 64, 96, 128, 256, 384]
  }
}
```

---

# CI/CD Integration

## GitHub Actions Workflow

```yaml
# .github/workflows/vercel-deploy.yml
name: Deploy to Vercel

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm run test:coverage
        
      - name: Run linting
        run: npm run lint
        
      - name: Type check
        run: npm run type-check
        
      - name: Build application
        run: npm run build
        
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
          
      - name: Run post-deploy tests
        run: npm run test:e2e
```

## Vercel Webhook Configuration

```javascript
// scripts/setup-webhooks.js
const { execSync } = require('child_process');

async function setupWebhooks() {
  const repoUrl = process.env.GITHUB_REPOSITORY;
  const projectId = process.env.VERCEL_PROJECT_ID;
  
  try {
    // Setup GitHub webhook
    execSync(`vercel projects link ${repoUrl}`, { stdio: 'inherit' });
    
    // Setup deployment notifications
    execSync(`vercel env add SLACK_WEBHOOK_URL`, { stdio: 'inherit' });
    
    console.log('✅ Webhooks configured successfully');
  } catch (error) {
    console.error('❌ Failed to setup webhooks:', error.message);
    process.exit(1);
  }
}

setupWebhooks();
```

---

# Monitoring and Analytics

## Vercel Analytics Integration

```typescript
// src/lib/analytics.ts
import { Analytics } from '@vercel/analytics/react';
import { SpeedInsights } from '@vercel/speed-insights/react';

export function VercelAnalytics() {
  return (
    <>
      <Analytics />
      <SpeedInsights />
    </>
  );
}

// Custom analytics events
export function trackEvent(eventName: string, properties?: Record<string, any>) {
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', eventName, properties);
  }
}

// Performance tracking
export function trackPerformance(metricName: string, value: number) {
  trackEvent('performance', {
    metric_name: metricName,
    value: value,
    timestamp: Date.now(),
  });
}
```

## Error Tracking

```typescript
// src/lib/error-tracking.ts
import * as Sentry from '@sentry/nextjs';

export function initErrorTracking() {
  if (process.env.NODE_ENV === 'production') {
    Sentry.init({
      dsn: process.env.SENTRY_DSN,
      environment: process.env.NODE_ENV,
      tracesSampleRate: 0.1,
      debug: false,
    });
  }
}

export function captureError(error: Error, context?: Record<string, any>) {
  if (process.env.NODE_ENV === 'production') {
    Sentry.captureException(error, {
      contexts: { custom: context },
    });
  } else {
    console.error('Error captured:', error, context);
  }
}
```

## Performance Monitoring

```typescript
// src/lib/performance-monitor.ts
export class PerformanceMonitor {
  private static metrics: Map<string, number[]> = new Map();

  static startTimer(name: string): () => void {
    const startTime = performance.now();
    
    return () => {
      const endTime = performance.now();
      const duration = endTime - startTime;
      
      if (!this.metrics.has(name)) {
        this.metrics.set(name, []);
      }
      
      this.metrics.get(name)!.push(duration);
      
      // Report to Vercel Analytics
      if (typeof window !== 'undefined' && window.gtag) {
        window.gtag('event', 'performance_metric', {
          metric_name: name,
          value: duration,
        });
      }
    };
  }

  static getMetrics(): Record<string, { avg: number; min: number; max: number }> {
    const result: Record<string, { avg: number; min: number; max: number }> = {};
    
    for (const [name, values] of this.metrics.entries()) {
      const avg = values.reduce((a, b) => a + b, 0) / values.length;
      const min = Math.min(...values);
      const max = Math.max(...values);
      
      result[name] = { avg, min, max };
    }
    
    return result;
  }

  static reset(): void {
    this.metrics.clear();
  }
}

// Usage example
export function withPerformanceTracking<T>(
  name: string,
  fn: () => T | Promise<T>
): T | Promise<T> {
  const endTimer = PerformanceMonitor.startTimer(name);
  
  try {
    const result = fn();
    
    if (result instanceof Promise) {
      return result.finally(endTimer);
    }
    
    endTimer();
    return result;
  } catch (error) {
    endTimer();
    throw error;
  }
}
```

---

# Security Configuration

## Security Headers

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Content-Security-Policy",
          "value": "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https:; frame-ancestors 'none';"
        },
        {
          "key": "Strict-Transport-Security",
          "value": "max-age=31536000; includeSubDomains"
        },
        {
          "key": "Permissions-Policy",
          "value": "camera=(), microphone=(), geolocation=(), payment=()"
        }
      ]
    }
  ]
}
```

## Rate Limiting

```typescript
// src/lib/rate-limit.ts
import { NextRequest, NextResponse } from 'next/server';

interface RateLimitStore {
  [key: string]: {
    count: number;
    resetTime: number;
  };
}

const store: RateLimitStore = {};

export function rateLimit(
  request: NextRequest,
  limit: number = 100,
  windowMs: number = 60 * 1000
): { success: boolean; limit: number; remaining: number; resetTime: number } {
  const clientId = request.ip || 'unknown';
  const now = Date.now();
  
  // Clean up expired entries
  for (const key in store) {
    if (store[key].resetTime < now) {
      delete store[key];
    }
  }
  
  // Initialize or update client entry
  if (!store[clientId] || store[clientId].resetTime < now) {
    store[clientId] = {
      count: 1,
      resetTime: now + windowMs,
    };
  } else {
    store[clientId].count++;
  }
  
  const clientData = store[clientId];
  const success = clientData.count <= limit;
  const remaining = Math.max(0, limit - clientData.count);
  
  return {
    success,
    limit,
    remaining,
    resetTime: clientData.resetTime,
  };
}

export function createRateLimitResponse(rateLimitResult: ReturnType<typeof rateLimit>) {
  return new NextResponse(
    JSON.stringify({ error: 'Rate limit exceeded' }),
    {
      status: 429,
      headers: {
        'X-RateLimit-Limit': rateLimitResult.limit.toString(),
        'X-RateLimit-Remaining': rateLimitResult.remaining.toString(),
        'X-RateLimit-Reset': rateLimitResult.resetTime.toString(),
        'Retry-After': Math.ceil((rateLimitResult.resetTime - Date.now()) / 1000).toString(),
      },
    }
  );
}
```

---

# Backup and Recovery

## Automated Backups

```javascript
// scripts/backup-deployment.js
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

async function createDeploymentBackup() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupDir = path.join(process.cwd(), 'backups', timestamp);
  
  try {
    // Create backup directory
    fs.mkdirSync(backupDir, { recursive: true });
    
    // Backup environment variables
    const envVars = {
      NODE_ENV: process.env.NODE_ENV,
      NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL,
      VERCEL_ENV: process.env.VERCEL_ENV,
      VERCEL_URL: process.env.VERCEL_URL,
    };
    
    fs.writeFileSync(
      path.join(backupDir, 'environment.json'),
      JSON.stringify(envVars, null, 2)
    );
    
    // Backup build artifacts
    if (fs.existsSync('.next')) {
      execSync(`cp -r .next ${backupDir}/`, { stdio: 'inherit' });
    }
    
    // Backup configuration files
    const configFiles = ['vercel.json', 'package.json', 'next.config.js'];
    configFiles.forEach(file => {
      if (fs.existsSync(file)) {
        fs.copyFileSync(file, path.join(backupDir, file));
      }
    });
    
    console.log(`✅ Backup created: ${backupDir}`);
    
    // Clean up old backups (keep last 10)
    const backupsDir = path.join(process.cwd(), 'backups');
    if (fs.existsSync(backupsDir)) {
      const backups = fs.readdirSync(backupsDir)
        .sort()
        .reverse()
        .slice(10);
      
      backups.forEach(backup => {
        fs.rmSync(path.join(backupsDir, backup), { recursive: true });
      });
    }
    
  } catch (error) {
    console.error('❌ Backup failed:', error.message);
    process.exit(1);
  }
}

createDeploymentBackup();
```

## Rollback Script

```bash
#!/bin/bash
# scripts/rollback.sh

set -e

BACKUP_DIR=$1
if [ -z "$BACKUP_DIR" ]; then
  echo "❌ Usage: $0 <backup-directory>"
  exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
  echo "❌ Backup directory not found: $BACKUP_DIR"
  exit 1
fi

echo "🔄 Starting rollback to backup: $BACKUP_DIR"

# Restore configuration files
if [ -f "$BACKUP_DIR/vercel.json" ]; then
  cp "$BACKUP_DIR/vercel.json" .
  echo "✅ Restored vercel.json"
fi

if [ -f "$BACKUP_DIR/package.json" ]; then
  cp "$BACKUP_DIR/package.json" .
  echo "✅ Restored package.json"
fi

# Restore build artifacts
if [ -d "$BACKUP_DIR/.next" ]; then
  rm -rf .next
  cp -r "$BACKUP_DIR/.next" .
  echo "✅ Restored build artifacts"
fi

# Re-deploy
echo "🚀 Re-deploying rollback version..."
vercel --prod

echo "✅ Rollback completed successfully!"
```

---

# Testing and Validation

## E2E Testing

```typescript
// tests/e2e/deployment.test.ts
import { test, expect } from '@playwright/test';

test.describe('Deployment Validation', () => {
  test('should load main page', async ({ page }) => {
    await page.goto(process.env.DEPLOYMENT_URL || 'http://localhost:3000');
    
    await expect(page).toHaveTitle(/Your App/);
    await expect(page.locator('h1')).toBeVisible();
  });

  test('should handle API routes', async ({ request }) => {
    const response = await request.get(`${process.env.DEPLOYMENT_URL}/api/health`);
    
    expect(response.status()).toBe(200);
    const data = await response.json();
    expect(data).toHaveProperty('status', 'ok');
  });

  test('should serve static assets', async ({ page }) => {
    await page.goto(process.env.DEPLOYMENT_URL || 'http://localhost:3000');
    
    const imageResponse = await page.goto('/_next/static/media/logo.png');
    expect(imageResponse?.status()).toBe(200);
  });

  test('should have proper security headers', async ({ request }) => {
    const response = await request.get(process.env.DEPLOYMENT_URL || 'http://localhost:3000');
    
    const headers = response.headers();
    expect(headers['x-content-type-options']).toBe('nosniff');
    expect(headers['x-frame-options']).toBe('DENY');
    expect(headers['x-xss-protection']).toBe('1; mode=block');
  });
});
```

## Performance Testing

```typescript
// tests/performance/deployment.test.ts
import { test, expect } from '@playwright/test';

test.describe('Performance Tests', () => {
  test('should load within performance budget', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto(process.env.DEPLOYMENT_URL || 'http://localhost:3000');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    
    // Performance budget: 3 seconds
    expect(loadTime).toBeLessThan(3000);
    
    // Check Core Web Vitals
    const metrics = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          const vitals = {};
          
          entries.forEach((entry) => {
            if (entry.entryType === 'largest-contentful-paint') {
              vitals.lcp = entry.startTime;
            } else if (entry.entryType === 'first-input') {
              vitals.fid = entry.processingStart - entry.startTime;
            } else if (entry.entryType === 'layout-shift') {
              vitals.cls = entry.value;
            }
          });
          
          resolve(vitals);
        }).observe({ entryTypes: ['largest-contentful-paint', 'first-input', 'layout-shift'] });
      });
    });
    
    expect(metrics.lcp).toBeLessThan(2500); // LCP < 2.5s
    expect(metrics.fid).toBeLessThan(100);   // FID < 100ms
    expect(metrics.cls).toBeLessThan(0.1);   // CLS < 0.1
  });
});
```

---

# Tämä Vercel-deployment-malli takaa:

1. **Johdonmukaisuus** - Standardoidut konfiguraatiot kaikille projekteille
2. **Luotettavuus** - Automatisoidut testit ja validoinnit
3. **Suorituskyky** - Optimoidut build-prosessit ja caching
4. **Tietoturva** - Kattavat security headers ja rate limiting
5. **Monitorointi** - Integroitu analytiikka ja virheenseuranta
6. **Vikasietoisuus** - Backupit ja rollback-mahdollisuudet

**Muista:** Päivitä nämä konfiguraatiot säännöllisesti ja testaa ne huolellisesti ennen tuotantokäyttöä.

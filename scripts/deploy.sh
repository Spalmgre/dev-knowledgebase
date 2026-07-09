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

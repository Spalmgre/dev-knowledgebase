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

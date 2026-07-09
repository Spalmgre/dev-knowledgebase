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

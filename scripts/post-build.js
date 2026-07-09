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

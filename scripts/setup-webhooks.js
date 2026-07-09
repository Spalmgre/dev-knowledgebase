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

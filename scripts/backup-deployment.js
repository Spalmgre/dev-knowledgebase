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

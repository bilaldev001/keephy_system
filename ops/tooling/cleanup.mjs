#!/usr/bin/env node

/**
 * Cleanup script to remove build artifacts and unnecessary files
 * 
 * Usage: node ops/tooling/cleanup.mjs [--dry-run] [--remove-legacy]
 */

import { execSync } from 'child_process';
import { existsSync, rmSync } from 'fs';
import { join } from 'path';

const DRY_RUN = process.argv.includes('--dry-run');
const REMOVE_LEGACY = process.argv.includes('--remove-legacy');

const rootDir = process.cwd();

function log(message) {
  console.log(`[cleanup] ${message}`);
}

function remove(path, description) {
  const fullPath = join(rootDir, path);
  if (!existsSync(fullPath)) {
    log(`⚠️  ${description} not found: ${path}`);
    return;
  }

  if (DRY_RUN) {
    log(`[DRY RUN] Would remove: ${path}`);
    return;
  }

  try {
    rmSync(fullPath, { recursive: true, force: true });
    log(`✅ Removed: ${path}`);
  } catch (error) {
    log(`❌ Error removing ${path}: ${error.message}`);
  }
}

// Remove build artifacts
log('Cleaning build artifacts...');
const buildArtifacts = [
  // Frontend build outputs
  'frontend/admin/.next',
  'frontend/analytics/.next',
  'frontend/billing/.next',
  'frontend/builder/.next',
  'frontend/compliance/.next',
  'frontend/crm/.next',
  'frontend/ems/.next',
  'frontend/fbms/.next',
  'frontend/forms/.next',
  'frontend/hrms/.next',
  'frontend/inventory/.next',
  'frontend/marketing/.next',
  'frontend/scm/.next',
  'frontend/support/.next',
  'frontend/vouchers/.next',
  
  // Package build outputs
  'frontend/packages/ui-core/dist',
  'frontend/packages/web-core/dist',
  'frontend/packages/i18n/dist',
  
  // Backend build outputs
  'backend/services/api-gateway/dist',
  'backend/services/identity-service/dist',
  'backend/services/access-service/dist',
  'backend/services/subscriptions-service/dist',
  
  // TypeScript build info
  'frontend/ems/tsconfig.tsbuildinfo',
  'frontend/inventory/tsconfig.tsbuildinfo',
  'frontend/marketing/tsconfig.tsbuildinfo',
  'frontend/packages/ui-core/tsconfig.tsbuildinfo',
];

buildArtifacts.forEach((path) => {
  remove(path, 'Build artifact');
});

// Remove root-level unnecessary files
log('Cleaning root-level files...');
const rootFiles = [
  'app_logo.webp', // Only used in lagecy folder
  'bd007881-26dd-4e92-98da-42f458855e4e.jpeg', // Unused image
];

rootFiles.forEach((file) => {
  remove(file, 'Root file');
});

// Remove legacy folder if requested
if (REMOVE_LEGACY) {
  log('Removing legacy folder...');
  remove('lagecy', 'Legacy folder');
} else {
  log('ℹ️  Legacy folder (lagecy/) kept. Use --remove-legacy to remove it.');
  log('   Note: This folder is 50MB and contains old code not used in current codebase.');
}

log(DRY_RUN ? 'Dry run complete. Use without --dry-run to actually remove files.' : 'Cleanup complete!');


#!/usr/bin/env node

/**
 * ⚠️  DEPRECATED: api-postgres has been decommissioned
 * 
 * This script is kept for historical reference only.
 * The api-postgres monolith has been fully decommissioned.
 * 
 * All modules have been migrated to microservices.
 * See: backend/docs/api-postgres-decommission-complete.md
 */

import { readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const rootDir = join(__dirname, '../..');

function log(message) {
  console.log(`[verify-overlaps] ${message}`);
}

function checkFileExists(path) {
  return existsSync(join(rootDir, path));
}

function readFile(path) {
  try {
    return readFileSync(join(rootDir, path), 'utf8');
  } catch {
    return null;
  }
}

log('⚠️  api-postgres has been decommissioned.');
log('   All modules have been migrated to microservices.');
log('   See: backend/docs/api-postgres-decommission-complete.md');
process.exit(0);

// Original verification logic removed - api-postgres no longer exists
/*
log('Verifying overlaps between legacy api-postgres and microservices...');
log('');

// 1. Check Analytics Overlap
log('1. ANALYTICS SERVICE');
log('   Legacy routes: /analytics/finance, /analytics/benchmarking');
log('   Microservice: analytics-service');
const analyticsServiceExists = checkFileExists('backend/services/analytics-service/src');
const analyticsController = globFileSearch('**/analytics-service/**/*.controller.ts');
log(`   ✅ analytics-service exists: ${analyticsServiceExists}`);
log(`   ⚠️  Need to verify if /finance and /benchmarking endpoints exist in microservice`);
log('');

// 2. Check Auth Overlap
log('2. AUTH/IDENTITY SERVICE');
log('   Legacy routes: /auth/register, /auth/login, /auth/onboarding, /auth/manager');
log('   Microservice: identity-service');
const identityServiceExists = checkFileExists('backend/services/identity-service/src/auth/auth.controller.ts');
log(`   ✅ identity-service auth controller exists: ${identityServiceExists}`);
if (identityServiceExists) {
  const authController = readFile('backend/services/identity-service/src/auth/auth.controller.ts');
  const hasRegister = authController?.includes('@Post(\'register\')') || authController?.includes('register');
  const hasLogin = authController?.includes('@Post(\'login\')') || authController?.includes('login');
  const hasOnboarding = authController?.includes('onboarding');
  const hasManager = authController?.includes('manager') || authController?.includes('AddManager');
  log(`   ✅ Has register: ${hasRegister}`);
  log(`   ✅ Has login: ${hasLogin}`);
  log(`   ✅ Has onboarding: ${hasOnboarding}`);
  log(`   ✅ Has manager: ${hasManager}`);
  if (hasRegister && hasLogin && hasOnboarding && hasManager) {
    log('   ✅ FULL OVERLAP - Legacy auth can be removed');
  }
}
log('');

// 3. Check Compliance Overlap
log('3. COMPLIANCE SERVICE');
log('   Legacy routes: /security/compliance (assessments, drills, residency)');
log('   Microservice: compliance-service');
const complianceServiceExists = checkFileExists('backend/services/compliance-service/src');
log(`   ✅ compliance-service exists: ${complianceServiceExists}`);
log(`   ⚠️  Need to verify if assessments, drills, residency endpoints exist in microservice`);
log('');

// 4. Check Integration
log('4. INTEGRATION SERVICE');
log('   Legacy routes: /integration/*');
log('   Microservice: integration-service');
const integrationServiceExists = checkFileExists('backend/services/integration-service/src');
const integrationModuleEmpty = !checkFileExists('backend/api-postgres/src/modules/integration') || 
  (() => {
    try {
      const files = require('fs').readdirSync(join(rootDir, 'backend/api-postgres/src/modules/integration'));
      return files.length === 0;
    } catch {
      return true;
    }
  })();
log(`   ✅ integration-service exists: ${integrationServiceExists}`);
log(`   ✅ Legacy integration module empty: ${integrationModuleEmpty}`);
if (integrationModuleEmpty && integrationServiceExists) {
  log('   ✅ SAFE TO REMOVE - Legacy integration service folder');
}
log('');

// 5. Check Gateway Routing
log('5. API GATEWAY ROUTING');
const proxyTable = readFile('backend/services/api-gateway/src/proxy/proxy-table.ts');
const hasAnalyticsRoute = proxyTable?.includes("'/analytics'");
const hasAuthRoute = proxyTable?.includes("'/auth'");
const hasComplianceRoute = proxyTable?.includes("'/compliance'");
const hasIntegrationRoute = proxyTable?.includes("'/integration'");
log(`   ✅ /analytics routed: ${hasAnalyticsRoute}`);
log(`   ✅ /auth routed: ${hasAuthRoute}`);
log(`   ✅ /compliance routed: ${hasComplianceRoute}`);
log(`   ✅ /integration routed: ${hasIntegrationRoute}`);
log('');

log('Verification complete!');
log('');
log('RECOMMENDATIONS:');
if (identityServiceExists && hasAuthRoute) {
  log('✅ Remove legacy /auth routes - fully covered by identity-service');
}
if (integrationModuleEmpty && integrationServiceExists && hasIntegrationRoute) {
  log('✅ Remove legacy /integration service folder - empty and migrated');
}
log('⚠️  Verify analytics-service has /finance and /benchmarking endpoints');
log('⚠️  Verify compliance-service has assessments, drills, residency endpoints');


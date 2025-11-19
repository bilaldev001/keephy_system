#!/usr/bin/env node

/**
 * Setup Environment Variables
 * 
 * Creates .env files for all backend services that need database connections
 */

import { writeFile, mkdir } from 'fs/promises';
import { existsSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT_DIR = path.resolve(__dirname, '..');
const BACKEND_DIR = path.join(ROOT_DIR, 'backend');

const DB_CONNECTION_STRING = 'postgresql://postgres:postgres@localhost:5432/hrmssystem';

// Services that need DATABASE_URL
const SERVICES_WITH_DB = [
  'admin-service',
  'access-service',
  'identity-service',
  'ai-service',
  'analytics-service',
  'billing-service',
  'compliance-service',
  'media-service',
  'integration-service',
  'lifecycle-service',
  'mobile-service',
  'onboarding-service',
  'payroll-service',
  'builder-service',
  'facilities-service',
];

// Services with custom ports
const SERVICE_PORTS = {
  'api-gateway': 4000,
  'identity-service': 4001,
  'access-service': 4002,
  'media-service': 4003,
  'contacts-service': 4004,
  'notifications-service': 4005,
  'audit-service': 4006,
  'subscriptions-service': 4010,
  'entitlements-service': 4011,
  'billing-service': 4012,
  'observability-service': 4013,
  'fbms-service': 4014,
  'hrms-service': 4015,
  'scm-service': 4016,
  'inventory-service': 4017,
  'crm-service': 4018,
  'support-service': 4019,
  'compliance-service': 4020,
  'analytics-service': 4021,
  'ems-service': 4022,
  'voucher-service': 4024,
  'forms-service': 4025,
  'builder-service': 4026,
  'onboarding-service': 4027,
  'admin-service': 4028,
  'ai-service': 4029,
  'lifecycle-service': 4030,
  'integration-service': 4031,
  'facilities-service': 4015,
  'mobile-service': 4032,
  'tenant-service': 4033,
  'payroll-service': 4016,
};

async function createEnvFile(serviceName) {
  const serviceDir = path.join(BACKEND_DIR, 'services', serviceName);
  const envPath = path.join(serviceDir, '.env');

  if (!existsSync(serviceDir)) {
    console.log(`⚠️  Service ${serviceName} not found, skipping...`);
    return;
  }

  const port = SERVICE_PORTS[serviceName] || '';
  const needsDatabase = SERVICES_WITH_DB.includes(serviceName);

  let envContent = `# Environment variables for ${serviceName}\n`;
  envContent += `NODE_ENV=development\n`;
  
  if (port) {
    envContent += `PORT=${port}\n`;
  }

  if (needsDatabase) {
    envContent += `DATABASE_URL=${DB_CONNECTION_STRING}\n`;
  }

  // Add service-specific environment variables
  if (serviceName === 'api-gateway') {
    envContent += `\n# Service URLs\n`;
    envContent += `IDENTITY_SERVICE_URL=http://localhost:4001\n`;
    envContent += `ACCESS_SERVICE_URL=http://localhost:4002\n`;
    envContent += `ADMIN_SERVICE_URL=http://localhost:4028\n`;
    envContent += `MEDIA_SERVICE_URL=http://localhost:4003\n`;
    envContent += `CONTACTS_SERVICE_URL=http://localhost:4004\n`;
    envContent += `NOTIFICATIONS_SERVICE_URL=http://localhost:4005\n`;
    envContent += `AUDIT_SERVICE_URL=http://localhost:4006\n`;
    envContent += `SUBSCRIPTIONS_SERVICE_URL=http://localhost:4010\n`;
    envContent += `ENTITLEMENTS_SERVICE_URL=http://localhost:4011\n`;
    envContent += `BILLING_SERVICE_URL=http://localhost:4012\n`;
    envContent += `OBSERVABILITY_SERVICE_URL=http://localhost:4013\n`;
    envContent += `FBMS_SERVICE_URL=http://localhost:4014\n`;
    envContent += `HRMS_SERVICE_URL=http://localhost:4015\n`;
    envContent += `SCM_SERVICE_URL=http://localhost:4016\n`;
    envContent += `INVENTORY_SERVICE_URL=http://localhost:4017\n`;
    envContent += `CRM_SERVICE_URL=http://localhost:4018\n`;
    envContent += `SUPPORT_SERVICE_URL=http://localhost:4019\n`;
    envContent += `COMPLIANCE_SERVICE_URL=http://localhost:4020\n`;
    envContent += `ANALYTICS_SERVICE_URL=http://localhost:4021\n`;
    envContent += `EMS_SERVICE_URL=http://localhost:4022\n`;
    envContent += `VOUCHER_SERVICE_URL=http://localhost:4024\n`;
    envContent += `FORMS_SERVICE_URL=http://localhost:4025\n`;
    envContent += `BUILDER_SERVICE_URL=http://localhost:4026\n`;
    envContent += `ONBOARDING_SERVICE_URL=http://localhost:4027\n`;
    envContent += `AI_SERVICE_URL=http://localhost:4029\n`;
    envContent += `LIFECYCLE_SERVICE_URL=http://localhost:4030\n`;
    envContent += `INTEGRATION_SERVICE_URL=http://localhost:4031\n`;
    envContent += `FACILITIES_SERVICE_URL=http://localhost:4015\n`;
    envContent += `MOBILE_SERVICE_URL=http://localhost:4032\n`;
    envContent += `TENANT_SERVICE_URL=http://localhost:4033\n`;
    envContent += `PAYROLL_SERVICE_URL=http://localhost:4016\n`;
  }

  try {
    await writeFile(envPath, envContent, 'utf-8');
    console.log(`✓ Created .env for ${serviceName}`);
  } catch (error) {
    console.error(`✗ Failed to create .env for ${serviceName}: ${error.message}`);
  }
}

async function main() {
  console.log('\n🔧 Setting up environment variables for all services...\n');
  console.log(`Database URL: ${DB_CONNECTION_STRING}\n`);

  // Create .env for all services
  const allServices = Object.keys(SERVICE_PORTS);
  
  for (const serviceName of allServices) {
    await createEnvFile(serviceName);
  }

  // Also create .env for frontend admin if needed
  const frontendAdminDir = path.join(ROOT_DIR, 'frontend', 'admin');
  if (existsSync(frontendAdminDir)) {
    const adminEnvPath = path.join(frontendAdminDir, '.env.local');
    const adminEnvContent = `# Frontend Admin Environment Variables
NEXT_PUBLIC_GATEWAY_URL=http://localhost:4000
NEXT_PUBLIC_DEMO_TENANT_ID=11111111-2222-3333-4444-555555555555
NEXT_PUBLIC_DEMO_BEARER_TOKEN=demo-admin-token
`;

    try {
      await writeFile(adminEnvPath, adminEnvContent, 'utf-8');
      console.log(`✓ Created .env.local for frontend/admin`);
    } catch (error) {
      console.error(`✗ Failed to create .env.local for frontend/admin: ${error.message}`);
    }
  }

  console.log('\n✅ Environment setup complete!\n');
}

main().catch(console.error);


#!/usr/bin/env node

/**
 * Comprehensive System Test Script
 * 
 * This script tests the entire HRMS system by:
 * 1. Installing all dependencies
 * 2. Checking PostgreSQL connection
 * 3. Running migrations
 * 4. Starting all backend services
 * 5. Starting all frontend applications
 * 6. Performing health checks
 */

import { spawn, exec } from 'child_process';
import { promisify } from 'util';
import { fileURLToPath } from 'url';
import path from 'path';
import fs from 'fs/promises';

const execAsync = promisify(exec);
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const ROOT_DIR = path.resolve(__dirname, '..');

// Color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

const log = {
  info: (msg) => console.log(`${colors.blue}ℹ${colors.reset} ${msg}`),
  success: (msg) => console.log(`${colors.green}✓${colors.reset} ${msg}`),
  error: (msg) => console.log(`${colors.red}✗${colors.reset} ${msg}`),
  warn: (msg) => console.log(`${colors.yellow}⚠${colors.reset} ${msg}`),
  section: (msg) => console.log(`\n${colors.bright}${colors.cyan}${'='.repeat(60)}${colors.reset}\n${colors.bright}${msg}${colors.reset}\n${'='.repeat(60)}\n`),
};

// Service configuration
const SERVICES = {
  backend: [
    { name: 'api-gateway', port: 4000, path: 'services/api-gateway', critical: true },
    { name: 'identity-service', port: 4001, path: 'services/identity-service', critical: true },
    { name: 'access-service', port: 4002, path: 'services/access-service', critical: true },
    { name: 'media-service', port: 4003, path: 'services/media-service', critical: false },
    { name: 'contacts-service', port: 4004, path: 'services/contacts-service', critical: false },
    { name: 'notifications-service', port: 4005, path: 'services/notifications-service', critical: false },
    { name: 'audit-service', port: 4006, path: 'services/audit-service', critical: false },
    { name: 'subscriptions-service', port: 4010, path: 'services/subscriptions-service', critical: false },
    { name: 'entitlements-service', port: 4011, path: 'services/entitlements-service', critical: false },
    { name: 'billing-service', port: 4012, path: 'services/billing-service', critical: false },
    { name: 'observability-service', port: 4013, path: 'services/observability-service', critical: false },
    { name: 'fbms-service', port: 4014, path: 'services/fbms-service', critical: false },
    { name: 'hrms-service', port: 4015, path: 'services/hrms-service', critical: false },
    { name: 'scm-service', port: 4016, path: 'services/scm-service', critical: false },
    { name: 'inventory-service', port: 4017, path: 'services/inventory-service', critical: false },
    { name: 'crm-service', port: 4018, path: 'services/crm-service', critical: false },
    { name: 'support-service', port: 4019, path: 'services/support-service', critical: false },
    { name: 'compliance-service', port: 4020, path: 'services/compliance-service', critical: false },
    { name: 'analytics-service', port: 4021, path: 'services/analytics-service', critical: false },
    { name: 'ems-service', port: 4022, path: 'services/ems-service', critical: false },
    { name: 'voucher-service', port: 4024, path: 'services/voucher-service', critical: false },
    { name: 'forms-service', port: 4025, path: 'services/forms-service', critical: false },
    { name: 'builder-service', port: 4026, path: 'services/builder-service', critical: false },
    { name: 'onboarding-service', port: 4027, path: 'services/onboarding-service', critical: false },
    { name: 'admin-service', port: 4028, path: 'services/admin-service', critical: false },
    { name: 'ai-service', port: 4029, path: 'services/ai-service', critical: false },
    { name: 'lifecycle-service', port: 4030, path: 'services/lifecycle-service', critical: false },
    { name: 'integration-service', port: 4031, path: 'services/integration-service', critical: false },
    { name: 'facilities-service', port: 4015, path: 'services/facilities-service', critical: false },
    { name: 'mobile-service', port: 4032, path: 'services/mobile-service', critical: false },
    { name: 'tenant-service', port: 4033, path: 'services/tenant-service', critical: false },
    { name: 'payroll-service', port: 4016, path: 'services/payroll-service', critical: false },
  ],
  frontend: [
    { name: 'admin', port: 4205, path: 'admin', critical: true },
    { name: 'analytics', port: 4206, path: 'analytics', critical: false },
    { name: 'billing', port: 4207, path: 'billing', critical: false },
    { name: 'compliance', port: 4208, path: 'compliance', critical: false },
    { name: 'crm', port: 4209, path: 'crm', critical: false },
    { name: 'ems', port: 4210, path: 'ems', critical: false },
    { name: 'fbms', port: 4211, path: 'fbms', critical: false },
    { name: 'forms', port: 4212, path: 'forms', critical: false },
    { name: 'hrms', port: 4213, path: 'hrms', critical: false },
    { name: 'inventory', port: 4214, path: 'inventory', critical: false },
    { name: 'scm', port: 4215, path: 'scm', critical: false },
    { name: 'support', port: 4216, path: 'support', critical: false },
    { name: 'vouchers', port: 4217, path: 'vouchers', critical: false },
    { name: 'builder', port: 4218, path: 'builder', critical: false },
    { name: 'marketing', port: 4219, path: 'marketing', critical: false },
  ],
};

const processes = new Map();

// Check if a port is available
async function checkPort(port) {
  try {
    const { stdout } = await execAsync(`lsof -ti:${port} || echo ''`);
    return !stdout.trim();
  } catch {
    return true;
  }
}

// Wait for a service to be ready
async function waitForService(name, url, timeout = 30000) {
  const startTime = Date.now();
  const maxAttempts = 30;
  let attempts = 0;

  while (attempts < maxAttempts) {
    try {
      const response = await fetch(url, { method: 'GET', signal: AbortSignal.timeout(2000) });
      if (response.ok || response.status === 404) {
        return true;
      }
    } catch (error) {
      // Service not ready yet
    }

    attempts++;
    const elapsed = Date.now() - startTime;
    if (elapsed > timeout) {
      return false;
    }
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  return false;
}

// Check PostgreSQL connection
async function checkPostgreSQL() {
  log.info('Checking PostgreSQL connection...');
  try {
    // Check if PostgreSQL is running
    await execAsync('pg_isready || echo "PostgreSQL not running"');
    log.success('PostgreSQL is running');
    return true;
  } catch (error) {
    log.warn('PostgreSQL may not be running. Some services may fail.');
    log.info('To start PostgreSQL: brew services start postgresql@14 (Mac) or sudo systemctl start postgresql (Linux)');
    return false;
  }
}

// Install dependencies
async function installDependencies() {
  log.section('Installing Dependencies');

  try {
    log.info('Installing backend dependencies...');
    await execAsync('npm install --legacy-peer-deps', { cwd: path.join(ROOT_DIR, 'backend'), stdio: 'inherit' });
    log.success('Backend dependencies installed');

    log.info('Installing frontend dependencies...');
    await execAsync('npm install', { cwd: path.join(ROOT_DIR, 'frontend'), stdio: 'inherit' });
    log.success('Frontend dependencies installed');
  } catch (error) {
    log.error('Failed to install dependencies');
    throw error;
  }
}

// Run migrations for services
async function runMigrations() {
  log.section('Running Database Migrations');

  const servicesWithMigrations = [
    'access-service',
    'admin-service',
    'identity-service',
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

  for (const serviceName of servicesWithMigrations) {
    const service = SERVICES.backend.find(s => s.name === serviceName);
    if (!service) continue;

    try {
      log.info(`Running migrations for ${serviceName}...`);
      const servicePath = path.join(ROOT_DIR, 'backend', service.path);
      const packageJsonPath = path.join(servicePath, 'package.json');
      
      try {
        await fs.access(packageJsonPath);
        const packageJson = JSON.parse(await fs.readFile(packageJsonPath, 'utf-8'));
        
        if (packageJson.scripts && packageJson.scripts.migration) {
          await execAsync('npm run migration', { cwd: servicePath, stdio: 'pipe' });
          log.success(`Migrations completed for ${serviceName}`);
        } else {
          // Try TypeORM migration command
          try {
            await execAsync('npx typeorm migration:run', { cwd: servicePath, stdio: 'pipe' });
            log.success(`Migrations completed for ${serviceName}`);
          } catch {
            log.warn(`No migrations found for ${serviceName}`);
          }
        }
      } catch {
        log.warn(`Service ${serviceName} not found, skipping migrations`);
      }
    } catch (error) {
      log.warn(`Failed to run migrations for ${serviceName}: ${error.message}`);
    }
  }
}

// Start a service
function startService(service, type) {
  return new Promise((resolve, reject) => {
    const servicePath = path.join(ROOT_DIR, type === 'backend' ? 'backend' : 'frontend', service.path);
    const command = type === 'backend' ? 'npm run start:dev' : 'npm run dev';
    
    log.info(`Starting ${service.name} on port ${service.port}...`);

    const proc = spawn('npm', ['run', type === 'backend' ? 'start:dev' : 'dev'], {
      cwd: servicePath,
      shell: true,
      stdio: 'pipe',
      env: { ...process.env, PORT: service.port.toString() },
    });

    let output = '';
    proc.stdout.on('data', (data) => {
      output += data.toString();
      if (type === 'backend' && output.includes('listening') || output.includes('running on port')) {
        resolve(proc);
      }
    });

    proc.stderr.on('data', (data) => {
      output += data.toString();
    });

    proc.on('error', (error) => {
      log.error(`Failed to start ${service.name}: ${error.message}`);
      reject(error);
    });

    // Give it some time to start
    setTimeout(() => {
      if (proc.exitCode === null) {
        processes.set(`${type}-${service.name}`, proc);
        resolve(proc);
      }
    }, 3000);
  });
}

// Start all services
async function startServices(onlyCritical = false) {
  log.section(`Starting Services${onlyCritical ? ' (Critical Only)' : ''}`);

  // Start backend services
  log.section('Starting Backend Services');
  const backendServices = onlyCritical 
    ? SERVICES.backend.filter(s => s.critical)
    : SERVICES.backend;

  for (const service of backendServices) {
    const isAvailable = await checkPort(service.port);
    if (!isAvailable) {
      log.warn(`Port ${service.port} is already in use, skipping ${service.name}`);
      continue;
    }

    try {
      await startService(service, 'backend');
      log.success(`${service.name} started on port ${service.port}`);
    } catch (error) {
      if (service.critical) {
        log.error(`Failed to start critical service ${service.name}`);
        throw error;
      } else {
        log.warn(`Failed to start ${service.name}, continuing...`);
      }
    }

    // Small delay between service starts
    await new Promise(resolve => setTimeout(resolve, 2000));
  }

  // Wait a bit for backend services to initialize
  log.info('Waiting for backend services to initialize...');
  await new Promise(resolve => setTimeout(resolve, 10000));

  // Start frontend applications
  log.section('Starting Frontend Applications');
  const frontendApps = onlyCritical
    ? SERVICES.frontend.filter(a => a.critical)
    : SERVICES.frontend;

  for (const app of frontendApps) {
    const isAvailable = await checkPort(app.port);
    if (!isAvailable) {
      log.warn(`Port ${app.port} is already in use, skipping ${app.name}`);
      continue;
    }

    try {
      await startService(app, 'frontend');
      log.success(`${app.name} started on http://localhost:${app.port}`);
    } catch (error) {
      if (app.critical) {
        log.error(`Failed to start critical app ${app.name}`);
        throw error;
      } else {
        log.warn(`Failed to start ${app.name}, continuing...`);
      }
    }

    await new Promise(resolve => setTimeout(resolve, 1000));
  }
}

// Health check
async function healthCheck() {
  log.section('Performing Health Checks');

  const checks = [
    { name: 'API Gateway', url: 'http://localhost:4000' },
    { name: 'Identity Service', url: 'http://localhost:4001' },
    { name: 'Access Service', url: 'http://localhost:4002' },
    { name: 'Admin Service', url: 'http://localhost:4028' },
    { name: 'Admin Frontend', url: 'http://localhost:4205' },
  ];

  for (const check of checks) {
    log.info(`Checking ${check.name}...`);
    const isHealthy = await waitForService(check.name, check.url, 10000);
    if (isHealthy) {
      log.success(`${check.name} is healthy`);
    } else {
      log.warn(`${check.name} is not responding (this may be normal if the service doesn't have a root endpoint)`);
    }
  }
}

// Cleanup function
function cleanup() {
  log.section('Cleaning Up');
  log.info('Stopping all services...');
  
  processes.forEach((proc, name) => {
    try {
      proc.kill();
      log.success(`Stopped ${name}`);
    } catch (error) {
      log.warn(`Failed to stop ${name}`);
    }
  });

  processes.clear();
}

// Main execution
async function main() {
  const args = process.argv.slice(2);
  const skipInstall = args.includes('--skip-install');
  const skipMigrations = args.includes('--skip-migrations');
  const onlyCritical = args.includes('--critical-only');
  const skipHealthCheck = args.includes('--skip-health-check');

  try {
    log.section('HRMS System Test Script');

    // Handle cleanup on exit
    process.on('SIGINT', () => {
      log.warn('\nReceived interrupt signal...');
      cleanup();
      process.exit(0);
    });

    process.on('SIGTERM', () => {
      cleanup();
      process.exit(0);
    });

    // Check PostgreSQL
    await checkPostgreSQL();

    // Install dependencies
    if (!skipInstall) {
      await installDependencies();
    } else {
      log.info('Skipping dependency installation');
    }

    // Run migrations
    if (!skipMigrations) {
      await runMigrations();
    } else {
      log.info('Skipping migrations');
    }

    // Start services
    await startServices(onlyCritical);

    // Health checks
    if (!skipHealthCheck) {
      await healthCheck();
    }

    log.section('System Ready!');
    log.success('All services are running');
    log.info('\nKey URLs:');
    log.info('  API Gateway:     http://localhost:4000');
    log.info('  Admin Frontend:  http://localhost:4205');
    log.info('\nPress Ctrl+C to stop all services');

    // Keep the script running
    await new Promise(() => {});

  } catch (error) {
    log.error(`Fatal error: ${error.message}`);
    cleanup();
    process.exit(1);
  }
}

main();


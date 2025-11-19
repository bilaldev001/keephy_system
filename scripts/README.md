# HRMS System Test Scripts

This directory contains scripts to test and run the entire HRMS system.

## Available Scripts

### 1. `test-system.mjs` (Node.js - Comprehensive)
A comprehensive Node.js script that includes:
- Dependency installation
- PostgreSQL health checks
- Database migrations
- Service startup with health checks
- Graceful shutdown handling

**Usage:**
```bash
# Start all services
node scripts/test-system.mjs

# Start only critical services
node scripts/test-system.mjs --critical-only

# Skip dependency installation
node scripts/test-system.mjs --skip-install

# Skip migrations
node scripts/test-system.mjs --skip-migrations

# Skip health checks
node scripts/test-system.mjs --skip-health-check

# Combine options
node scripts/test-system.mjs --critical-only --skip-install
```

### 2. `start-all.sh` (Bash - Simple)
A simpler bash script for quick startup:
- Basic dependency installation
- Service startup with process management
- PID tracking for cleanup

**Usage:**
```bash
# Start all services
./scripts/start-all.sh

# Start only critical services
./scripts/start-all.sh --critical-only

# Skip dependency installation
./scripts/start-all.sh --skip-install

# Show help
./scripts/start-all.sh --help
```

## Service Ports

### Backend Services
- **API Gateway**: 4000 (Critical)
- **Identity Service**: 4001 (Critical)
- **Access Service**: 4002 (Critical)
- **Media Service**: 4003
- **Contacts Service**: 4004
- **Notifications Service**: 4005
- **Audit Service**: 4006
- **Subscriptions Service**: 4010
- **Entitlements Service**: 4011
- **Billing Service**: 4012
- **Observability Service**: 4013
- **FBMS Service**: 4014
- **HRMS Service**: 4015
- **SCM Service**: 4016
- **Inventory Service**: 4017
- **CRM Service**: 4018
- **Support Service**: 4019
- **Compliance Service**: 4020
- **Analytics Service**: 4021
- **EMS Service**: 4022
- **Voucher Service**: 4024
- **Forms Service**: 4025
- **Builder Service**: 4026
- **Onboarding Service**: 4027
- **Admin Service**: 4028
- **AI Service**: 4029
- **Lifecycle Service**: 4030
- **Integration Service**: 4031
- **Facilities Service**: 4015
- **Mobile Service**: 4032
- **Tenant Service**: 4033
- **Payroll Service**: 4016

### Frontend Applications
- **Admin**: 4205 (Critical)
- **Analytics**: 4206
- **Billing**: 4207
- **Compliance**: 4208
- **CRM**: 4209
- **EMS**: 4210
- **FBMS**: 4211
- **Forms**: 4212
- **HRMS**: 4213
- **Inventory**: 4214
- **SCM**: 4215
- **Support**: 4216
- **Vouchers**: 4217
- **Builder**: 4218
- **Marketing**: 4219

## Prerequisites

1. **Node.js**: Version 18 or higher
2. **PostgreSQL**: Running and accessible
   - Mac: `brew services start postgresql@14`
   - Linux: `sudo systemctl start postgresql`
3. **npm**: Installed with Node.js

## Environment Variables

Make sure you have the following environment variables set (or use `.env` files):

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/hrmssystem

# Services (optional - defaults provided)
IDENTITY_SERVICE_URL=http://localhost:4001
ACCESS_SERVICE_URL=http://localhost:4002
# ... etc
```

## Stopping Services

### For `test-system.mjs`:
Press `Ctrl+C` - the script will gracefully stop all services.

### For `start-all.sh`:
Press `Ctrl+C` - the script will kill all tracked processes.

### Manual cleanup:
```bash
# Kill all Node processes (use with caution)
pkill -f "npm run start:dev"
pkill -f "npm run dev"

# Or kill specific ports
lsof -ti:4000 | xargs kill -9
```

## Logs

- **test-system.mjs**: Outputs to console
- **start-all.sh**: Logs are saved to `.logs/` directory
  - Each service/app has its own log file
  - Example: `.logs/admin-service.log`, `.logs/admin.log`

## Troubleshooting

### Port already in use
```bash
# Find what's using the port
lsof -i :4000

# Kill the process
kill -9 <PID>
```

### Service fails to start
1. Check the logs (`.logs/` directory)
2. Verify PostgreSQL is running
3. Check if dependencies are installed: `cd backend && npm install`
4. Verify environment variables are set correctly

### Migrations fail
1. Ensure PostgreSQL is running
2. Check database connection string
3. Verify user has permissions to create tables
4. Check migration files exist in the service directory

## Quick Start

```bash
# 1. Install dependencies (first time only)
cd backend && npm install
cd ../frontend && npm install

# 2. Start PostgreSQL
brew services start postgresql@14  # Mac
# or
sudo systemctl start postgresql    # Linux

# 3. Run migrations (first time only)
# This happens automatically in test-system.mjs

# 4. Start all services
node scripts/test-system.mjs

# Or use the bash script
./scripts/start-all.sh
```

## Testing Individual Services

```bash
# Start a single backend service
cd backend/services/admin-service
npm run start:dev

# Start a single frontend app
cd frontend/admin
npm run dev
```


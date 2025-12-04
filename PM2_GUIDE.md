# PM2 Process Management Guide

This guide explains how to run all Frontend and Backend services using PM2 instead of Docker.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
- [Configuration Files](#configuration-files)
- [Common Commands](#common-commands)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

1. **Node.js** (v18 or higher)
```bash
node --version
```

2. **PM2** (Process Manager)
```bash
npm install -g pm2
```

3. **PostgreSQL** (Database)
```bash
# Make sure PostgreSQL is running on localhost:5432
psql -U postgres -c "SELECT version();"
```

### Database Setup

Ensure your PostgreSQL database is configured:
```bash
# Database name: hrmssystem
# Username: postgres
# Password: postgres
# Host: localhost
# Port: 5432
```

---

## Quick Start

### Start Everything (Backend + Frontend)

```bash
# Option 1: Using script
./start-all-pm2.sh

# Option 2: Using npm
npm run pm2:start:all
```

### Start Backend Only

```bash
# Option 1: Using script
./start-backend-pm2.sh

# Option 2: Using npm
npm run pm2:start:backend
```

### Start Frontend Only

```bash
# Option 1: Using script
./start-frontend-pm2.sh

# Option 2: Using npm
npm run pm2:start:frontend
```

---

## Detailed Usage

### Backend Services (28 Services)

The backend consists of 28 microservices organized by priority:

#### Critical Services (Start First)
- `api-gateway` - Port 3010
- `identity-service` - Port 4001
- `access-service` - Port 4002
- `tenant-service` - Port 4023

#### Core Services
- `admin-service` - Port 4028
- `media-service` - Port 4003
- `contacts-service` - Port 4004
- `notifications-service` - Port 4005
- `audit-service` - Port 4006

#### Business Domain Services
- `billing-service` - Port 4012
- `hrms-service` - Port 4015
- `analytics-service` - Port 4021
- `crm-service` - Port 4018
- `ai-service` - Port 4029
- `payroll-service` - Port 4016
- `subscriptions-service` - Port 4010
- `entitlements-service` - Port 4011
- `compliance-service` - Port 4020
- `ems-service` - Port 4022
- `facilities-service` - Port 4024
- `onboarding-service` - Port 4027
- `integration-service` - Port 4031
- `lifecycle-service` - Port 4030
- `mobile-service` - Port 4032
- `fbms-service` - Port 4014
- `builder-service` - Port 4007
- `forms-service` - Port 4008
- `inventory-service` - Port 4009
- `scm-service` - Port 4013
- `support-service` - Port 4017
- `voucher-service` - Port 4019
- `migration-service` - Port 4025
- `observability-service` - Port 4026

#### Managing Backend Services

```bash
# Start all backend services
./start-backend-pm2.sh

# Stop all backend services
./stop-backend-pm2.sh

# Restart all backend services
pm2 restart ecosystem.backend.config.js

# View backend logs
pm2 logs api-gateway
pm2 logs identity-service

# Stop specific service
pm2 stop api-gateway

# Start specific service
pm2 start ecosystem.backend.config.js --only api-gateway
```

### Frontend Applications (17 Apps)

The frontend consists of 17 Next.js applications:

- `frontend-admin` - Port 5210 (Main Admin Portal)
- `frontend-marketing` - Port 5200 (Marketing Website)
- `frontend-console` - Port 5201 (Console Dashboard)
- `frontend-analytics` - Port 4206
- `frontend-billing` - Port 4207
- `frontend-hrms` - Port 4213
- `frontend-crm` - Port 4209
- `frontend-fbms` - Port 4214
- `frontend-builder` - Port 4208
- `frontend-compliance` - Port 4210
- `frontend-ems` - Port 4211
- `frontend-forms` - Port 4212
- `frontend-inventory` - Port 4215
- `frontend-scm` - Port 4216
- `frontend-support` - Port 4217
- `frontend-vouchers` - Port 4218
- `frontend-mobile` - Port 4219

#### Managing Frontend Applications

```bash
# Start all frontend apps
./start-frontend-pm2.sh

# Stop all frontend apps
./stop-frontend-pm2.sh

# Restart all frontend apps
pm2 restart ecosystem.frontend.config.js

# View frontend logs
pm2 logs frontend-admin
pm2 logs frontend-marketing

# Stop specific app
pm2 stop frontend-admin

# Start specific app
pm2 start ecosystem.frontend.config.js --only frontend-admin
```

---

## Configuration Files

### Backend Configuration
**File:** `ecosystem.backend.config.js`

Contains configuration for all 28 backend microservices including:
- Service name and script
- Working directory
- Memory limits
- Environment variables
- Database URLs
- Log file paths
- Auto-restart settings

### Frontend Configuration
**File:** `ecosystem.frontend.config.js`

Contains configuration for all 17 frontend applications including:
- Application name and script
- Working directory
- Memory limits
- Port numbers
- Gateway URLs
- Log file paths
- Auto-restart settings

---

## Common Commands

### NPM Scripts (Recommended)

```bash
# Start all services
npm run pm2:start:all

# Start backend only
npm run pm2:start:backend

# Start frontend only
npm run pm2:start:frontend

# Stop all services
npm run pm2:stop:all

# Stop backend
npm run pm2:stop:backend

# Stop frontend
npm run pm2:stop:frontend

# Restart backend
npm run pm2:restart:backend

# Restart frontend
npm run pm2:restart:frontend

# View status
npm run pm2:status

# View logs
npm run pm2:logs

# Open monitoring dashboard
npm run pm2:monit
```

### PM2 Direct Commands

```bash
# View all running processes
pm2 status

# View logs for all processes
pm2 logs

# View logs for specific service
pm2 logs api-gateway
pm2 logs frontend-admin

# Real-time monitoring dashboard
pm2 monit

# Restart a service
pm2 restart api-gateway

# Stop a service
pm2 stop api-gateway

# Delete a service
pm2 delete api-gateway

# Restart all services
pm2 restart all

# Stop all services
pm2 stop all

# Delete all services
pm2 delete all

# Save current PM2 process list
pm2 save

# Restore saved process list
pm2 resurrect

# Generate startup script (run on system boot)
pm2 startup
```

---

## Monitoring

### View Status

```bash
# View all services status
pm2 status

# JSON format
pm2 jlist
```

### View Logs

```bash
# All logs (real-time)
pm2 logs

# Specific service logs
pm2 logs api-gateway

# Backend logs only
pm2 logs --only api-gateway,identity-service,access-service

# Frontend logs only
pm2 logs --only frontend-admin,frontend-marketing

# Last 100 lines
pm2 logs --lines 100

# Clear logs
pm2 flush
```

### Log Files

Logs are stored in `.logs` directory:

```
.logs/
├── backend/
│   ├── api-gateway-error.log
│   ├── api-gateway-out.log
│   ├── identity-service-error.log
│   ├── identity-service-out.log
│   └── ...
└── frontend/
    ├── frontend-admin-error.log
    ├── frontend-admin-out.log
    ├── frontend-marketing-error.log
    ├── frontend-marketing-out.log
    └── ...
```

### Monitoring Dashboard

```bash
# Interactive monitoring dashboard
pm2 monit

# Key features:
# - Real-time CPU usage
# - Real-time memory usage
# - Process logs
# - Custom metrics
```

### Web Dashboard (Optional)

```bash
# Install PM2 Plus for web monitoring
pm2 plus

# Or use PM2 Web (free)
pm2-runtime ecosystem.backend.config.js --web
```

---

## Troubleshooting

### Services Won't Start

1. **Check if ports are already in use:**
```bash
npm run check:ports
# or
lsof -i :3010,4001,4002,5200,5210
```

2. **Check if dependencies are installed:**
```bash
# Backend
cd backend && npm install --legacy-peer-deps

# Frontend
cd frontend && npm install
```

3. **Check PostgreSQL connection:**
```bash
psql -U postgres -d hrmssystem -c "SELECT NOW();"
```

### High Memory Usage

```bash
# View memory usage
pm2 status

# Restart service with high memory
pm2 restart <service-name>

# Adjust memory limits in ecosystem.*.config.js
# Change: max_memory_restart: '500M'
```

### Services Keep Restarting

```bash
# View logs to identify errors
pm2 logs <service-name>

# Check error logs
tail -f .logs/backend/<service-name>-error.log

# Disable auto-restart temporarily
pm2 stop <service-name>
pm2 start <service-name> --no-autorestart
```

### PM2 Not Found

```bash
# Install PM2 globally
npm install -g pm2

# Verify installation
pm2 --version
```

### Permission Issues

```bash
# Make scripts executable
chmod +x *.sh

# Check file permissions
ls -la *.sh
```

### Clear Everything and Restart

```bash
# Stop all PM2 processes
pm2 delete all
pm2 kill

# Clean dependencies
npm run clean

# Reinstall dependencies
npm run install:all

# Start fresh
npm run pm2:start:all
```

---

## Performance Tips

### 1. Optimize Memory Usage

```javascript
// In ecosystem.*.config.js
max_memory_restart: '500M'  // Adjust based on service needs
```

### 2. Use Cluster Mode (for production)

```javascript
// In ecosystem.*.config.js
instances: 2,  // Run 2 instances
exec_mode: 'cluster',
```

### 3. Enable Watch Mode (development)

```javascript
// In ecosystem.*.config.js
watch: true,
ignore_watch: ['node_modules', 'logs'],
```

### 4. Log Rotation

```bash
# Install PM2 log rotate
pm2 install pm2-logrotate

# Configure
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 7
```

---

## Auto-Start on System Boot

```bash
# Generate startup script
pm2 startup

# Start your services
npm run pm2:start:all

# Save current process list
pm2 save

# Now PM2 will auto-start on system reboot
```

---

## Comparison: PM2 vs Docker

| Feature | PM2 | Docker |
|---------|-----|--------|
| Startup Speed | ⚡ Fast (5-10s) | 🐢 Slower (30-60s) |
| Memory Usage | ✅ Lower | ⚠️ Higher |
| Hot Reload | ✅ Built-in | ❌ Requires rebuild |
| Resource Isolation | ⚠️ Process-level | ✅ Container-level |
| Production Ready | ✅ Yes | ✅ Yes |
| Development | ✅ Excellent | ⚠️ Good |
| Monitoring | ✅ Built-in | ⚠️ Requires tools |

---

## Summary

PM2 provides a powerful, efficient way to manage all backend and frontend services:

✅ **Faster** startup than Docker  
✅ **Lower** memory usage  
✅ **Built-in** monitoring and logging  
✅ **Easy** management with npm scripts  
✅ **Production-ready** process management  

For development and production environments, PM2 is an excellent alternative to Docker containerization.

---

## Need Help?

- PM2 Documentation: https://pm2.keymetrics.io/docs/usage/quick-start/
- View service status: `pm2 status`
- View logs: `pm2 logs`
- Open monitoring: `pm2 monit`
- Check ports: `npm run check:ports`

---

**Happy Coding! 🚀**


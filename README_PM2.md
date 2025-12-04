# 🚀 HRMS Platform - PM2 Process Management

This project now supports **PM2** as an alternative to Docker for running all backend and frontend services.

## 📋 Table of Contents

- [Why PM2?](#why-pm2)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Service Architecture](#service-architecture)
- [Common Commands](#common-commands)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Why PM2?

PM2 offers several advantages over Docker for development:

| Feature | PM2 | Docker |
|---------|-----|--------|
| **Startup Speed** | ⚡ 5-10 seconds | 🐢 30-60 seconds |
| **Memory Usage** | ✅ 2-3 GB | ⚠️ 4-6 GB |
| **Hot Reload** | ✅ Instant | ❌ Requires rebuild |
| **Monitoring** | ✅ Built-in | ⚠️ Requires setup |
| **Development** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |

---

## 🚀 Quick Start

### Prerequisites

```bash
# Install PM2 globally
npm install -g pm2

# Verify installation
pm2 --version
```

### Start All Services

```bash
# Option 1: Using npm script (recommended)
npm run pm2:start:all

# Option 2: Using shell script
./start-all-pm2.sh

# Option 3: Start separately
npm run pm2:start:backend   # Start backend (28 services)
npm run pm2:start:frontend  # Start frontend (17 apps)
```

### Monitor Services

```bash
# View status
npm run pm2:status

# View logs
npm run pm2:logs

# Interactive monitoring
npm run pm2:monit
```

### Stop Services

```bash
# Stop all
npm run pm2:stop:all

# Stop separately
npm run pm2:stop:backend
npm run pm2:stop:frontend
```

---

## 📚 Documentation

Comprehensive documentation is available:

1. **[PM2_SETUP_SUMMARY.md](./PM2_SETUP_SUMMARY.md)** - Complete setup overview
2. **[PM2_GUIDE.md](./PM2_GUIDE.md)** - Detailed guide with troubleshooting
3. **[PM2_QUICK_REFERENCE.md](./PM2_QUICK_REFERENCE.md)** - Quick command reference

---

## 🏗️ Service Architecture

### Backend Services (28 Total)

**Critical Services** (Start First)
- `api-gateway` (Port 3010) - API Gateway
- `identity-service` (Port 4001) - Authentication
- `access-service` (Port 4002) - Authorization
- `tenant-service` (Port 4023) - Multi-tenancy

**Core Services**
- `admin-service`, `media-service`, `contacts-service`
- `notifications-service`, `audit-service`

**Business Services**
- `billing-service`, `hrms-service`, `analytics-service`
- `crm-service`, `ai-service`, `payroll-service`
- `subscriptions-service`, `entitlements-service`
- `compliance-service`, `ems-service`, `facilities-service`
- And 13 more...

### Frontend Applications (17 Total)

- `frontend-admin` (Port 5210) - Admin Portal
- `frontend-marketing` (Port 5200) - Marketing Website
- `frontend-console` (Port 5201) - Console Dashboard
- Plus 14 more specialized apps

---

## ⚡ Common Commands

### NPM Scripts (Recommended)

```bash
# Start
npm run pm2:start:all          # Start everything
npm run pm2:start:backend      # Backend only
npm run pm2:start:frontend     # Frontend only

# Stop
npm run pm2:stop:all           # Stop everything
npm run pm2:stop:backend       # Backend only
npm run pm2:stop:frontend      # Frontend only

# Restart
npm run pm2:restart:backend    # Restart backend
npm run pm2:restart:frontend   # Restart frontend

# Monitor
npm run pm2:status             # View status
npm run pm2:logs               # View logs
npm run pm2:monit              # Interactive monitor

# Logs
npm run pm2:logs:gateway       # API Gateway logs
npm run pm2:logs:admin         # Admin Portal logs
npm run logs:backend           # All backend logs
npm run logs:frontend          # All frontend logs
```

### Direct PM2 Commands

```bash
# Status
pm2 status                     # List all processes
pm2 info api-gateway           # Detailed info

# Logs
pm2 logs                       # All logs
pm2 logs api-gateway           # Specific service
pm2 logs --lines 100           # Last 100 lines
pm2 flush                      # Clear logs

# Control
pm2 restart api-gateway        # Restart service
pm2 stop api-gateway           # Stop service
pm2 delete api-gateway         # Delete service
pm2 reload api-gateway         # 0-downtime reload

# Management
pm2 save                       # Save process list
pm2 resurrect                  # Restore saved list
pm2 startup                    # Auto-start on boot
```

---

## 🌐 Access URLs

### Backend
- **API Gateway**: http://localhost:3010
- **Identity Service**: http://localhost:4001
- **Access Service**: http://localhost:4002

### Frontend
- **Admin Portal**: http://localhost:5210
- **Marketing**: http://localhost:5200
- **Console**: http://localhost:5201

---

## 🔧 Configuration Files

### PM2 Configurations
- `ecosystem.backend.config.js` - Backend services (28)
- `ecosystem.frontend.config.js` - Frontend apps (17)
- `ecosystem.config.js` - Original combined config

### Shell Scripts
- `start-all-pm2.sh` - Start all services
- `start-backend-pm2.sh` - Start backend only
- `start-frontend-pm2.sh` - Start frontend only
- `stop-all-pm2.sh` - Stop all services
- `stop-backend-pm2.sh` - Stop backend only
- `stop-frontend-pm2.sh` - Stop frontend only

---

## 📁 Log Files

Logs are organized in `.logs` directory:

```
.logs/
├── backend/
│   ├── api-gateway-error.log
│   ├── api-gateway-out.log
│   └── ... (all backend services)
└── frontend/
    ├── frontend-admin-error.log
    ├── frontend-admin-out.log
    └── ... (all frontend apps)
```

---

## 🆘 Troubleshooting

### Services Won't Start

```bash
# Check if ports are in use
npm run check:ports

# Kill existing processes
npm run kill:all

# Try starting again
npm run pm2:start:all
```

### View Error Logs

```bash
# All errors
pm2 logs --err

# Specific service
pm2 logs api-gateway --err

# Or check log files
tail -f .logs/backend/api-gateway-error.log
```

### High Memory Usage

```bash
# Monitor resources
pm2 monit

# Restart service
pm2 restart <service-name>
```

### Clean Restart

```bash
# Stop all PM2 processes
pm2 delete all
pm2 kill

# Clean logs
rm -rf .logs

# Restart
npm run pm2:start:all
```

### Database Connection Issues

```bash
# Check PostgreSQL
psql -U postgres -c "SELECT version();"

# Test connection
psql -U postgres -d hrmssystem -c "SELECT NOW();"
```

---

## 💡 Best Practices

1. **Use npm scripts** - More convenient than direct PM2 commands
2. **Monitor regularly** - Use `pm2 monit` to watch resources
3. **Check logs** - Use `pm2 logs` to catch issues early
4. **Save configuration** - Run `pm2 save` after changes
5. **Setup auto-start** - Run `pm2 startup` for production

---

## 🔄 Comparison: PM2 vs Docker

### When to Use PM2
✅ Local development  
✅ Quick iterations  
✅ Resource-constrained machines  
✅ Need hot reload  
✅ Want built-in monitoring  

### When to Use Docker
✅ Production deployments  
✅ Need strict isolation  
✅ Multi-environment consistency  
✅ Container orchestration (K8s)  
✅ Complex networking requirements  

---

## 📖 Additional Resources

- **PM2 Documentation**: https://pm2.keymetrics.io/docs/
- **Setup Summary**: [PM2_SETUP_SUMMARY.md](./PM2_SETUP_SUMMARY.md)
- **Full Guide**: [PM2_GUIDE.md](./PM2_GUIDE.md)
- **Quick Reference**: [PM2_QUICK_REFERENCE.md](./PM2_QUICK_REFERENCE.md)

---

## 🎉 Summary

You now have a complete PM2 setup for running all HRMS platform services:

- ✅ **28 Backend Services** - All microservices
- ✅ **17 Frontend Apps** - All Next.js applications
- ✅ **Separate Scripts** - Backend and Frontend management
- ✅ **Comprehensive Docs** - Complete guides and references
- ✅ **Easy Commands** - Simple npm scripts
- ✅ **Built-in Monitoring** - PM2 dashboard and logs

### Get Started Now!

```bash
# Install PM2
npm install -g pm2

# Start everything
npm run pm2:start:all

# Monitor
npm run pm2:monit
```

---

**Happy Coding! 🚀**

For detailed documentation, see [PM2_GUIDE.md](./PM2_GUIDE.md)


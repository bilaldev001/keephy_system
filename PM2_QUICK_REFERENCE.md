# PM2 Quick Reference Card

Quick commands for managing Frontend and Backend services with PM2.

## 🚀 Start Services

```bash
# Start everything
npm run pm2:start:all          # All services (BE + FE)
npm run pm2:start:backend      # Backend only (28 services)
npm run pm2:start:frontend     # Frontend only (17 apps)

# Alternative
./start-all-pm2.sh
./start-backend-pm2.sh
./start-frontend-pm2.sh
```

## 🛑 Stop Services

```bash
# Stop everything
npm run pm2:stop:all           # All services
npm run pm2:stop:backend       # Backend only
npm run pm2:stop:frontend      # Frontend only

# Alternative
./stop-all-pm2.sh
./stop-backend-pm2.sh
./stop-frontend-pm2.sh
```

## 🔄 Restart Services

```bash
npm run pm2:restart:backend    # Restart backend
npm run pm2:restart:frontend   # Restart frontend

# Or restart specific service
pm2 restart api-gateway
pm2 restart frontend-admin
```

## 👀 Monitor Services

```bash
npm run pm2:status             # View status
npm run pm2:logs               # View all logs
npm run pm2:logs:gateway       # API Gateway logs
npm run pm2:logs:admin         # Admin Portal logs
npm run pm2:monit              # Interactive dashboard
```

## 📊 Service Status

```bash
pm2 status                     # List all processes
pm2 info api-gateway           # Detailed info
pm2 monit                      # Real-time monitor
```

## 📝 View Logs

```bash
# All logs
pm2 logs

# Specific service
pm2 logs api-gateway
pm2 logs frontend-admin

# Last N lines
pm2 logs --lines 100

# Clear logs
pm2 flush
```

## 🔧 Manage Individual Services

```bash
# Restart
pm2 restart <service-name>

# Stop
pm2 stop <service-name>

# Start
pm2 start ecosystem.backend.config.js --only <service-name>

# Delete
pm2 delete <service-name>

# Reload (0-downtime)
pm2 reload <service-name>
```

## 🌐 Key URLs

### Backend
- API Gateway: http://localhost:3010
- Identity Service: http://localhost:4001
- Access Service: http://localhost:4002

### Frontend
- Admin Portal: http://localhost:5210
- Marketing: http://localhost:5200
- Console: http://localhost:5201

## 🆘 Troubleshooting

```bash
# Check ports
npm run check:ports

# Kill all processes
npm run kill:all

# Clean and restart
pm2 delete all
pm2 kill
npm run pm2:start:all

# View error logs
tail -f .logs/backend/*-error.log
tail -f .logs/frontend/*-error.log
```

## 💾 Save/Restore

```bash
# Save current state
pm2 save

# Restore saved state
pm2 resurrect

# Auto-start on boot
pm2 startup
pm2 save
```

## 🧹 Clean Up

```bash
# Delete all processes
pm2 delete all

# Kill PM2 daemon
pm2 kill

# Clean logs and cache
npm run clean:pm2
```

## 📦 Installation

```bash
# Install PM2
npm install -g pm2

# Install dependencies
npm run install:all
npm run install:backend
npm run install:frontend
```

## ⚙️ Configuration Files

- `ecosystem.backend.config.js` - Backend services (28)
- `ecosystem.frontend.config.js` - Frontend apps (17)
- `ecosystem.config.js` - Original (all services)

## 📁 Log Locations

```
.logs/
├── backend/
│   ├── api-gateway-error.log
│   ├── api-gateway-out.log
│   └── ...
└── frontend/
    ├── frontend-admin-error.log
    ├── frontend-admin-out.log
    └── ...
```

## ⚡ Performance

```bash
# View resource usage
pm2 status
pm2 monit

# Restart high-memory service
pm2 restart <service-name>
```

## 🔐 Environment

Backend services use:
- Database: PostgreSQL (localhost:5432)
- Database Name: hrmssystem
- User: postgres
- Password: postgres

## 📚 Full Documentation

See `PM2_GUIDE.md` for complete documentation.

---

**Pro Tips:**
- Use `pm2 monit` for real-time monitoring
- Use `pm2 logs` to debug issues
- Use `pm2 save` to persist configuration
- Use `pm2 startup` for auto-start on boot

🚀 Happy coding!


# PM2 Setup Complete ✅

PM2 has been successfully configured and is managing all backend services and frontend applications.

## Quick Start

```bash
# Start all critical services
npm run pm2:start:critical

# Start all services
npm run pm2:start

# View status
npm run pm2:status

# View logs
npm run pm2:logs

# Stop all
npm run pm2:stop:all
```

## Current Status

All critical services are running via PM2:

✅ **API Gateway** - Port 4000  
✅ **Identity Service** - Port 4001  
✅ **Access Service** - Port 4002  
✅ **Admin Service** - Port 4028  
✅ **Admin Frontend** - Port 4205  

## Key URLs

- **Admin Dashboard**: http://localhost:4205
- **API Gateway**: http://localhost:4000
- **Identity Service**: http://localhost:4001
- **Access Service**: http://localhost:4002
- **Admin Service**: http://localhost:4028

## Database Connection

✅ PostgreSQL connection configured:
- **Host**: localhost
- **Port**: 5432
- **Database**: hrmssystem
- **Username**: postgres
- **Password**: postgres
- **Connection String**: `postgresql://postgres:postgres@localhost:5432/hrmssystem`

## PM2 Commands

### Start Services
```bash
npm run pm2:start              # All services
npm run pm2:start:critical     # Critical only
npm run pm2:start:backend      # Backend only
npm run pm2:start:frontend     # Frontend only
```

### Stop Services
```bash
npm run pm2:stop               # Stop ecosystem
npm run pm2:stop:all           # Stop all PM2 processes
```

### Restart Services
```bash
npm run pm2:restart            # Restart ecosystem
npm run pm2:restart:all        # Restart all
```

### Monitoring
```bash
npm run pm2:status             # Show status
npm run pm2:logs               # View all logs
npm run pm2:logs:admin         # Admin frontend logs
npm run pm2:logs:gateway       # API gateway logs
npm run pm2:monit              # Interactive dashboard
```

### Persistence
```bash
npm run pm2:save               # Save current list
npm run pm2:startup            # Setup auto-start on boot
```

## Files Created

1. **`ecosystem.config.js`** - PM2 ecosystem configuration with all services
2. **`scripts/pm2-setup.sh`** - Helper script for PM2 operations
3. **`scripts/PM2-GUIDE.md`** - Comprehensive PM2 documentation
4. **`.env` files** - Created for all backend services with database connection
5. **`.env.local`** - Created for frontend/admin

## Environment Variables

All services now have `.env` files with:
- Database connection string
- Service-specific ports
- Service URLs (for API Gateway)

## Logs Location

All logs are saved to:
- **Backend**: `backend/services/{service-name}/.logs/`
- **Frontend**: `frontend/{app-name}/.logs/`
- **PM2**: `~/.pm2/logs/`

View logs:
```bash
# PM2 logs (recommended)
npm run pm2:logs

# Direct file logs
tail -f backend/services/admin-service/.logs/admin-service-out.log
tail -f frontend/admin/.logs/frontend-admin-out.log
```

## Next Steps

1. **Access Admin Dashboard**: http://localhost:4205
2. **Monitor Services**: `npm run pm2:monit`
3. **View Logs**: `npm run pm2:logs`
4. **Setup Auto-Start**: `npm run pm2:startup` then `npm run pm2:save`

## Troubleshooting

### Service Not Starting
```bash
pm2 logs <service-name>        # Check logs
pm2 describe <service-name>    # Detailed info
pm2 restart <service-name>     # Restart
```

### Port Conflicts
```bash
lsof -i :<port>                # Check what's using port
pm2 delete <service-name>      # Remove from PM2
# Then fix port conflict and restart
```

### Database Connection Issues
- Verify PostgreSQL is running: `pg_isready`
- Check `.env` files have correct DATABASE_URL
- Restart affected services: `pm2 restart <service-name>`

### Frontend Build Issues
```bash
cd frontend/packages/i18n && npm run build
cd frontend/packages/web-core && npm run build
pm2 restart frontend-admin
```

## Useful Commands Summary

```bash
# Quick status check
pm2 status

# View all logs
pm2 logs

# Restart everything
pm2 restart all

# Stop everything
pm2 stop all

# Delete everything
pm2 delete all
pm2 kill

# Monitor resources
pm2 monit
```

## System is Ready! 🚀

Your HRMS system is now running with PM2 process management. All services are:
- ✅ Automatically restarted on crash
- ✅ Logged to separate files
- ✅ Monitored for resource usage
- ✅ Managed with a single command
- ✅ Connected to PostgreSQL database

For more details, see `scripts/PM2-GUIDE.md`


# Keephy Platform - Setup Guide for New Developers

## 🚀 Quick Start (5 minutes)

### Prerequisites

- Node.js v18+ and npm
- PostgreSQL database running
- PM2 installed globally: `npm install -g pm2`

### 1. Clone & Install

```bash
# Clone the repository
git clone <repository-url>
cd hrms-develop-postgres

# Install all dependencies (backend + frontend)
npm install --legacy-peer-deps
```

### 2. Configure Environment

Copy the example environment file and configure it:

```bash
# Backend services
cp backend/.env.example backend/.env

# Edit backend/.env and set:
# - DATABASE_URL=postgresql://user:password@localhost:5432/keephy_db
# - JWT_ACCESS_SECRET=your-secret-key
# - JWT_REFRESH_SECRET=your-refresh-secret
# - STRIPE_SECRET_KEY=your-stripe-key (if using billing)
```

### 3. Start Services

```bash
# Start all backend services
npm run pm2:start:backend

# Start all frontend applications
npm run pm2:start:frontend

# Or start everything at once
npm run pm2:start:all
```

### 4. Verify Services

```bash
# Check all services are running
pm2 status

# All services should show status: "online"
```

### 5. Access Applications

- **Console:** http://localhost:3076
- **Admin:** http://localhost:3078
- **Marketing:** http://localhost:3079
- **API Gateway:** http://localhost:3010

---

## 🔧 Detailed Setup

### Database Setup

#### Option A: Using Docker (Recommended)

```bash
# Start PostgreSQL container
docker run -d \
  --name keephy-postgres \
  -e POSTGRES_PASSWORD=keephy123 \
  -e POSTGRES_USER=keephy \
  -e POSTGRES_DB=keephy_db \
  -p 5432:5432 \
  postgres:15

# DATABASE_URL will be: postgresql://keephy:keephy123@localhost:5432/keephy_db
```

#### Option B: Local PostgreSQL

```bash
# Create database
createdb keephy_db

# DATABASE_URL will be: postgresql://localhost:5432/keephy_db
```

### Database Migrations

**Important:** Migrations run automatically when backend services start!

#### Automatic Migration (Recommended)

When you start any backend service for the first time, migrations will run automatically. You'll see logs like:

```
query: SELECT * FROM "migrations" ORDER BY "id" DESC
query: ALTER TABLE businesses ADD COLUMN IF NOT EXISTS tax_id VARCHAR(100)
✅ Ensured tax_id column exists in businesses table
```

#### Manual Migration (If Needed)

If automatic migrations don't run or you need to run them manually:

```bash
# For tenant-service specifically
cd backend/services/tenant-service
npm run migration:run

# For other services, repeat for each:
cd backend/services/identity-service
# (if migration scripts exist in their package.json)
```

### Common Issues & Solutions

#### Issue 1: "column does not exist" Error

**Symptoms:**
- API returns 500 error
- Error message: `column "tax_id" does not exist`

**Solution:**
```bash
# Restart the service to trigger migrations
pm2 restart tenant-service

# Wait 10 seconds for migration to complete
sleep 10

# Verify service is online
pm2 status tenant-service
```

#### Issue 2: "owner_id violates not-null constraint"

**Symptoms:**
- API returns 500 error during onboarding
- Error message: `null value in column "owner_id"`

**Solution:**
This happens when the `x-user-id` header is missing. It's now fixed in the codebase. If you still see this:

1. Clear browser cache and localStorage
2. Log out and log back in
3. Try the operation again

The axios interceptor will now automatically add the `x-user-id` header.

#### Issue 3: Port Already in Use

**Symptoms:**
- Service fails to start
- Error: `EADDRINUSE: address already in use`

**Solution:**
```bash
# Check what's using the port (example: 3010)
lsof -ti:3010 | xargs kill -9

# Or restart all PM2 services
pm2 restart all
```

#### Issue 4: Service Won't Start

**Symptoms:**
- Service shows "stopped" or "errored" status
- Constant restarts

**Solution:**
```bash
# Check service logs
pm2 logs <service-name> --lines 50

# Common fixes:
# 1. Check DATABASE_URL is correct
# 2. Check database is running
# 3. Check no port conflicts
# 4. Reinstall dependencies
cd backend
npm install --legacy-peer-deps
```

---

## 📦 Service Architecture

### Backend Services (Port Range: 3010-3050)

| Service | Port | Purpose |
|---------|------|---------|
| api-gateway | 3010 | API Gateway / Proxy |
| identity-service | 3012 | Authentication & Users |
| access-service | 3014 | Permissions & Roles |
| tenant-service | 3016 | Organizations/Brands/Businesses |
| media-service | 3018 | File Uploads |
| notifications-service | 3020 | Emails & Push Notifications |
| contacts-service | 3022 | Contact Management |
| audit-service | 3024 | Audit Logs |
| subscriptions-service | 3026 | Subscription Management |
| hrms-service | 3036 | HR Management |
| crm-service | 3037 | Customer Relationship |
| *...and more...* | | |

### Frontend Applications (Port Range: 3076-3095)

| Application | Port | Purpose |
|-------------|------|---------|
| frontend-console | 3076 | Main Console UI |
| frontend-admin | 3078 | Admin Dashboard |
| frontend-marketing | 3079 | Marketing Pages |
| frontend-analytics | 3080 | Analytics Dashboard |
| frontend-billing | 3081 | Billing Management |
| frontend-hrms | 3082 | HR Management UI |
| *...and more...* | | |

---

## 🧪 Development Workflow

### Starting Development

```bash
# Start all services
npm run pm2:start:all

# Or start individually
npm run pm2:start:backend    # All backend services
npm run pm2:start:frontend   # All frontend apps
```

### Monitoring Services

```bash
# View all running services
pm2 status

# View logs for a specific service
pm2 logs identity-service

# View logs for all services
pm2 logs

# Monitor CPU/Memory
pm2 monit
```

### Stopping Services

```bash
# Stop all services
npm run pm2:stop:all

# Or stop individually
npm run pm2:stop:backend
npm run pm2:stop:frontend

# Stop specific service
pm2 stop tenant-service
```

### Restarting After Code Changes

```bash
# Backend services automatically restart with ts-node-dev
# Just save your file and wait ~3 seconds

# Frontend Next.js apps have hot reload
# Just save your file - no restart needed

# For configuration changes, restart manually:
pm2 restart <service-name>
```

---

## 📝 Important Notes

### Authentication Flow

1. **Register:** POST `/auth/register` → Returns tokens + onboarding status
2. **Onboarding:** Multi-step flow (Organization → Brand → Business → Franchise)
3. **Login:** POST `/auth/login` → Returns tokens
4. **Session:** GET `/auth/session` → Returns user + tenant info

### Multi-Tenancy

- Every entity (Contact, Employee, etc.) has `tenantId`, `organizationId`, `brandId`, `businessId`, `franchiseId`
- Isolation is enforced by combining these IDs
- Organization contacts: Only `tenantId` + `organizationId`
- Business contacts: `tenantId` + `organizationId` + `brandId` + `businessId`
- This prevents data leakage between entities

### Team Members (Admins/Managers)

When creating entities during onboarding, you can include admins and managers:

```typescript
POST /onboarding/business
{
  "name": "My Business",
  "primaryEmail": "owner@example.com",
  "admins": [
    { "name": "John Doe", "email": "john@example.com", "phone": "+1234567890" }
  ],
  "managers": [
    { "name": "Jane Smith", "email": "jane@example.com", "phone": "+0987654321" }
  ]
}
```

The system will:
- Create contacts in the Contacts service (with proper isolation)
- Create users with password "Keephy123" if they don't exist
- Create employees for managers in the HRMS service
- Send inherited permissions to child entities

---

## 🐛 Debugging

### Check Service Health

```bash
# Check if service is responding
curl http://localhost:3016/onboarding/health

# Should return: {"status":"ok","service":"tenant-onboarding"}
```

### Check Database Connection

```bash
# Connect to PostgreSQL
psql -h localhost -U keephy -d keephy_db

# Check if tables exist
\dt

# Check specific table structure
\d businesses

# Should show tax_id column if migration ran
```

### Common Database Issues

```sql
-- Check which migrations have run
SELECT * FROM migrations ORDER BY timestamp;

-- Check if tax_id column exists in businesses table
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'businesses' AND column_name = 'tax_id';

-- If column doesn't exist, you need to run migrations
-- Restart tenant-service: pm2 restart tenant-service
```

---

## 📚 Additional Resources

- **PM2 Guide:** See `PM2_GUIDE.md`
- **Port Mapping:** See `PORT_MAPPING.md`
- **Migrations Guide:** See `backend/services/tenant-service/MIGRATIONS.md`
- **Coding Standards:** See `.cursor/rules/CODING_STANDARDS.md`

---

## 🆘 Getting Help

If you're stuck:

1. Check this guide first
2. Review service logs: `pm2 logs <service-name>`
3. Check the database: `psql ...`
4. Ask the team on Slack/Discord
5. Create an issue on GitHub

---

## ✅ Post-Setup Checklist

- [ ] All backend services showing "online" status
- [ ] All frontend apps showing "online" status
- [ ] Can access http://localhost:3076/login
- [ ] Can register a new user
- [ ] Can complete onboarding flow
- [ ] Can access dashboard after onboarding
- [ ] Database has all required tables and columns
- [ ] No errors in `pm2 logs`

**Congratulations! Your Keephy Platform is ready for development! 🎉**


# Keephy Platform - Enterprise Management System

> **Modern, scalable, multi-tenant platform for managing organizations, HR, CRM, and more.**

---

## 🚀 Quick Start (5 Minutes)

```bash
# 1. Install dependencies
npm install --legacy-peer-deps

# 2. Setup database (automated)
./setup-database.sh

# 3. Start all services
npm run pm2:start:all

# 4. Access the platform
open http://localhost:3076
```

**That's it!** The platform is ready to use. 🎉

---

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get running in 4 steps
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete setup guide with troubleshooting
- **[ENTITY_MANAGEMENT_GUIDE.md](ENTITY_MANAGEMENT_GUIDE.md)** - Managing organizations, brands, businesses, franchises
- **[ONBOARDING_IMPLEMENTATION.md](ONBOARDING_IMPLEMENTATION.md)** - Technical implementation details
- **[PM2_GUIDE.md](PM2_GUIDE.md)** - Process management with PM2
- **[DATABASE_FIX_REQUIRED.md](DATABASE_FIX_REQUIRED.md)** - Manual database fixes (if automated setup fails)

---

## 🏗️ Architecture

### Backend Microservices (Node.js + NestJS)

- **API Gateway** (3010) - Routes requests to services
- **Identity Service** (3012) - Authentication & users
- **Tenant Service** (3016) - Organizations, brands, businesses, franchises
- **Contacts Service** (3022) - Contact management
- **HRMS Service** (3036) - HR & employee management
- **Media Service** (3018) - File uploads
- **+ 20 more services...**

### Frontend Applications (Next.js + React)

- **Console** (3076) - Main management interface
- **Admin** (3078) - Admin dashboard
- **HRMS** (3082) - HR management UI
- **CRM** (3090) - Customer relationship UI
- **+ 12 more apps...**

---

## ✨ Key Features

### Multi-Tenant Architecture
- Organizations → Brands → Businesses → Franchises
- Complete data isolation between tenants
- Hierarchical permissions

### Onboarding Flow
- 4-step guided setup
- Team member management (admins & managers)
- Automatic user creation with default passwords
- Skip optional steps (org & brand)

### Entity Management
- Full CRUD for all entities
- Search & filter
- Hierarchical dropdowns
- Responsive design

### Authentication & Authorization
- JWT-based authentication
- Role-based access control
- Session management
- Password reset flow

---

## 🛠️ Development

### Starting Services

```bash
# Start all
npm run pm2:start:all

# Or individually
npm run pm2:start:backend    # All backend services
npm run pm2:start:frontend   # All frontend apps
```

### Monitoring

```bash
# View all services
pm2 status

# View logs
pm2 logs <service-name>

# Monitor resources
pm2 monit
```

### Stopping Services

```bash
# Stop all
npm run pm2:stop:all

# Stop specific
pm2 stop <service-name>
```

---

## 🧪 Testing

### Automated API Testing

```bash
# Test all CRUD APIs
./test-entity-apis.sh

# This will:
# - Register a test user
# - Create organization, brand, business, franchise
# - Verify all CRUD operations work
# - Show detailed results
```

### Manual Testing

1. Register: http://localhost:3076/register
2. Complete onboarding
3. Access entity pages:
   - http://localhost:3076/organizations
   - http://localhost:3076/brands
   - http://localhost:3076/businesses
   - http://localhost:3076/franchises

---

## 🗄️ Database

### Automated Setup

```bash
./setup-database.sh
```

This script:
- Tests database connection
- Adds missing columns
- Fixes constraints
- Verifies schema
- Shows detailed results

### Manual Setup

If automated setup fails, see [DATABASE_FIX_REQUIRED.md](DATABASE_FIX_REQUIRED.md) for manual SQL commands.

---

## 📦 Tech Stack

**Backend:**
- Node.js 20+
- NestJS
- TypeORM
- PostgreSQL
- PM2

**Frontend:**
- Next.js 14
- React 18
- TypeScript
- TailwindCSS
- @keephy/ui-core

**Infrastructure:**
- PM2 for process management
- JWT for authentication
- Axios for HTTP clients
- Microservices architecture

---

## 🔐 Security

- JWT tokens with refresh mechanism
- Password hashing with bcrypt
- CORS configured on all services
- Multi-tenant data isolation
- Role-based access control

---

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check status
pm2 status

# Check logs
pm2 logs <service-name>

# Restart
pm2 restart all
```

### Database Errors

```bash
# Run database setup
./setup-database.sh

# If that fails, see DATABASE_FIX_REQUIRED.md
```

### Port Conflicts

```bash
# Kill process on port
lsof -ti:3010 | xargs kill -9

# Or restart all
pm2 restart all
```

---

## 📞 Support

- **Documentation:** See docs folder
- **Issues:** Create GitHub issue
- **Team:** Contact on Slack/Discord

---

## 📄 License

Proprietary - Keephy Platform

---

**Built with ❤️ by the Keephy Team**

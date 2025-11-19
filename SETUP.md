# Keephy Platform - Setup Guide

This guide will help you set up the complete Keephy Platform development environment.

## 📋 Prerequisites

- **Node.js**: Version 18 or higher
- **PostgreSQL**: Version 14 or higher
- **Git**: Latest version
- **npm** or **yarn**: Package manager
- **PM2** (optional): For process management (`npm install -g pm2`)

## 🚀 Quick Setup

### Step 1: Clone the Orchestrator Repository

```bash
git clone <orchestrator-repo-url> keephy-platform
cd keephy-platform
```

### Step 2: Clone Frontend and Backend Repositories

Since frontend and backend are in separate repositories, you have two options:

#### Option A: Clone as Separate Directories (Recommended)

```bash
# Clone frontend repository
git clone git@github.com:bilaldev001/keephy_frontend_system.git frontend

# Clone backend repository
git clone git@github.com:bilaldev001/keephy_backend_system.git backend
```

#### Option B: Use Git Submodules

If the orchestrator repo uses submodules:

```bash
# Initialize and update submodules
git submodule update --init --recursive
```

### Step 3: Install Dependencies

```bash
# Install root dependencies (orchestrator tools)
npm install

# Install backend dependencies
cd backend
npm install --legacy-peer-deps
cd ..

# Install frontend dependencies
cd frontend
npm install
cd ..
```

Or use the convenience script:

```bash
npm run install:all
```

### Step 4: Set Up PostgreSQL

#### macOS (using Homebrew)

```bash
# Install PostgreSQL
brew install postgresql@14

# Start PostgreSQL service
brew services start postgresql@14

# Create database
createdb hrmssystem
```

#### Linux

```bash
# Install PostgreSQL
sudo apt-get install postgresql-14

# Start PostgreSQL service
sudo systemctl start postgresql

# Create database
sudo -u postgres createdb hrmssystem
```

#### Windows

1. Download PostgreSQL from [postgresql.org](https://www.postgresql.org/download/windows/)
2. Install and start the service
3. Create database using pgAdmin or command line

### Step 5: Configure Environment Variables

#### Backend Services

Each backend service may need a `.env` file. See `backend/docs/environment-variables.md` for details.

Example for `backend/services/identity-service/.env`:

```env
NODE_ENV=development
PORT=4001
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/hrmssystem
JWT_ACCESS_SECRET=your-secret-key-here
JWT_REFRESH_SECRET=your-refresh-secret-here
```

#### Frontend Applications

Frontend apps use `.env.local` files. Example for `frontend/admin/.env.local`:

```env
NEXT_PUBLIC_GATEWAY_URL=http://localhost:4000
NEXT_PUBLIC_DEMO_TENANT_ID=11111111-2222-3333-4444-555555555555
```

### Step 6: Run Database Migrations

```bash
# Navigate to a service directory
cd backend/services/identity-service

# Run migrations
npm run migration:run

# Repeat for other services as needed
```

Or use the test script which runs migrations automatically:

```bash
# From root directory
npm test
```

### Step 7: Start the System

#### Option 1: Using PM2 (Recommended)

```bash
# Start all services
npm run pm2:start

# Or start only critical services
npm run pm2:start:critical

# View logs
npm run pm2:logs

# Monitor services
npm run pm2:monit
```

#### Option 2: Using Test Script

```bash
# Start all services with health checks
npm test

# Or start only critical services
npm run test:critical
```

#### Option 3: Manual Start

```bash
# Start API Gateway
cd backend/services/api-gateway
npm run start:dev

# In another terminal, start Identity Service
cd backend/services/identity-service
npm run start:dev

# Continue for other services...
```

## 🧪 Verify Installation

### Check Service Health

```bash
# Check if services are running
npm run check:ports

# Or manually check
curl http://localhost:4000/health  # API Gateway
curl http://localhost:4001/health  # Identity Service
curl http://localhost:4002/health  # Access Service
```

### Access Frontend Applications

- **Admin Panel**: http://localhost:4205
- **Marketing Site**: http://localhost:4200
- **Analytics**: http://localhost:4206
- **HRMS**: http://localhost:4213

## 📁 Repository Structure

```
hrms-platform/
├── backend/              # Backend microservices (separate repo)
│   ├── services/        # All microservices
│   ├── packages/        # Shared packages
│   └── libs/           # Shared libraries
├── frontend/            # Frontend applications (separate repo)
│   ├── admin/          # Admin panel
│   ├── marketing/      # Marketing site
│   └── packages/       # Shared packages
├── scripts/             # Orchestration scripts
├── docs/               # Documentation
├── ecosystem.config.js  # PM2 configuration
└── package.json        # Root package.json
```

## 🔧 Development Workflow

### Making Changes

1. **Frontend Changes**: Work in `frontend/` directory
   ```bash
   cd frontend/admin
   # Make your changes
   git add .
   git commit -m "your changes"
   git push origin main
   ```

2. **Backend Changes**: Work in `backend/` directory
   ```bash
   cd backend/services/identity-service
   # Make your changes
   git add .
   git commit -m "your changes"
   git push origin main
   ```

3. **Orchestrator Changes**: Work in root directory
   ```bash
   # Update scripts, PM2 config, etc.
   git add .
   git commit -m "orchestrator updates"
   git push origin main
   ```

### Updating Submodules

If using git submodules:

```bash
# Update submodules to latest commits
git submodule update --remote

# Or update specific submodule
git submodule update --remote frontend
git submodule update --remote backend
```

## 🐛 Troubleshooting

### Port Already in Use

```bash
# Check what's using the port
lsof -i :4000

# Kill the process
kill -9 <PID>

# Or use the convenience script
npm run kill:all
```

### Database Connection Issues

1. Verify PostgreSQL is running:
   ```bash
   # macOS
   brew services list
   
   # Linux
   sudo systemctl status postgresql
   ```

2. Check database exists:
   ```bash
   psql -l | grep hrmssystem
   ```

3. Verify connection string in `.env` files

### Service Won't Start

1. Check logs:
   ```bash
   npm run pm2:logs
   # Or
   tail -f .logs/<service-name>-error.log
   ```

2. Verify dependencies are installed:
   ```bash
   cd backend && npm install
   cd ../frontend && npm install
   ```

3. Check environment variables are set correctly

### Clean Start

If things get messy:

```bash
# Stop all services
npm run pm2:stop:all

# Clean everything
npm run clean

# Reinstall
npm run install:all

# Start fresh
npm run pm2:start
```

## 📚 Additional Resources

- [Developer Guide](./docs/developer-guide.md) - Detailed development workflow
- [PM2 Setup Guide](./PM2-SETUP.md) - PM2 process manager setup
- [Scripts Documentation](./scripts/README.md) - Script usage details
- [Backend Environment Variables](../backend/docs/environment-variables.md) - Backend configuration

## 🆘 Getting Help

- Check service logs in `.logs/` directory
- Review documentation in `docs/` directory
- Check GitHub issues in respective repositories

## ✅ Next Steps

After setup is complete:

1. Review the [Developer Guide](./docs/developer-guide.md)
2. Explore the API Gateway at http://localhost:4000
3. Access the Admin Panel at http://localhost:4205
4. Start developing!


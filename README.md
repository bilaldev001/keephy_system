# Keephy HRMS Platform - Monorepo Orchestrator

This is the root orchestrator repository for the Keephy HRMS Platform. It manages the coordination between the frontend and backend systems.

## 📁 Repository Structure

This repository contains:
- **Orchestration scripts** (`scripts/`) - System startup, testing, and management
- **PM2 configuration** (`ecosystem.config.js`) - Process management for all services
- **Documentation** (`docs/`) - System documentation and guides
- **Operations tools** (`ops/`) - Operational scripts and utilities

## 🔗 Related Repositories

- **Frontend**: [keephy_frontend_system](https://github.com/bilaldev001/keephy_frontend_system) - All frontend applications and packages
- **Backend**: [keephy_backend_system](https://github.com/bilaldev001/keephy_backend_system) - All backend microservices

> **Note**: Frontend and backend are separate git repositories. Clone them into the `frontend/` and `backend/` directories respectively. See [SETUP.md](./SETUP.md) for detailed setup instructions.

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- npm or yarn

### Installation

```bash
# Install root dependencies
npm install

# Install backend dependencies
cd backend && npm install && cd ..

# Install frontend dependencies
cd frontend && npm install && cd ..
```

### Starting the System

#### Option 1: Using PM2 (Recommended for Production)

```bash
# Start all services
npm run pm2:start

# Start only critical services
npm run pm2:start:critical

# Start only backend services
npm run pm2:start:backend

# Start only frontend apps
npm run pm2:start:frontend

# View logs
npm run pm2:logs

# Monitor
npm run pm2:monit

# Stop all
npm run pm2:stop:all
```

#### Option 2: Using Test Script (Development)

```bash
# Start all services with health checks
npm test

# Start only critical services
npm run test:critical
```

#### Option 3: Using Start Script (Simple)

```bash
# Start all services
npm start

# Start only critical services
npm run start:critical
```

## 📜 Available Scripts

### System Management
- `npm test` - Start all services with comprehensive testing
- `npm run test:critical` - Start only critical services
- `npm start` - Start all services (simple)
- `npm run start:critical` - Start only critical services
- `npm run start:simple` - Quick start (skip install & migrations)

### PM2 Management
- `npm run pm2:start` - Start all services with PM2
- `npm run pm2:start:critical` - Start critical services only
- `npm run pm2:start:backend` - Start all backend services
- `npm run pm2:start:frontend` - Start all frontend apps
- `npm run pm2:stop` - Stop all PM2 processes
- `npm run pm2:restart` - Restart all PM2 processes
- `npm run pm2:logs` - View all logs
- `npm run pm2:monit` - Open PM2 monitoring dashboard
- `npm run pm2:status` - Show PM2 status

### Installation & Cleanup
- `npm run install:all` - Install dependencies for backend and frontend
- `npm run clean` - Remove all node_modules and build artifacts
- `npm run clean:pm2` - Clean PM2 processes

### Utilities
- `npm run check:ports` - Check if service ports are in use
- `npm run kill:all` - Kill all running Node processes

## 🏗️ Architecture

### Backend Services

**Critical Services** (Start First):
- API Gateway (4000)
- Identity Service (4001)
- Access Service (4002)

**Core Services**:
- Admin Service (4028)
- Media Service (4003)
- Contacts Service (4004)
- Notifications Service (4005)
- Audit Service (4006)

**Business Services**:
- HRMS Service (4015)
- Billing Service (4012)
- Analytics Service (4021)
- CRM Service (4018)
- Payroll Service (4016)
- And 20+ more services...

### Frontend Applications

**Critical Apps**:
- Admin (4205)
- Marketing (4200)

**Other Apps**:
- Analytics (4206)
- Billing (4207)
- HRMS (4213)
- CRM (4209)
- And 10+ more apps...

## 📚 Documentation

- [Developer Guide](./docs/developer-guide.md) - Development workflow and guidelines
- [PM2 Setup Guide](./PM2-SETUP.md) - PM2 process manager setup
- [Scripts README](./scripts/README.md) - Detailed script documentation

## 🔧 Configuration

### Environment Variables

Each service/app has its own `.env` file. See:
- `backend/docs/environment-variables.md` for backend configuration
- Frontend apps use `.env.local` files

### PM2 Configuration

The `ecosystem.config.js` file contains all PM2 process definitions. Modify it to:
- Change ports
- Adjust memory limits
- Add/remove services
- Configure environment variables

## 🧪 Testing

```bash
# Run system tests
npm test

# Test only critical services
npm run test:critical
```

## 📝 Development Workflow

1. **Clone all repositories**:
   ```bash
   # Clone orchestrator repo
   git clone <orchestrator-repo-url> hrms-platform
   cd hrms-platform
   
   # Clone frontend and backend as separate repos
   git clone git@github.com:bilaldev001/keephy_frontend_system.git frontend
   git clone git@github.com:bilaldev001/keephy_backend_system.git backend
   ```
   
   See [SETUP.md](./SETUP.md) for complete setup instructions.

2. **Install dependencies**:
   ```bash
   npm run install:all
   ```

3. **Start services**:
   ```bash
   npm run pm2:start:critical
   ```

4. **Make changes** in frontend or backend repos

5. **Test changes**:
   ```bash
   npm test
   ```

## 🐛 Troubleshooting

### Port Already in Use
```bash
npm run check:ports
# Kill specific port
lsof -ti:4000 | xargs kill -9
```

### Services Won't Start
1. Check PostgreSQL is running
2. Verify environment variables
3. Check logs: `npm run pm2:logs`
4. Review service-specific logs in `.logs/` directory

### Clean Start
```bash
npm run clean:pm2
npm run clean
npm run install:all
npm run pm2:start
```

## 📄 License

UNLICENSED

## 👥 Contributing

See [Developer Guide](./docs/developer-guide.md) for contribution guidelines.


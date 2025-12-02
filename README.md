# Keephy Platform - Development & Testing Guide

This guide provides step-by-step instructions for running the Keephy platform services and testing legacy functionality using Selenium.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Step-by-Step Service Setup](#step-by-step-service-setup)
- [Testing Legacy Functionality](#testing-legacy-functionality)
- [Manual Service Management](#manual-service-management)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before starting, ensure you have the following installed:

### Required Software

1. **Docker & Docker Compose**
   ```bash
   # Check if installed
   docker --version
   docker compose version
   
   # If not installed, install Docker Desktop:
   # macOS: https://docs.docker.com/desktop/install/mac-install/
   # Linux: https://docs.docker.com/engine/install/
   ```

2. **Python 3.8+**
   ```bash
   # Check if installed
   python3 --version
   
   # If not installed:
   # macOS: brew install python3
   # Linux: sudo apt-get install python3 python3-pip
   ```

3. **Python Dependencies**
   ```bash
   # Install Selenium and required packages
   pip3 install selenium
   ```

4. **Google Chrome & ChromeDriver**
   ```bash
   # Install Chrome browser (if not already installed)
   # macOS: brew install --cask google-chrome
   # Linux: sudo apt-get install google-chrome-stable
   
   # ChromeDriver is usually auto-managed by Selenium
   # If needed manually: brew install chromedriver (macOS)
   ```

### Environment Setup

1. **Clone/Navigate to the repository**
   ```bash
   cd /Users/mac/Desktop/My\ Data/My\ Live/hrms-develop-postgres
   ```

2. **Verify Docker Compose file exists**
   ```bash
   ls docker-compose.dev.yml
   ```

---

## Quick Start

The fastest way to start all services and run tests:

```bash
# Make the script executable (first time only)
chmod +x run-system-tests.sh

# Run everything (starts services + runs tests)
./run-system-tests.sh
```

This script will:
1. Stop any existing services
2. Start required backend and frontend services
3. Wait for services to be ready
4. Run comprehensive Selenium tests with dummy data
5. Display test results

---

## Step-by-Step Service Setup

If you prefer to start services manually or need more control:

### Step 1: Start Database

```bash
# Start PostgreSQL database
docker compose -f docker-compose.dev.yml up -d postgres

# Wait for database to be ready (15-20 seconds)
sleep 15

# Verify database is running
docker ps | grep postgres
```

### Step 2: Start API Gateway

```bash
# Start API Gateway (entry point for all backend services)
docker compose -f docker-compose.dev.yml up -d api-gateway

# Wait a few seconds
sleep 10

# Verify API Gateway is accessible
curl http://localhost:3010/health || echo "API Gateway starting..."
```

### Step 3: Start Core Backend Services

```bash
# Start authentication services (required for login/signup)
docker compose -f docker-compose.dev.yml up -d identity-service access-service

# Wait for services to initialize
sleep 15
```

### Step 4: Start Frontend Applications

```bash
# Start all frontend applications
docker compose -f docker-compose.dev.yml up -d \
  frontend-console \
  frontend-marketing \
  frontend-admin \
  frontend-forms \
  frontend-vouchers \
  frontend-fbms \
  frontend-analytics \
  frontend-hrms

# Wait for Next.js compilation (2-3 minutes)
echo "Waiting for Next.js apps to compile..."
sleep 120
```

### Step 5: Verify Services Are Running

```bash
# Check all containers are running
docker ps

# Quick accessibility check
curl http://localhost:3076  # Console
curl http://localhost:3074  # Marketing
curl http://localhost:3078  # Admin
curl http://localhost:3082  # Forms
curl http://localhost:3086  # Vouchers
curl http://localhost:3088  # FBMS
curl http://localhost:3094  # Analytics
curl http://localhost:3084  # HRMS
```

**Expected Ports:**
- **Console**: `http://localhost:3076`
- **Marketing**: `http://localhost:3074`
- **Admin**: `http://localhost:3078`
- **Forms**: `http://localhost:3082`
- **Vouchers**: `http://localhost:3086`
- **FBMS**: `http://localhost:3088`
- **Analytics**: `http://localhost:3094`
- **HRMS**: `http://localhost:3084`
- **API Gateway**: `http://localhost:3010`

---

## Testing Legacy Functionality

### Automated Testing with Selenium

The comprehensive Selenium test suite verifies all legacy functionality from the old system.

#### Run All Tests (Recommended)

```bash
# Using the unified script (starts services + runs tests)
./run-system-tests.sh
```

#### Run Tests Only (Services Already Running)

```bash
# Run Selenium test suite directly
python3 test-legacy-functionality.py
```

### What Gets Tested

The Selenium test suite automatically tests:

#### 1. **Authentication & Onboarding**
- ✅ User Signup (creates test account with dummy data)
- ✅ User Login
- ✅ Organization Creation
- ✅ Brand Creation
- ✅ Business Creation
- ✅ Franchise Creation

#### 2. **Entity Management**
- ✅ Organizations List
- ✅ Brands List
- ✅ Businesses List
- ✅ Franchises List

#### 3. **HRMS Features**
- ✅ Staff List
- ✅ Staff Create
- ✅ Shifts List
- ✅ Shifts Create
- ✅ Schedule Templates

#### 4. **Voucher & Gift Card System**
- ✅ Gift Cards List
- ✅ Gift Cards Create
- ✅ Coupons List
- ✅ Coupons Create

#### 5. **Forms & Feedback**
- ✅ Forms List
- ✅ Forms Create
- ✅ FBMS Dashboard

#### 6. **Admin Features**
- ✅ Admin Login
- ✅ Admin Users
- ✅ Admin Businesses
- ✅ Admin Plans

#### 7. **Analytics**
- ✅ Analytics Dashboard

#### 8. **Marketing Pages**
- ✅ Marketing Home
- ✅ Marketing Features
- ✅ Marketing Pricing
- ✅ Marketing About
- ✅ Marketing Contact
- ✅ Marketing Terms
- ✅ Marketing Privacy
- ✅ Marketing Cookies

### Test Output

After running tests, you'll see:

```
================================================================================
TEST SUMMARY
================================================================================
✅ Passed: 36
❌ Failed: 0
⏭️  Skipped: 0
⚠️  Errors: 0
================================================================================

✅ PASSED TESTS:
  - User Signup
  - User Login
  - Organization Creation
  - Brand Creation
  - Business Creation
  - Franchise Creation
  ... (and more)
```

### Dummy Data Generation

The test suite automatically generates dummy data:
- **Random email addresses**: `test_user_<timestamp>@example.com`
- **Random organization names**: `Test Org <timestamp>`
- **Random brand/business/franchise names**: `Test <Entity> <timestamp>`

No manual data entry required!

---

## Manual Service Management

### Start All Services

```bash
# Start all services at once
docker compose -f docker-compose.dev.yml up -d
```

### Stop All Services

```bash
# Stop all services
docker compose -f docker-compose.dev.yml down
```

### View Service Logs

```bash
# View logs for a specific service
docker compose -f docker-compose.dev.yml logs -f frontend-console

# View logs for all services
docker compose -f docker-compose.dev.yml logs -f
```

### Restart a Service

```bash
# Restart a specific service
docker compose -f docker-compose.dev.yml restart frontend-console

# Restart all services
docker compose -f docker-compose.dev.yml restart
```

### Check Service Status

```bash
# List all running containers
docker ps

# Check specific service health
docker ps | grep keephy-frontend-console-dev
```

---

## Troubleshooting

### Issue: Services Won't Start

**Problem**: Docker containers exit immediately or fail to start.

**Solutions**:
```bash
# Check Docker is running
docker ps

# Check for port conflicts
lsof -i :3076  # Check if port is already in use

# View service logs
docker compose -f docker-compose.dev.yml logs <service-name>

# Restart Docker Desktop (macOS/Windows)
# Or restart Docker daemon (Linux): sudo systemctl restart docker
```

### Issue: Frontend Apps Show "Connection Refused"

**Problem**: Frontend apps are not accessible after starting.

**Solutions**:
```bash
# Wait longer for Next.js compilation (can take 2-5 minutes)
sleep 300

# Check if container is running
docker ps | grep frontend-console

# Check container logs for errors
docker compose -f docker-compose.dev.yml logs frontend-console

# Restart the service
docker compose -f docker-compose.dev.yml restart frontend-console
```

### Issue: Selenium Tests Fail

**Problem**: Tests fail with "Connection refused" or "Element not found".

**Solutions**:
```bash
# 1. Verify services are running
docker ps

# 2. Verify services are accessible
curl http://localhost:3076  # Console
curl http://localhost:3074  # Marketing

# 3. Check Chrome/ChromeDriver
google-chrome --version
chromedriver --version

# 4. Run tests with longer waits (edit test-legacy-functionality.py)
# Increase time.sleep() values if needed

# 5. Check test logs for specific errors
python3 test-legacy-functionality.py 2>&1 | tee test-output.log
```

### Issue: Database Connection Errors

**Problem**: Backend services can't connect to PostgreSQL.

**Solutions**:
```bash
# 1. Verify PostgreSQL is running
docker ps | grep postgres

# 2. Check database health
docker exec keephy-postgres-dev pg_isready -U postgres

# 3. Restart PostgreSQL
docker compose -f docker-compose.dev.yml restart postgres

# 4. Check database logs
docker compose -f docker-compose.dev.yml logs postgres
```

### Issue: Port Already in Use

**Problem**: Error: "port is already allocated" or "address already in use".

**Solutions**:
```bash
# Find process using the port
lsof -i :3076  # Replace with your port

# Kill the process (replace PID with actual process ID)
kill -9 <PID>

# Or stop conflicting Docker containers
docker ps
docker stop <container-id>
```

### Issue: Memory Issues (Containers Killed)

**Problem**: Containers exit with code 137 (killed due to memory).

**Solutions**:
```bash
# Increase Docker memory limit in Docker Desktop settings
# macOS: Docker Desktop > Settings > Resources > Memory (increase to 8GB+)

# Or start services one at a time
docker compose -f docker-compose.dev.yml up -d postgres
sleep 10
docker compose -f docker-compose.dev.yml up -d api-gateway
# ... continue one by one
```

### Issue: Python/Selenium Errors

**Problem**: `ModuleNotFoundError` or ChromeDriver issues.

**Solutions**:
```bash
# Install Python dependencies
pip3 install selenium

# Update Selenium
pip3 install --upgrade selenium

# Install ChromeDriver manually (if auto-detection fails)
# macOS:
brew install chromedriver

# Linux:
sudo apt-get install chromium-chromedriver
```

---

## Service Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Frontend Applications                    │
│  Console │ Marketing │ Admin │ Forms │ Vouchers │ FBMS...  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                      API Gateway (3010)                     │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   Identity   │ │    Access    │ │    Tenant    │
│   Service    │ │   Service    │ │   Service    │
└──────────────┘ └──────────────┘ └──────────────┘
        │              │              │
        └──────────────┼──────────────┘
                       ▼
              ┌──────────────┐
              │  PostgreSQL   │
              │   Database    │
              └──────────────┘
```

---

## Additional Resources

- **Docker Compose File**: `docker-compose.dev.yml`
- **Test Script**: `test-legacy-functionality.py`
- **Unified Runner**: `run-system-tests.sh`

---

## Support

If you encounter issues not covered in this guide:

1. Check service logs: `docker compose -f docker-compose.dev.yml logs <service-name>`
2. Verify all prerequisites are installed
3. Ensure Docker has sufficient resources (memory, CPU)
4. Review test output for specific error messages

---

**Last Updated**: 2025-01-27
**Platform Version**: Development

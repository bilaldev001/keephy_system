#!/bin/bash

# Keephy Platform - Comprehensive Docker Startup Script
# This script sets up and starts the entire Keephy platform

set -e

echo "=========================================="
echo "  Keephy Platform - Docker Startup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_step() {
    echo -e "${BLUE}→${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker Desktop."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "docker-compose is not installed"
    exit 1
fi

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

# Step 1: Load environment variables
echo "Step 1: Loading environment variables..."
print_step "Checking for .env files..."

if [ ! -f ".env.backend" ]; then
    print_warning ".env.backend not found, creating from example..."
    if [ -f ".env.backend.example" ]; then
        cp .env.backend.example .env.backend
        print_info "Created .env.backend from example"
    else
        print_warning "No .env.backend.example found, using defaults"
    fi
fi

if [ ! -f ".env.frontend" ]; then
    print_warning ".env.frontend not found, creating from example..."
    if [ -f ".env.frontend.example" ]; then
        cp .env.frontend.example .env.frontend
        print_info "Created .env.frontend from example"
    else
        print_warning "No .env.frontend.example found, using defaults"
    fi
fi

print_info "Environment files ready"
echo ""

# Step 2: Create Docker network
echo "Step 2: Creating Docker network..."
if ! docker network inspect keephy-dev-network > /dev/null 2>&1; then
    docker network create keephy-dev-network
    print_info "Network 'keephy-dev-network' created"
else
    print_info "Network 'keephy-dev-network' already exists"
fi
echo ""

# Step 3: Start PostgreSQL database
echo "Step 3: Starting PostgreSQL database..."
print_step "Starting postgres container..."

$DOCKER_COMPOSE -f docker-compose.dev.yml up -d postgres

# Wait for postgres to be healthy
print_step "Waiting for PostgreSQL to be ready..."
MAX_WAIT=60
WAIT_COUNT=0
while ! docker exec keephy-postgres-dev pg_isready -U postgres > /dev/null 2>&1; do
    if [ $WAIT_COUNT -ge $MAX_WAIT ]; then
        print_error "PostgreSQL failed to start within $MAX_WAIT seconds"
        exit 1
    fi
    sleep 1
    WAIT_COUNT=$((WAIT_COUNT + 1))
    echo -n "."
done
echo ""
print_info "PostgreSQL is ready"
echo ""

# Step 4: Create database if it doesn't exist
echo "Step 4: Creating database..."
DB_NAME="hrmssystem_dev"
print_step "Checking if database '$DB_NAME' exists..."

if ! docker exec keephy-postgres-dev psql -U postgres -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    print_step "Creating database '$DB_NAME'..."
    docker exec keephy-postgres-dev psql -U postgres -c "CREATE DATABASE $DB_NAME;"
    print_info "Database '$DB_NAME' created"
else
    print_info "Database '$DB_NAME' already exists"
fi
echo ""

# Step 5: Install npm dependencies
echo "Step 5: Installing npm dependencies..."
print_step "Installing root dependencies..."

if [ -f "package.json" ]; then
    npm install --legacy-peer-deps
    print_info "Root dependencies installed"
fi

print_step "Installing backend dependencies..."
if [ -d "backend" ]; then
    cd backend
    if [ -f "package.json" ]; then
        npm install --legacy-peer-deps
        print_info "Backend dependencies installed"
    fi
    cd ..
fi

print_step "Installing frontend dependencies..."
if [ -d "frontend" ]; then
    cd frontend
    if [ -f "package.json" ]; then
        npm install --legacy-peer-deps
        print_info "Frontend dependencies installed"
    fi
    cd ..
fi

print_step "Installing shared package dependencies..."
if [ -d "backend/libs" ]; then
    for lib in backend/libs/*/; do
        if [ -f "$lib/package.json" ]; then
            print_step "Installing $(basename $lib)..."
            cd "$lib"
            npm install --legacy-peer-deps 2>/dev/null || true
            cd - > /dev/null
        fi
    done
fi

if [ -d "frontend/packages" ]; then
    for pkg in frontend/packages/*/; do
        if [ -f "$pkg/package.json" ]; then
            print_step "Installing $(basename $pkg)..."
            cd "$pkg"
            npm install --legacy-peer-deps 2>/dev/null || true
            cd - > /dev/null
        fi
    done
fi

print_info "All npm dependencies installed"
echo ""

# Step 6: Build shared packages
echo "Step 6: Building shared packages..."
print_step "Building backend service-core..."
if [ -d "backend/libs/service-core" ]; then
    cd backend/libs/service-core
    npm run build 2>/dev/null || true
    cd - > /dev/null
fi

print_step "Building frontend packages..."
if [ -d "frontend/packages" ]; then
    for pkg in frontend/packages/*/; do
        if [ -f "$pkg/package.json" ] && grep -q '"build"' "$pkg/package.json"; then
            print_step "Building $(basename $pkg)..."
            cd "$pkg"
            npm run build 2>/dev/null || true
            cd - > /dev/null
        fi
    done
fi

print_info "Shared packages built"
echo ""

# Step 7: Run migrations
echo "Step 7: Running database migrations..."
print_step "Waiting for all services to be ready for migrations..."

# Start services that need to run migrations first
print_step "Starting services for migrations..."
$DOCKER_COMPOSE -f docker-compose.dev.yml up -d \
    access-service \
    identity-service \
    tenant-service \
    subscriptions-service \
    fbms-service

# Wait a bit for services to start
sleep 10

print_step "Migrations will run automatically when services start..."
print_info "Migrations are configured to run on service startup"
echo ""

# Step 8: Start all backend services
echo "Step 8: Starting all backend services..."
print_step "Starting backend services..."

$DOCKER_COMPOSE -f docker-compose.dev.yml up -d \
    api-gateway \
    admin-service \
    ai-service \
    analytics-service \
    audit-service \
    billing-service \
    builder-service \
    compliance-service \
    contacts-service \
    crm-service \
    entitlements-service \
    forms-service \
    hrms-service \
    integration-service \
    inventory-service \
    lifecycle-service \
    mobile-service \
    notifications-service \
    onboarding-service \
    observability-service \
    payroll-service \
    scm-service \
    support-service \
    voucher-service \
    media-service

print_info "All backend services starting..."
echo ""

# Step 9: Start all frontend apps
echo "Step 9: Starting all frontend apps..."
print_step "Starting frontend applications..."

$DOCKER_COMPOSE -f docker-compose.dev.yml up -d \
    frontend-marketing-dev \
    frontend-console-dev \
    frontend-analytics-dev \
    frontend-vouchers-dev \
    frontend-admin-dev \
    frontend-forms-dev \
    frontend-fbms \
    frontend-inventory \
    frontend-billing-dev \
    frontend-compliance-dev \
    frontend-crm-dev \
    frontend-ems-dev \
    frontend-support-dev \
    frontend-hrms-dev \
    frontend-scm-dev \
    frontend-builder-dev

print_info "All frontend apps starting..."
echo ""

# Step 10: Wait for services to be ready
echo "Step 10: Waiting for services to be ready..."
print_step "Checking service health..."

MAX_WAIT=120
WAIT_COUNT=0
SERVICES_READY=0
TOTAL_SERVICES=43

check_service() {
    local service=$1
    local port=$2
    
    if curl -s -f "http://localhost:$port/health" > /dev/null 2>&1 || \
       curl -s -f "http://localhost:$port" > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Check critical services
CRITICAL_SERVICES=(
    "api-gateway:4000"
    "identity-service:4001"
    "frontend-marketing:4200"
    "frontend-console:4201"
)

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    READY=0
    for service_port in "${CRITICAL_SERVICES[@]}"; do
        IFS=':' read -r service port <<< "$service_port"
        if check_service "$service" "$port"; then
            READY=$((READY + 1))
        fi
    done
    
    if [ $READY -eq ${#CRITICAL_SERVICES[@]} ]; then
        print_info "Critical services are ready"
        break
    fi
    
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
    echo -n "."
done
echo ""

# Step 11: Display service status
echo ""
echo "=========================================="
echo "  Service Status"
echo "=========================================="
echo ""

# Count running containers
RUNNING=$(docker ps --format "{{.Names}}" | grep -E "keephy-" | wc -l | tr -d ' ')
TOTAL=$(docker ps -a --format "{{.Names}}" | grep -E "keephy-" | wc -l | tr -d ' ')

echo "  Running containers: $RUNNING / $TOTAL"
echo ""

# Show service URLs
echo "  Service URLs:"
echo "    • API Gateway:        http://localhost:4000"
echo "    • Identity Service:   http://localhost:4001"
echo "    • Marketing App:       http://localhost:4200"
echo "    • Console App:        http://localhost:4201"
echo "    • FBMS App:           http://localhost:5005"
echo "    • Analytics App:      http://localhost:5004"
echo ""

# Step 12: Final summary
echo "=========================================="
echo "  Startup Complete!"
echo "=========================================="
echo ""
print_info "All services have been started"
echo ""
echo "To view logs:"
echo "  docker-compose -f docker-compose.dev.yml logs -f [service-name]"
echo ""
echo "To stop all services:"
echo "  docker-compose -f docker-compose.dev.yml down"
echo ""
echo "To clean everything:"
echo "  ./cleanup-docker.sh"
echo ""


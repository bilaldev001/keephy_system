#!/bin/bash

# Start All Backend Services
# This script starts all backend services using docker-compose

set -e

echo "=========================================="
echo "Starting All Backend Services"
echo "=========================================="

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null && ! command -v docker &> /dev/null; then
    echo "Error: Docker and docker-compose are required but not installed."
    exit 1
fi

# Use docker compose (newer) or docker-compose (older)
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "Error: docker compose or docker-compose not found"
    exit 1
fi

echo ""
echo "Starting PostgreSQL database..."
$DOCKER_COMPOSE -f docker-compose.dev.yml up -d postgres

echo "Waiting for PostgreSQL to be healthy..."
sleep 5

# Wait for postgres to be healthy
MAX_WAIT=60
WAIT_COUNT=0
while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    if $DOCKER_COMPOSE -f docker-compose.dev.yml ps postgres | grep -q "healthy"; then
        echo "PostgreSQL is healthy!"
        break
    fi
    echo "Waiting for PostgreSQL... ($WAIT_COUNT/$MAX_WAIT)"
    sleep 2
    WAIT_COUNT=$((WAIT_COUNT + 2))
done

if [ $WAIT_COUNT -ge $MAX_WAIT ]; then
    echo "Warning: PostgreSQL may not be fully ready, but continuing..."
fi

echo ""
echo "Starting all backend services..."
echo ""

# Start all backend services (excluding frontend)
$DOCKER_COMPOSE -f docker-compose.dev.yml up -d \
    api-gateway \
    identity-service \
    access-service \
    tenant-service \
    media-service \
    fbms-service \
    contacts-service \
    notifications-service \
    audit-service \
    subscriptions-service \
    entitlements-service \
    billing-service \
    observability-service \
    hrms-service \
    scm-service \
    payroll-service \
    inventory-service \
    crm-service \
    support-service \
    compliance-service \
    analytics-service \
    ems-service \
    voucher-service \
    forms-service \
    builder-service \
    onboarding-service \
    admin-service \
    ai-service \
    lifecycle-service \
    integration-service \
    mobile-service \
    facilities-service

echo ""
echo "=========================================="
echo "Backend Services Started"
echo "=========================================="
echo ""
echo "Checking service status..."
echo ""

# Wait a moment for services to start
sleep 3

# Show status of all backend services
$DOCKER_COMPOSE -f docker-compose.dev.yml ps --format "table {{.Name}}\t{{.Status}}" | grep -E "service|NAME" || true

echo ""
echo "=========================================="
echo "Service URLs:"
echo "=========================================="
echo "API Gateway:     http://localhost:3010"
echo "Identity:       http://localhost:3012"
echo "Access:         http://localhost:3014"
echo "Tenant:         http://localhost:3016"
echo "Media:          http://localhost:3018"
echo "FBMS:           http://localhost:3020"
echo "Contacts:       http://localhost:3022"
echo "Notifications:  http://localhost:3024"
echo "Audit:          http://localhost:3026"
echo "Subscriptions:  http://localhost:3028"
echo "Entitlements:   http://localhost:3030"
echo "Billing:        http://localhost:3032"
echo "Observability:  http://localhost:3034"
echo "HRMS:           http://localhost:3036"
echo "SCM:            http://localhost:3038"
echo "Payroll:        http://localhost:3040"
echo "Inventory:      http://localhost:3042"
echo "CRM:            http://localhost:3044"
echo "Support:        http://localhost:3046"
echo "Compliance:     http://localhost:3048"
echo "Analytics:      http://localhost:3050"
echo "EMS:            http://localhost:3052"
echo "Voucher:        http://localhost:3054"
echo "Forms:          http://localhost:3056"
echo "Builder:        http://localhost:3058"
echo "Onboarding:     http://localhost:3060"
echo "Admin:          http://localhost:3062"
echo "AI:             http://localhost:3064"
echo "Lifecycle:      http://localhost:3066"
echo "Integration:    http://localhost:3068"
echo "Mobile:         http://localhost:3070"
echo "Facilities:     http://localhost:3072"
echo ""
echo "To view logs: docker compose -f docker-compose.dev.yml logs -f [service-name]"
echo "To stop all:  docker compose -f docker-compose.dev.yml stop"
echo ""


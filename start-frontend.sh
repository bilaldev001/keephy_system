#!/bin/bash

# Start All Frontend Services and Apps
# This script starts all frontend applications using docker-compose

set -e

echo "=========================================="
echo "Starting All Frontend Services and Apps"
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
echo "Starting all frontend applications..."
echo ""

# Start all frontend services
$DOCKER_COMPOSE -f docker-compose.dev.yml up -d \
    frontend-marketing \
    frontend-console \
    frontend-admin \
    frontend-builder \
    frontend-forms \
    frontend-hrms \
    frontend-vouchers \
    frontend-fbms \
    frontend-crm \
    frontend-billing \
    frontend-analytics \
    frontend-compliance \
    frontend-ems \
    frontend-inventory \
    frontend-scm \
    frontend-support \
    frontend-mobile

echo ""
echo "=========================================="
echo "Frontend Services Started"
echo "=========================================="
echo ""
echo "Checking service status..."
echo ""

# Wait a moment for services to start
sleep 5

# Show status of all frontend services
$DOCKER_COMPOSE -f docker-compose.dev.yml ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}" | grep -E "frontend-|NAME" || true

echo ""
echo "=========================================="
echo "Frontend Application URLs:"
echo "=========================================="
echo "Marketing:      http://localhost:3074"
echo "Console:        http://localhost:3076"
echo "Admin:          http://localhost:3078"
echo "Builder:        http://localhost:3080"
echo "Forms:          http://localhost:3082"
echo "HRMS:           http://localhost:3084"
echo "Vouchers:       http://localhost:3086"
echo "FBMS:           http://localhost:3088"
echo "CRM:            http://localhost:3090"
echo "Billing:        http://localhost:3092"
echo "Analytics:      http://localhost:3094"
echo "Compliance:     http://localhost:3096"
echo "EMS:            http://localhost:3098"
echo "Inventory:      http://localhost:3100"
echo "SCM:            http://localhost:3102"
echo "Support:        http://localhost:3104"
echo "Mobile:         http://localhost:3106 (Expo)"
echo ""
echo "To view logs: docker compose -f docker-compose.dev.yml logs -f [service-name]"
echo "To stop all:  docker compose -f docker-compose.dev.yml stop frontend-*"
echo ""


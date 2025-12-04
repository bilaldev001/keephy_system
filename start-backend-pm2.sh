#!/bin/bash

###############################################################################
# Start All Backend Services with PM2
###############################################################################

set -e

echo "=================================================="
echo "  Starting All Backend Services with PM2"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create logs directory structure
echo -e "${BLUE}Creating log directories...${NC}"
mkdir -p .logs/backend

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}PM2 is not installed!${NC}"
    echo "Installing PM2 globally..."
    npm install -g pm2
fi

# Check if backend dependencies are installed
if [ ! -d "backend/node_modules" ]; then
    echo -e "${YELLOW}Backend dependencies not found. Installing...${NC}"
    cd backend && npm install --legacy-peer-deps && cd ..
fi

# Stop existing backend services if running
echo -e "${BLUE}Stopping any existing backend services...${NC}"
pm2 delete ecosystem.backend.config.js 2>/dev/null || true

# Start backend services
echo -e "${GREEN}Starting all backend services...${NC}"
pm2 start ecosystem.backend.config.js

# Save PM2 process list
echo -e "${BLUE}Saving PM2 process list...${NC}"
pm2 save

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Backend Services Started Successfully!${NC}"
echo "=================================================="
echo ""
echo "Available Commands:"
echo "  pm2 status                    - View all services status"
echo "  pm2 logs                      - View all logs"
echo "  pm2 logs api-gateway          - View specific service logs"
echo "  pm2 monit                     - Open monitoring dashboard"
echo "  pm2 restart ecosystem.backend.config.js  - Restart all backend services"
echo "  pm2 stop ecosystem.backend.config.js     - Stop all backend services"
echo "  pm2 delete ecosystem.backend.config.js   - Delete all backend services"
echo ""
echo "Critical Services:"
echo "  - API Gateway:       http://localhost:3010"
echo "  - Identity Service:  http://localhost:4001"
echo "  - Access Service:    http://localhost:4002"
echo "  - Tenant Service:    http://localhost:4023"
echo ""
echo "To view logs: pm2 logs"
echo "To monitor: pm2 monit"
echo ""

# Show PM2 status
pm2 status


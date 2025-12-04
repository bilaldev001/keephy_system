#!/bin/bash

###############################################################################
# Start All Frontend Applications with PM2
###############################################################################

set -e

echo "=================================================="
echo "  Starting All Frontend Applications with PM2"
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
mkdir -p .logs/frontend

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}PM2 is not installed!${NC}"
    echo "Installing PM2 globally..."
    npm install -g pm2
fi

# Check if frontend dependencies are installed
if [ ! -d "frontend/node_modules" ]; then
    echo -e "${YELLOW}Frontend dependencies not found. Installing...${NC}"
    cd frontend && npm install && cd ..
fi

# Stop existing frontend services if running
echo -e "${BLUE}Stopping any existing frontend services...${NC}"
pm2 delete ecosystem.frontend.config.js 2>/dev/null || true

# Start frontend services
echo -e "${GREEN}Starting all frontend applications...${NC}"
pm2 start ecosystem.frontend.config.js

# Save PM2 process list
echo -e "${BLUE}Saving PM2 process list...${NC}"
pm2 save

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Frontend Applications Started Successfully!${NC}"
echo "=================================================="
echo ""
echo "Available Commands:"
echo "  pm2 status                     - View all apps status"
echo "  pm2 logs                       - View all logs"
echo "  pm2 logs frontend-admin        - View specific app logs"
echo "  pm2 monit                      - Open monitoring dashboard"
echo "  pm2 restart ecosystem.frontend.config.js  - Restart all frontend apps"
echo "  pm2 stop ecosystem.frontend.config.js     - Stop all frontend apps"
echo "  pm2 delete ecosystem.frontend.config.js   - Delete all frontend apps"
echo ""
echo "Frontend Applications:"
echo "  - Admin:       http://localhost:5210"
echo "  - Marketing:   http://localhost:5200"
echo "  - Console:     http://localhost:5201"
echo "  - Analytics:   http://localhost:4206"
echo "  - Billing:     http://localhost:4207"
echo "  - HRMS:        http://localhost:4213"
echo "  - CRM:         http://localhost:4209"
echo "  - FBMS:        http://localhost:4214"
echo "  - Builder:     http://localhost:4208"
echo "  - Compliance:  http://localhost:4210"
echo "  - EMS:         http://localhost:4211"
echo "  - Forms:       http://localhost:4212"
echo "  - Inventory:   http://localhost:4215"
echo "  - SCM:         http://localhost:4216"
echo "  - Support:     http://localhost:4217"
echo "  - Vouchers:    http://localhost:4218"
echo "  - Mobile:      http://localhost:4219"
echo ""
echo "To view logs: pm2 logs"
echo "To monitor: pm2 monit"
echo ""

# Show PM2 status
pm2 status


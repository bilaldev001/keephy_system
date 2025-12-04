#!/bin/bash

###############################################################################
# Start All Services (Backend + Frontend) with PM2
###############################################################################

set -e

echo "=================================================="
echo "  Starting All Services with PM2"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Start Backend Services
echo -e "${BLUE}Step 1: Starting Backend Services...${NC}"
./start-backend-pm2.sh

echo ""
echo -e "${YELLOW}Waiting 5 seconds for backend services to initialize...${NC}"
sleep 5

# Start Frontend Applications
echo ""
echo -e "${BLUE}Step 2: Starting Frontend Applications...${NC}"
./start-frontend-pm2.sh

echo ""
echo "=================================================="
echo -e "${GREEN}✓ All Services Started Successfully!${NC}"
echo "=================================================="
echo ""
echo "Full System Status:"
pm2 status

echo ""
echo "Quick Access:"
echo "  - API Gateway:    http://localhost:3010"
echo "  - Admin Portal:   http://localhost:5210"
echo "  - Marketing Site: http://localhost:5200"
echo ""
echo "Management Commands:"
echo "  pm2 status     - View all services"
echo "  pm2 logs       - View all logs"
echo "  pm2 monit      - Open monitoring dashboard"
echo ""


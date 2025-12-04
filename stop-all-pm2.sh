#!/bin/bash

###############################################################################
# Stop All Services (Backend + Frontend) PM2
###############################################################################

set -e

echo "=================================================="
echo "  Stopping All Services"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Stop Frontend Applications
echo -e "${BLUE}Stopping Frontend Applications...${NC}"
./stop-frontend-pm2.sh

# Stop Backend Services
echo ""
echo -e "${BLUE}Stopping Backend Services...${NC}"
./stop-backend-pm2.sh

echo ""
echo "=================================================="
echo -e "${GREEN}✓ All Services Stopped Successfully!${NC}"
echo "=================================================="
echo ""

# Show PM2 status
pm2 status


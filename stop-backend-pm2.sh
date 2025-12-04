#!/bin/bash

###############################################################################
# Stop All Backend Services (PM2)
###############################################################################

set -e

echo "=================================================="
echo "  Stopping All Backend Services"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${RED}PM2 is not installed!${NC}"
    exit 1
fi

# Stop backend services
echo -e "${BLUE}Stopping all backend services...${NC}"
pm2 delete ecosystem.backend.config.js 2>/dev/null || echo "No backend services running"

# Save PM2 process list
echo -e "${BLUE}Saving PM2 process list...${NC}"
pm2 save

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Backend Services Stopped Successfully!${NC}"
echo "=================================================="
echo ""

# Show PM2 status
pm2 status


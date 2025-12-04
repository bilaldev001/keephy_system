#!/bin/bash

###############################################################################
# Stop All Frontend Applications (PM2)
###############################################################################

set -e

echo "=================================================="
echo "  Stopping All Frontend Applications"
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

# Stop frontend services
echo -e "${BLUE}Stopping all frontend applications...${NC}"
pm2 delete ecosystem.frontend.config.js 2>/dev/null || echo "No frontend applications running"

# Save PM2 process list
echo -e "${BLUE}Saving PM2 process list...${NC}"
pm2 save

echo ""
echo "=================================================="
echo -e "${GREEN}✓ Frontend Applications Stopped Successfully!${NC}"
echo "=================================================="
echo ""

# Show PM2 status
pm2 status


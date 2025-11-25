#!/bin/bash

# Keephy Platform - Docker Startup Script
# This script helps developers start all services easily

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Keephy Platform - Docker Startup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo "Please install Docker from: https://www.docker.com/get-started"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed!${NC}"
    echo "Please install Docker Compose"
    exit 1
fi

# Use docker compose (v2) or docker-compose (v1)
if command -v docker compose &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

echo -e "${GREEN}✅ Docker and Docker Compose are installed${NC}"
echo ""

# Check if .env files exist
if [ ! -f ".env.backend" ]; then
    echo -e "${YELLOW}⚠️  .env.backend not found. Creating from .env.backend.example...${NC}"
    if [ -f ".env.backend.example" ]; then
        cp .env.backend.example .env.backend
        echo -e "${GREEN}✅ Created .env.backend${NC}"
    else
        echo -e "${RED}❌ .env.backend.example not found!${NC}"
        exit 1
    fi
fi

if [ ! -f ".env.frontend" ]; then
    echo -e "${YELLOW}⚠️  .env.frontend not found. Creating from .env.frontend.example...${NC}"
    if [ -f ".env.frontend.example" ]; then
        cp .env.frontend.example .env.frontend
        echo -e "${GREEN}✅ Created .env.frontend${NC}"
    else
        echo -e "${RED}❌ .env.frontend.example not found!${NC}"
        exit 1
    fi
fi

echo ""

# Function to show menu
show_menu() {
    echo -e "${BLUE}What would you like to do?${NC}"
    echo ""
    echo "1) Start all services"
    echo "2) Start specific services"
    echo "3) Stop all services"
    echo "4) Restart all services"
    echo "5) View service logs"
    echo "6) Check service status"
    echo "7) View service URLs"
    echo "8) Clean up (stop and remove containers)"
    echo "9) Exit"
    echo ""
    read -p "Enter your choice [1-9]: " choice
}

# Start all services
start_all() {
    echo -e "${BLUE}Starting all services...${NC}"
    echo ""
    $DOCKER_COMPOSE up -d
    echo ""
    echo -e "${GREEN}✅ All services are starting!${NC}"
    echo ""
    echo "Services will be available at:"
    echo "  - API Gateway: http://localhost:3010"
    echo "  - Marketing: http://localhost:3074"
    echo "  - FBMS: http://localhost:3088"
    echo ""
    echo "Use './start.sh' and select option 5 to view logs"
    echo "Use './start.sh' and select option 6 to check status"
}

# Start specific services
start_specific() {
    echo ""
    echo "Available services:"
    echo "  - postgres (Database)"
    echo "  - api-gateway"
    echo "  - identity-service"
    echo "  - access-service"
    echo "  - fbms-service"
    echo "  - frontend-marketing"
    echo "  - frontend-fbms"
    echo ""
    echo "Or type 'all' to start everything"
    echo ""
    read -p "Enter service names (space-separated): " services
    
    if [ "$services" = "all" ]; then
        start_all
    else
        echo -e "${BLUE}Starting services: $services${NC}"
        $DOCKER_COMPOSE up -d $services
        echo -e "${GREEN}✅ Services started!${NC}"
    fi
}

# Stop all services
stop_all() {
    echo -e "${BLUE}Stopping all services...${NC}"
    $DOCKER_COMPOSE down
    echo -e "${GREEN}✅ All services stopped!${NC}"
}

# Restart all services
restart_all() {
    echo -e "${BLUE}Restarting all services...${NC}"
    $DOCKER_COMPOSE restart
    echo -e "${GREEN}✅ All services restarted!${NC}"
}

# View logs
view_logs() {
    echo ""
    echo "Available services:"
    $DOCKER_COMPOSE ps --format "table {{.Name}}\t{{.Status}}"
    echo ""
    read -p "Enter service name (or 'all' for all logs): " service
    
    if [ "$service" = "all" ]; then
        $DOCKER_COMPOSE logs -f
    else
        $DOCKER_COMPOSE logs -f $service
    fi
}

# Check status
check_status() {
    echo ""
    echo -e "${BLUE}Service Status:${NC}"
    echo ""
    $DOCKER_COMPOSE ps
    echo ""
    echo -e "${BLUE}Service Health:${NC}"
    echo ""
    # Check if services are responding
    if curl -s http://localhost:3010/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ API Gateway: Running${NC}"
    else
        echo -e "${RED}❌ API Gateway: Not responding${NC}"
    fi
    
    if curl -s http://localhost:3074 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Marketing Frontend: Running${NC}"
    else
        echo -e "${YELLOW}⚠️  Marketing Frontend: Not responding (may still be starting)${NC}"
    fi
}

# View URLs
view_urls() {
    echo ""
    echo -e "${BLUE}Service URLs:${NC}"
    echo ""
    echo "Backend Services:"
    echo "  - API Gateway: http://localhost:3010"
    echo "  - Identity Service: http://localhost:3012"
    echo "  - Access Service: http://localhost:3014"
    echo "  - FBMS Service: http://localhost:3020"
    echo ""
    echo "Frontend Applications:"
    echo "  - Marketing: http://localhost:3074"
    echo "  - Builder: http://localhost:3080"
    echo "  - Forms: http://localhost:3082"
    echo "  - HRMS: http://localhost:3084"
    echo "  - Vouchers: http://localhost:3086"
    echo "  - FBMS: http://localhost:3088"
    echo "  - CRM: http://localhost:3090"
    echo "  - Billing: http://localhost:3092"
    echo "  - Analytics: http://localhost:3094"
    echo "  - Compliance: http://localhost:3096"
    echo "  - EMS: http://localhost:3098"
    echo "  - Inventory: http://localhost:3100"
    echo "  - SCM: http://localhost:3102"
    echo "  - Support: http://localhost:3104"
    echo ""
}

# Clean up
cleanup() {
    echo -e "${YELLOW}⚠️  This will stop and remove all containers. Continue? (y/n)${NC}"
    read -p "" confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        echo -e "${BLUE}Cleaning up...${NC}"
        $DOCKER_COMPOSE down -v
        echo -e "${GREEN}✅ Cleanup complete!${NC}"
    else
        echo "Cleanup cancelled."
    fi
}

# Main menu loop
while true; do
    show_menu
    case $choice in
        1)
            start_all
            ;;
        2)
            start_specific
            ;;
        3)
            stop_all
            ;;
        4)
            restart_all
            ;;
        5)
            view_logs
            ;;
        6)
            check_status
            ;;
        7)
            view_urls
            ;;
        8)
            cleanup
            ;;
        9)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
    echo ""
    read -p "Press Enter to continue..."
    echo ""
done


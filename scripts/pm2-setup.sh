#!/bin/bash

#
# PM2 Setup Script
# 
# Helper script for PM2 operations
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    log_warn "PM2 is not installed. Installing..."
    npm install -g pm2
    log_success "PM2 installed"
fi

# Create logs directory
mkdir -p .logs

case "${1:-help}" in
    start)
        log_info "Starting all services with PM2..."
        pm2 start ecosystem.config.js
        pm2 save
        log_success "All services started"
        pm2 status
        ;;
    start:critical)
        log_info "Starting critical services only..."
        pm2 start ecosystem.config.js --only api-gateway,identity-service,access-service,admin-service,frontend-admin
        pm2 save
        log_success "Critical services started"
        pm2 status
        ;;
    start:backend)
        log_info "Starting all backend services..."
        pm2 start ecosystem.config.js --only 'api-gateway,identity-service,access-service,admin-service,media-service,contacts-service,notifications-service,audit-service,billing-service,hrms-service,analytics-service,crm-service,ai-service,payroll-service,subscriptions-service,entitlements-service,compliance-service,ems-service,facilities-service,onboarding-service,integration-service,lifecycle-service,mobile-service'
        pm2 save
        log_success "Backend services started"
        pm2 status
        ;;
    start:frontend)
        log_info "Starting all frontend applications..."
        pm2 start ecosystem.config.js --only 'frontend-admin,frontend-analytics,frontend-billing,frontend-hrms,frontend-crm'
        pm2 save
        log_success "Frontend applications started"
        pm2 status
        ;;
    stop)
        log_info "Stopping all services..."
        pm2 stop ecosystem.config.js
        log_success "All services stopped"
        ;;
    stop:all)
        log_info "Stopping all PM2 processes..."
        pm2 stop all
        log_success "All PM2 processes stopped"
        ;;
    restart)
        log_info "Restarting all services..."
        pm2 restart ecosystem.config.js
        log_success "All services restarted"
        ;;
    restart:all)
        log_info "Restarting all PM2 processes..."
        pm2 restart all
        log_success "All PM2 processes restarted"
        ;;
    delete)
        log_info "Deleting all services from PM2..."
        pm2 delete ecosystem.config.js
        log_success "All services deleted from PM2"
        ;;
    delete:all)
        log_warn "Deleting all PM2 processes..."
        pm2 delete all
        pm2 kill
        log_success "All PM2 processes deleted and PM2 daemon stopped"
        ;;
    logs)
        pm2 logs
        ;;
    logs:admin)
        pm2 logs frontend-admin
        ;;
    logs:gateway)
        pm2 logs api-gateway
        ;;
    monit)
        pm2 monit
        ;;
    status)
        pm2 status
        ;;
    save)
        pm2 save
        log_success "PM2 process list saved"
        ;;
    startup)
        log_info "Setting up PM2 startup script..."
        pm2 startup
        log_success "PM2 startup configured"
        ;;
    setup)
        log_info "Full PM2 setup..."
        mkdir -p .logs
        pm2 start ecosystem.config.js
        pm2 save
        pm2 startup
        log_success "PM2 setup complete!"
        log_info "Services are running. Use 'pm2 status' to check status."
        pm2 status
        ;;
    help|*)
        echo "PM2 Management Script"
        echo ""
        echo "Usage: ./scripts/pm2-setup.sh [command]"
        echo ""
        echo "Commands:"
        echo "  start              Start all services"
        echo "  start:critical     Start only critical services"
        echo "  start:backend      Start all backend services"
        echo "  start:frontend     Start all frontend applications"
        echo "  stop               Stop all services"
        echo "  stop:all           Stop all PM2 processes"
        echo "  restart            Restart all services"
        echo "  restart:all        Restart all PM2 processes"
        echo "  delete             Delete all services from PM2"
        echo "  delete:all         Delete all PM2 processes and kill daemon"
        echo "  logs               View all logs (streaming)"
        echo "  logs:admin         View admin frontend logs"
        echo "  logs:gateway       View API gateway logs"
        echo "  monit              Open PM2 monitoring dashboard"
        echo "  status             Show PM2 status"
        echo "  save               Save current PM2 process list"
        echo "  startup            Setup PM2 to start on system boot"
        echo "  setup              Full setup (start + save + startup)"
        echo "  help               Show this help message"
        ;;
esac


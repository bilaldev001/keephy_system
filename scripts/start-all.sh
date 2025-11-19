#!/bin/bash

#
# HRMS System Startup Script
# 
# This script starts all backend services and frontend applications
# using a simpler bash-based approach
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"

# PID file directory
PID_DIR="$ROOT_DIR/.pids"
mkdir -p "$PID_DIR"

# Log directory
LOG_DIR="$ROOT_DIR/.logs"
mkdir -p "$LOG_DIR"

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_section() {
    echo -e "\n${CYAN}============================================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}============================================================${NC}\n"
}

# Cleanup function
cleanup() {
    log_section "Cleaning Up"
    log_info "Stopping all services..."
    
    if [ -d "$PID_DIR" ]; then
        for pidfile in "$PID_DIR"/*.pid; do
            if [ -f "$pidfile" ]; then
                pid=$(cat "$pidfile")
                name=$(basename "$pidfile" .pid)
                if kill -0 "$pid" 2>/dev/null; then
                    kill "$pid" 2>/dev/null || true
                    log_success "Stopped $name (PID: $pid)"
                fi
                rm -f "$pidfile"
            fi
        done
    fi
    
    # Kill any remaining node processes started by this script
    pkill -f "npm run start:dev" 2>/dev/null || true
    pkill -f "npm run dev" 2>/dev/null || true
    
    log_success "Cleanup complete"
}

# Handle signals
trap cleanup EXIT INT TERM

# Check if port is available
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        return 1
    else
        return 0
    fi
}

# Start a backend service
start_backend_service() {
    local service_name=$1
    local port=$2
    local service_path=$3
    local critical=$4
    
    if ! check_port $port; then
        log_warn "Port $port is already in use, skipping $service_name"
        return 1
    fi
    
    log_info "Starting $service_name on port $port..."
    
    cd "$BACKEND_DIR/$service_path" || {
        log_warn "$service_name not found, skipping"
        return 1
    }
    
    npm run start:dev > "$LOG_DIR/${service_name}.log" 2>&1 &
    local pid=$!
    echo $pid > "$PID_DIR/${service_name}.pid"
    
    if [ $critical = "true" ]; then
        sleep 3
        if ! kill -0 $pid 2>/dev/null; then
            log_error "Critical service $service_name failed to start"
            return 1
        fi
    fi
    
    log_success "$service_name started (PID: $pid)"
    return 0
}

# Start a frontend app
start_frontend_app() {
    local app_name=$1
    local port=$2
    local app_path=$3
    local critical=$4
    
    if ! check_port $port; then
        log_warn "Port $port is already in use, skipping $app_name"
        return 1
    fi
    
    log_info "Starting $app_name on http://localhost:$port..."
    
    cd "$FRONTEND_DIR/$app_path" || {
        log_warn "$app_name not found, skipping"
        return 1
    }
    
    PORT=$port npm run dev > "$LOG_DIR/${app_name}.log" 2>&1 &
    local pid=$!
    echo $pid > "$PID_DIR/${app_name}.pid"
    
    if [ $critical = "true" ]; then
        sleep 2
        if ! kill -0 $pid 2>/dev/null; then
            log_error "Critical app $app_name failed to start"
            return 1
        fi
    fi
    
    log_success "$app_name started (PID: $pid) - http://localhost:$port"
    return 0
}

# Main execution
main() {
    log_section "HRMS System Startup"
    
    # Check arguments
    CRITICAL_ONLY=false
    SKIP_INSTALL=false
    
    for arg in "$@"; do
        case $arg in
            --critical-only)
                CRITICAL_ONLY=true
                ;;
            --skip-install)
                SKIP_INSTALL=true
                ;;
            --help)
                echo "Usage: $0 [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --critical-only    Start only critical services"
                echo "  --skip-install     Skip dependency installation"
                echo "  --help             Show this help message"
                exit 0
                ;;
        esac
    done
    
    # Install dependencies
    if [ "$SKIP_INSTALL" = false ]; then
        log_section "Installing Dependencies"
    log_info "Installing backend dependencies..."
    cd "$BACKEND_DIR" && npm install --legacy-peer-deps
    log_success "Backend dependencies installed"
    
    log_info "Installing frontend dependencies..."
    cd "$FRONTEND_DIR" && npm install
    log_success "Frontend dependencies installed"
    else
        log_info "Skipping dependency installation"
    fi
    
    # Start backend services
    log_section "Starting Backend Services"
    
    # Critical services first
    start_backend_service "api-gateway" 4000 "services/api-gateway" true
    start_backend_service "identity-service" 4001 "services/identity-service" true
    start_backend_service "access-service" 4002 "services/access-service" true
    
    if [ "$CRITICAL_ONLY" = false ]; then
        start_backend_service "admin-service" 4028 "services/admin-service" false
        start_backend_service "media-service" 4003 "services/media-service" false
        start_backend_service "contacts-service" 4004 "services/contacts-service" false
        start_backend_service "billing-service" 4012 "services/billing-service" false
        start_backend_service "hrms-service" 4015 "services/hrms-service" false
        start_backend_service "analytics-service" 4021 "services/analytics-service" false
        start_backend_service "crm-service" 4018 "services/crm-service" false
        start_backend_service "ai-service" 4029 "services/ai-service" false
    fi
    
    log_info "Waiting for backend services to initialize..."
    sleep 10
    
    # Start frontend applications
    log_section "Starting Frontend Applications"
    
    start_frontend_app "admin" 4205 "admin" true
    
    if [ "$CRITICAL_ONLY" = false ]; then
        start_frontend_app "analytics" 4206 "analytics" false
        start_frontend_app "billing" 4207 "billing" false
        start_frontend_app "hrms" 4213 "hrms" false
        start_frontend_app "crm" 4209 "crm" false
    fi
    
    log_section "System Ready!"
    log_success "All services are running"
    echo ""
    log_info "Key URLs:"
    echo "  API Gateway:     http://localhost:4000"
    echo "  Admin Frontend:  http://localhost:4205"
    echo ""
    log_info "Logs are available in: $LOG_DIR"
    log_info "PID files are in: $PID_DIR"
    echo ""
    log_info "Press Ctrl+C to stop all services"
    
    # Wait for interrupt
    wait
}

main "$@"


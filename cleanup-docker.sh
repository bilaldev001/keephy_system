#!/bin/bash

# Keephy Platform - Complete Docker Cleanup Script
# This script removes all containers, images, builds, volumes, and the database

set -e

echo "=========================================="
echo "  Keephy Platform - Docker Cleanup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Step 1: Stop all running containers
echo "Step 1: Stopping all running containers..."
if [ "$(docker ps -q)" ]; then
    docker stop $(docker ps -q) 2>/dev/null || true
    print_info "All containers stopped"
else
    print_warning "No running containers found"
fi
echo ""

# Step 2: Remove all containers
echo "Step 2: Removing all containers..."
if [ "$(docker ps -aq)" ]; then
    docker rm $(docker ps -aq) 2>/dev/null || true
    print_info "All containers removed"
else
    print_warning "No containers found"
fi
echo ""

# Step 3: Remove all images
echo "Step 3: Removing all Docker images..."
if [ "$(docker images -q)" ]; then
    docker rmi -f $(docker images -q) 2>/dev/null || true
    print_info "All images removed"
else
    print_warning "No images found"
fi
echo ""

# Step 4: Remove all volumes
echo "Step 4: Removing all Docker volumes..."
if [ "$(docker volume ls -q)" ]; then
    docker volume rm $(docker volume ls -q) 2>/dev/null || true
    print_info "All volumes removed"
else
    print_warning "No volumes found"
fi
echo ""

# Step 5: Remove all networks (except default ones)
echo "Step 5: Removing custom Docker networks..."
NETWORKS=$(docker network ls --filter "type=custom" -q)
if [ -n "$NETWORKS" ]; then
    for network in $NETWORKS; do
        docker network rm $network 2>/dev/null || true
    done
    print_info "Custom networks removed"
else
    print_warning "No custom networks found"
fi
echo ""

# Step 6: Prune system (removes unused data)
echo "Step 6: Pruning Docker system..."
docker system prune -af --volumes 2>/dev/null || true
print_info "Docker system pruned"
echo ""

# Step 7: Remove build cache
echo "Step 7: Removing build cache..."
docker builder prune -af 2>/dev/null || true
print_info "Build cache removed"
echo ""

# Step 8: Remove database data directory (if exists)
echo "Step 8: Removing local database data..."
if [ -d "./postgres_data" ]; then
    rm -rf ./postgres_data
    print_info "Local postgres_data directory removed"
fi

if [ -d "./backend/postgres_data" ]; then
    rm -rf ./backend/postgres_data
    print_info "Backend postgres_data directory removed"
fi
echo ""

# Step 9: Final verification
echo "Step 9: Verifying cleanup..."
CONTAINERS=$(docker ps -aq | wc -l)
IMAGES=$(docker images -q | wc -l)
VOLUMES=$(docker volume ls -q | wc -l)

echo ""
echo "=========================================="
echo "  Cleanup Summary"
echo "=========================================="
echo "  Containers remaining: $CONTAINERS"
echo "  Images remaining: $IMAGES"
echo "  Volumes remaining: $VOLUMES"
echo ""

if [ "$CONTAINERS" -eq 0 ] && [ "$IMAGES" -eq 0 ] && [ "$VOLUMES" -eq 0 ]; then
    print_info "Complete cleanup successful! Docker is now fresh."
else
    print_warning "Some resources may still exist (default Docker resources)"
fi

echo ""
echo "=========================================="
echo "  Cleanup Complete!"
echo "=========================================="
echo ""
echo "You can now run ./start-docker.sh for a fresh setup"
echo ""


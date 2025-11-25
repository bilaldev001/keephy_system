# Docker Guide for Keephy Platform

This guide will help you get started with Docker and run all services easily, even if you're new to Docker.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Using the Startup Script](#using-the-startup-script)
4. [Manual Docker Commands](#manual-docker-commands)
5. [Viewing Logs](#viewing-logs)
6. [Troubleshooting](#troubleshooting)
7. [Environment Variables](#environment-variables)

## Prerequisites

### Install Docker

1. **Download Docker Desktop:**
   - Visit: https://www.docker.com/products/docker-desktop
   - Download for your operating system (Mac, Windows, or Linux)
   - Install and start Docker Desktop

2. **Verify Installation:**
   ```bash
   docker --version
   docker compose version
   ```

   You should see version numbers for both commands.

## Quick Start

### Option 1: Using the Startup Script (Recommended for Beginners)

1. **Make the script executable (first time only):**
   ```bash
   chmod +x start.sh
   ```

2. **Run the script:**
   ```bash
   ./start.sh
   ```

3. **Select option 1** to start all services

4. **Wait for services to start** (this may take a few minutes the first time)

5. **Access the applications:**
   - Marketing Site: http://localhost:3074
   - API Gateway: http://localhost:3010
   - FBMS: http://localhost:3088

### Option 2: Using Docker Compose Directly

1. **Start all services:**
   ```bash
   docker compose up -d
   ```

2. **Check service status:**
   ```bash
   docker compose ps
   ```

3. **View logs:**
   ```bash
   docker compose logs -f
   ```

## Using the Startup Script

The `start.sh` script provides an interactive menu with the following options:

### Menu Options

1. **Start all services** - Starts all backend and frontend services
2. **Start specific services** - Start only the services you need
3. **Stop all services** - Stops all running services
4. **Restart all services** - Restarts all services
5. **View service logs** - View logs from any service
6. **Check service status** - Check if services are running
7. **View service URLs** - See all available service URLs
8. **Clean up** - Stop and remove all containers
9. **Exit** - Exit the script

### Examples

**Start only the database and API gateway:**
```bash
./start.sh
# Select option 2
# Enter: postgres api-gateway
```

**View logs for a specific service:**
```bash
./start.sh
# Select option 5
# Enter service name: api-gateway
```

**Check if everything is running:**
```bash
./start.sh
# Select option 6
```

## Manual Docker Commands

If you prefer to use Docker commands directly, here are the most common ones:

### Starting Services

```bash
# Start all services in the background
docker compose up -d

# Start specific services
docker compose up -d postgres api-gateway frontend-marketing

# Start and see logs in real-time
docker compose up
```

### Stopping Services

```bash
# Stop all services
docker compose down

# Stop specific services
docker compose stop api-gateway

# Stop and remove containers
docker compose down
```

### Viewing Logs

```bash
# View logs for all services
docker compose logs -f

# View logs for a specific service
docker compose logs -f api-gateway

# View last 100 lines of logs
docker compose logs --tail=100 api-gateway

# View logs for multiple services
docker compose logs -f api-gateway frontend-marketing
```

### Checking Status

```bash
# List all services and their status
docker compose ps

# Check if a specific service is running
docker compose ps api-gateway

# View resource usage
docker stats
```

### Restarting Services

```bash
# Restart all services
docker compose restart

# Restart a specific service
docker compose restart api-gateway
```

### Cleaning Up

```bash
# Stop and remove containers
docker compose down

# Stop, remove containers, and volumes
docker compose down -v

# Remove unused images
docker image prune

# Remove all unused resources
docker system prune
```

## Viewing Logs

Logs are essential for debugging. Here are different ways to view them:

### Real-time Logs (Follow Mode)

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f api-gateway

# Multiple services
docker compose logs -f api-gateway fbms-service
```

### Historical Logs

```bash
# Last 50 lines
docker compose logs --tail=50 api-gateway

# Last 100 lines with timestamps
docker compose logs --tail=100 -t api-gateway

# Logs since a specific time
docker compose logs --since 10m api-gateway
```

### Filtering Logs

```bash
# Search for errors
docker compose logs api-gateway | grep -i error

# Search for specific text
docker compose logs api-gateway | grep "listening"
```

## Troubleshooting

### Services Won't Start

1. **Check Docker is running:**
   ```bash
   docker ps
   ```
   If this fails, start Docker Desktop.

2. **Check for port conflicts:**
   ```bash
   # On Mac/Linux
   lsof -i :4000
   
   # On Windows
   netstat -ano | findstr :4000
   ```
   If a port is in use, either stop the conflicting service or change the port in `.env.backend`.

3. **View error logs:**
   ```bash
   docker compose logs service-name
   ```

4. **Restart Docker:**
   - Sometimes Docker needs a restart
   - Restart Docker Desktop and try again

### Services Keep Restarting

1. **Check logs for errors:**
   ```bash
   docker compose logs service-name
   ```

2. **Check service health:**
   ```bash
   docker compose ps
   ```
   Look for services with status "Restarting"

3. **Check database connection:**
   ```bash
   docker compose logs postgres
   ```

### Can't Connect to Services

1. **Verify services are running:**
   ```bash
   docker compose ps
   ```

2. **Check if ports are exposed:**
   ```bash
   docker compose ps
   ```
   Look for the port mappings (e.g., `0.0.0.0:4000->4000/tcp`)

3. **Test connectivity:**
   ```bash
   curl http://localhost:3010/health
   ```

### Out of Memory

If you see memory errors:

1. **Increase Docker memory limit:**
   - Docker Desktop → Settings → Resources → Memory
   - Increase to at least 4GB

2. **Start fewer services:**
   ```bash
   docker compose up -d postgres api-gateway frontend-marketing
   ```

### Database Connection Issues

1. **Check if database is running:**
   ```bash
   docker compose ps postgres
   ```

2. **Check database logs:**
   ```bash
   docker compose logs postgres
   ```

3. **Verify connection string in `.env.backend`:**
   ```
   DATABASE_URL=postgresql://postgres:postgres@postgres:5432/hrmssystem
   ```

## Environment Variables

### Setup

1. **Copy example files:**
   ```bash
   cp .env.backend.example .env.backend
   cp .env.frontend.example .env.frontend
   ```

2. **Edit the files** with your configuration:
   ```bash
   # Edit backend environment
   nano .env.backend
   
   # Edit frontend environment
   nano .env.frontend
   ```

### Backend Environment Variables

The `.env.backend` file contains:
- Database configuration
- Service URLs
- JWT secrets
- API keys

**Important:** Never commit `.env.backend` or `.env.frontend` to git!

### Frontend Environment Variables

The `.env.frontend` file contains:
- API Gateway URL
- Service URLs
- Feature flags

## Service URLs

Once services are running, you can access them at:

### Backend Services
- API Gateway: http://localhost:3010
- Identity Service: http://localhost:3012
- Access Service: http://localhost:3014
- FBMS Service: http://localhost:3020

### Frontend Applications
- Marketing: http://localhost:3074
- Builder: http://localhost:3080
- Forms: http://localhost:3082
- HRMS: http://localhost:3084
- Vouchers: http://localhost:3086
- FBMS: http://localhost:3088
- CRM: http://localhost:3090
- Billing: http://localhost:3092
- Analytics: http://localhost:3094
- Compliance: http://localhost:3096
- EMS: http://localhost:3098
- Inventory: http://localhost:3100
- SCM: http://localhost:3102
- Support: http://localhost:3104

## Common Workflows

### Daily Development

```bash
# Start services in the morning
./start.sh
# Select option 1

# View logs while working
./start.sh
# Select option 5, then enter service name

# Stop services at end of day
./start.sh
# Select option 3
```

### Debugging a Service

```bash
# View logs
docker compose logs -f service-name

# Restart the service
docker compose restart service-name

# Check service status
docker compose ps service-name
```

### Adding a New Service

1. Add service to `docker-compose.yml`
2. Add environment variables to `.env.backend` or `.env.frontend`
3. Restart services:
   ```bash
   docker compose up -d
   ```

## Getting Help

If you encounter issues:

1. Check the logs first: `docker compose logs service-name`
2. Verify Docker is running: `docker ps`
3. Check service status: `docker compose ps`
4. Review this guide's troubleshooting section
5. Check the main README.md for more information

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Desktop Guide](https://docs.docker.com/desktop/)

---

**Note:** The first time you start services, Docker will download images and build containers, which may take several minutes. Subsequent starts will be much faster.


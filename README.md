# Keephy Platform

A comprehensive HRMS and business management platform built with microservices architecture.

## Quick Start

### For Developers New to Docker

1. **Install Docker Desktop:**
   - Download from: https://www.docker.com/products/docker-desktop
   - Install and start Docker Desktop

2. **Run the startup script:**
   ```bash
   chmod +x start.sh
   ./start.sh
   ```
   Select option 1 to start all services.

3. **Access the applications:**
   - Marketing Site: http://localhost:3074
   - API Gateway: http://localhost:3010
   - FBMS: http://localhost:3088

**For detailed Docker instructions, see [DOCKER_GUIDE.md](./DOCKER_GUIDE.md)**

### For Experienced Developers

```bash
# Setup environment files
cp .env.backend.example .env.backend
cp .env.frontend.example .env.frontend

# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Check status
docker compose ps
```

## Project Structure

```
.
├── backend/              # Backend microservices
│   ├── services/        # Individual service implementations
│   └── libs/            # Shared libraries
├── frontend/            # Frontend applications
│   ├── marketing/       # Marketing website
│   ├── fbms/            # Feedback Management System
│   └── packages/        # Shared frontend packages
├── docker-compose.yml   # Docker Compose configuration
├── start.sh             # Interactive startup script
├── .env.backend         # Backend environment variables
└── .env.frontend        # Frontend environment variables
```

## Services

### Backend Services (31 total)

- **api-gateway** (4000) - API Gateway for routing requests
- **identity-service** (4001) - Authentication and user management
- **access-service** (4002) - Authorization and permissions
- **fbms-service** (4014) - Feedback Management System
- **hrms-service** (4015) - Human Resource Management
- And 26 more services...

### Frontend Applications (15 total)

- **marketing** (5200) - Marketing website
- **fbms** (5005) - Feedback Management System UI
- **hrms** (4213) - HRMS UI
- And 12 more applications...

See [DOCKER_GUIDE.md](./DOCKER_GUIDE.md) for complete list of service URLs.

## Documentation

- **[DOCKER_GUIDE.md](./DOCKER_GUIDE.md)** - Complete Docker guide with troubleshooting
- **[docs/developer-guide.md](./docs/developer-guide.md)** - Developer documentation
- **[backend/docs/](./backend/docs/)** - Backend service documentation

## Environment Setup

### Backend Environment

Copy and configure `.env.backend`:
```bash
cp .env.backend.example .env.backend
# Edit .env.backend with your configuration
```

### Frontend Environment

Copy and configure `.env.frontend`:
```bash
cp .env.frontend.example .env.frontend
# Edit .env.frontend with your configuration
```

## Common Commands

### Using the Startup Script

```bash
./start.sh
# Interactive menu with options:
# 1. Start all services
# 2. Start specific services
# 3. Stop all services
# 4. Restart all services
# 5. View logs
# 6. Check status
# 7. View URLs
# 8. Clean up
```

### Using Docker Compose Directly

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f

# Restart a service
docker compose restart api-gateway

# Check status
docker compose ps
```

## Development

### Running Services Locally (without Docker)

See individual service README files in `backend/services/` and `frontend/` directories.

### Adding a New Service

1. Create service in `backend/services/` or `frontend/`
2. Add service configuration to `docker-compose.yml`
3. Add environment variables to `.env.backend` or `.env.frontend`
4. Restart services: `docker compose up -d`

## Troubleshooting

### Services Won't Start

1. Check Docker is running: `docker ps`
2. Check for port conflicts
3. View logs: `docker compose logs service-name`
4. See [DOCKER_GUIDE.md](./DOCKER_GUIDE.md) for detailed troubleshooting

### Can't Connect to Services

1. Verify services are running: `docker compose ps`
2. Check service logs: `docker compose logs service-name`
3. Verify ports are exposed correctly

## Contributing

1. Create a feature branch
2. Make your changes
3. Test with Docker: `docker compose up -d`
4. Submit a pull request

## License

[Your License Here]

## Support

For issues and questions:
- Check [DOCKER_GUIDE.md](./DOCKER_GUIDE.md) for Docker-related issues
- Check [docs/developer-guide.md](./docs/developer-guide.md) for development questions
- Open an issue on GitHub

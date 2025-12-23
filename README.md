# System Config Service

The System Config Service is a microservice responsible for managing all common system configurations and master data for the entire SaaS platform.

## Overview

This service provides centralized management and APIs for all system-wide configurations including:

- **Application Components**: Core application components and their configurations
- **SaaS Modules**: Available modules for the SaaS platform
- **Service Packages**: Subscription tiers and pricing packages
- **Admin Menus**: Dynamic menu configurations for admin interfaces
- **Permissions**: Fine-grained permissions for RBAC
- **Roles**: Role definitions and their associated permissions
- **Master Data**: Countries, ethnicities, provinces, districts, wards, currencies

## Features

- **Multi-tenancy Support**: Tenant-specific configurations for customizable entities
- **Global Master Data**: Shared master data across all tenants
- **Redis Caching**: Performance optimization with Redis caching for frequently accessed data
- **MongoDB Storage**: Flexible document storage with proper indexing
- **REST APIs**: Complete RESTful API endpoints for all entities
- **gRPC Support**: High-performance inter-service communication
- **Internationalization**: Multi-language support (en, vi) for master data

## Tech Stack

- **Language**: Go 1.21+
- **Framework**: Gin
- **Database**: MongoDB
- **Cache**: Redis
- **Message Queue**: RabbitMQ
- **gRPC**: For inter-service communication

## Architecture

```
HTTP Requests → Router → Handler → Service → Repository → MongoDB
                                  ↓
                               Redis (Cache)
```

## API Endpoints

### Application Components
- `GET    /api/v1/system-config/app-components`
- `GET    /api/v1/system-config/app-components/:id`
- `POST   /api/v1/system-config/app-components`
- `PUT    /api/v1/system-config/app-components/:id`
- `DELETE /api/v1/system-config/app-components/:id`

### Countries
- `GET    /api/v1/system-config/countries`
- `GET    /api/v1/system-config/countries/:code`
- `POST   /api/v1/system-config/countries`
- `PUT    /api/v1/system-config/countries/:code`
- `DELETE /api/v1/system-config/countries/:code`

### Health Checks
- `GET /health` - Health check endpoint
- `GET /ready` - Readiness check endpoint

## Environment Variables

```bash
# Service Configuration
SYSTEM_CONFIG_SERVICE_PORT=50055       # gRPC port
SYSTEM_CONFIG_SERVICE_HTTP_PORT=8085   # HTTP port

# MongoDB
MONGODB_URI=mongodb://localhost:27017
MONGODB_DATABASE=saas_framework

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# Logging
LOG_LEVEL=info
ENVIRONMENT=development
```

## Running Locally

### Prerequisites
- Go 1.21+
- MongoDB
- Redis

### Build and Run

```bash
# Install dependencies
cd services/system-config-service
go mod download

# Build
go build -o bin/system-config-service ./cmd/main.go

# Run
./bin/system-config-service
```

## Running with Docker

```bash
# Build Docker image
docker build -f services/system-config-service/Dockerfile -t system-config-service:latest .

# Run container
docker run -p 8085:8085 -p 50055:50055 \
  -e MONGODB_URI=mongodb://mongo:27017 \
  -e REDIS_HOST=redis \
  system-config-service:latest
```

## Testing

```bash
# Run tests
go test ./...

# Run with coverage
go test -cover ./...
```

## Caching Strategy

The service implements a multi-level caching strategy:

1. **Master Data** (Countries, Currencies, Ethnicities): Cached for 24 hours
2. **Configuration Data** (App Components, Modules, Packages): Cached for 1 hour
3. **Cache Keys**: `system-config:{type}:{id}`

Cache is automatically invalidated on:
- Create operations
- Update operations
- Delete operations

## MongoDB Indexes

The service creates the following indexes for optimal query performance:

```javascript
// App Components
db.app_components.createIndex({ "tenant_id": 1, "code": 1 }, { unique: true });
db.app_components.createIndex({ "tenant_id": 1, "status": 1 });

// Countries
db.countries.createIndex({ "code": 1 }, { unique: true });
db.countries.createIndex({ "status": 1 });
```

## Future Enhancements

- [ ] Complete implementation of all entities (Roles, Permissions, Menus, etc.)
- [ ] Seed data for Vietnam locations (63 provinces, districts, wards)
- [ ] Seed data for 54 Vietnamese ethnicities
- [ ] Proto definitions and full gRPC support
- [ ] Batch import/export functionality
- [ ] Advanced search and filtering
- [ ] Audit logging for all changes
- [ ] Rate limiting and request throttling
- [ ] Comprehensive unit and integration tests
- [ ] API documentation with Swagger/OpenAPI

## License

MIT

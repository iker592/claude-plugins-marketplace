---
name: docker-builder
description: Dockerize Python applications using uv base images. Use when creating Dockerfiles, containerizing apps, or deploying Python services. Trigger keywords "docker", "dockerize", "container", "dockerfile", "deploy". ALWAYS use uv Docker images.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
user-invocable: true
---

# Docker Builder Skill

Dockerize Python applications using modern uv-based Docker images for fast, efficient containers.

## Quick Start

This skill helps with:
1. **Creating Dockerfiles** - uv-based multi-stage builds
2. **Docker Compose** - Local development environments
3. **Production deployment** - Optimized production images
4. **CI/CD integration** - Build and push workflows
5. **Security** - Non-root users, minimal attack surface

## Tech Stack

### Base Images
- **ghcr.io/astral-sh/uv:python3.11-bookworm** - Official uv images
- **ghcr.io/astral-sh/uv:python3.12-bookworm** - Latest Python
- **ghcr.io/astral-sh/uv:python3.11-alpine** - Minimal Alpine (use with caution)

### Required Files
```
project/
├── Dockerfile
├── .dockerignore
├── docker-compose.yml
├── pyproject.toml
└── uv.lock
```

## Dockerfile Templates

### Production FastAPI Application

```dockerfile
# syntax=docker/dockerfile:1

# Use official uv image
FROM ghcr.io/astral-sh/uv:python3.11-bookworm as builder

# Set working directory
WORKDIR /app

# Install system dependencies if needed
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies with uv (no dev dependencies)
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# Production stage
FROM python:3.11-slim-bookworm

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Set working directory
WORKDIR /app

# Copy Python dependencies from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application code
COPY --from=builder /app/src ./src

# Set PATH to use venv
ENV PATH="/app/.venv/bin:$PATH"

# Change ownership
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')"

# Run application
CMD ["uvicorn", "src.my_api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Development FastAPI Application

```dockerfile
# syntax=docker/dockerfile:1

FROM ghcr.io/astral-sh/uv:python3.11-bookworm

WORKDIR /app

# Install dependencies with dev packages
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Run with auto-reload
CMD ["uv", "run", "uvicorn", "src.my_api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

### Multi-Stage Build (Optimized)

```dockerfile
# syntax=docker/dockerfile:1

# Stage 1: Dependencies
FROM ghcr.io/astral-sh/uv:python3.11-bookworm as deps

WORKDIR /app

# Copy dependency files only
COPY pyproject.toml uv.lock ./

# Install dependencies (cached layer)
RUN uv sync --frozen --no-dev


# Stage 2: Builder
FROM ghcr.io/astral-sh/uv:python3.11-bookworm as builder

WORKDIR /app

# Copy dependencies from previous stage
COPY --from=deps /app/.venv /app/.venv

# Copy application code
COPY . .

# Run any build steps (if needed)
# RUN uv run python -m compileall src/


# Stage 3: Runtime
FROM python:3.11-slim-bookworm as runtime

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy virtual environment
COPY --from=builder /app/.venv /app/.venv

# Copy application
COPY --from=builder /app/src ./src

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Change ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

CMD ["uvicorn", "src.my_api.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

### Alpine-Based (Smaller Size)

```dockerfile
# syntax=docker/dockerfile:1

FROM ghcr.io/astral-sh/uv:python3.11-alpine as builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application
COPY . .


# Runtime
FROM python:3.11-alpine

RUN apk add --no-cache \
    ca-certificates \
    libffi

# Create non-root user
RUN addgroup -S appuser && adduser -S appuser -G appuser

WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src ./src

ENV PATH="/app/.venv/bin:$PATH"

RUN chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "src.my_api.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## .dockerignore

```
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
*.egg-info/
dist/
build/

# Virtual environments
venv/
env/
ENV/
.venv/  # Keep if using bind mounts in dev

# Testing
.pytest_cache/
.coverage
htmlcov/
*.cover
.hypothesis/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Git
.git/
.gitignore
.gitattributes

# CI/CD
.github/
.gitlab-ci.yml

# Documentation
docs/
*.md
!README.md

# Docker
Dockerfile*
docker-compose*.yml
.dockerignore

# Logs
*.log
logs/

# Environment
.env
.env.*
!.env.example

# OS
.DS_Store
Thumbs.db
```

## Docker Compose

### Development Environment

```yaml
# docker-compose.yml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Don't override venv
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/mydb
      - REDIS_URL=redis://redis:6379
      - ENV=development
    env_file:
      - .env.dev
    depends_on:
      - db
      - redis
    command: uv run uvicorn src.my_api.main:app --host 0.0.0.0 --port 8000 --reload

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  test:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - .:/app
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/test_db
    depends_on:
      - db
    command: uv run pytest
    profiles:
      - test

volumes:
  postgres_data:
  redis_data:
```

### Production Environment

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - PYTHON_VERSION=3.11
    restart: unless-stopped
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
      - ENV=production
    env_file:
      - .env.prod
    depends_on:
      - db
      - redis
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 3s
      retries: 3
      start_period: 10s
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      - api

volumes:
  postgres_data:
  redis_data:
```

## Building and Running

### Development

```bash
# Build development image
docker build -f Dockerfile.dev -t my-api:dev .

# Run container
docker run -p 8000:8000 --env-file .env.dev my-api:dev

# Or use docker compose
docker compose up

# Rebuild and run
docker compose up --build

# Run in background
docker compose up -d

# View logs
docker compose logs -f api

# Run tests
docker compose run --rm test

# Execute commands in container
docker compose exec api uv run pytest
docker compose exec api uv run ruff check .

# Stop containers
docker compose down

# Stop and remove volumes
docker compose down -v
```

### Production

```bash
# Build production image
docker build -t my-api:latest .

# Build with build args
docker build \
  --build-arg PYTHON_VERSION=3.12 \
  -t my-api:latest \
  .

# Tag for registry
docker tag my-api:latest registry.example.com/my-api:1.0.0

# Push to registry
docker push registry.example.com/my-api:1.0.0

# Run production
docker compose -f docker-compose.prod.yml up -d

# Scale service
docker compose -f docker-compose.prod.yml up -d --scale api=5
```

## Best Practices

### Use Official uv Images

```dockerfile
# ✅ DO - Official uv image
FROM ghcr.io/astral-sh/uv:python3.11-bookworm

# ❌ DON'T - Manual uv install
FROM python:3.11
RUN pip install uv
```

### Multi-Stage Builds

```dockerfile
# ✅ DO - Separate builder and runtime
FROM ghcr.io/astral-sh/uv:python3.11 as builder
# ... build steps ...

FROM python:3.11-slim as runtime
COPY --from=builder /app/.venv /app/.venv

# ❌ DON'T - Single stage with build tools in final image
FROM ghcr.io/astral-sh/uv:python3.11
RUN uv sync
# Build tools remain in final image
```

### Layer Caching

```dockerfile
# ✅ DO - Copy dependencies first for better caching
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev
COPY . .

# ❌ DON'T - Copy everything first
COPY . .
RUN uv sync --frozen --no-dev
```

### Non-Root User

```dockerfile
# ✅ DO - Run as non-root
RUN groupadd -r appuser && useradd -r -g appuser appuser
RUN chown -R appuser:appuser /app
USER appuser

# ❌ DON'T - Run as root
# (no USER directive)
```

### Environment Variables

```dockerfile
# ✅ DO - Set Python environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/app/.venv/bin:$PATH"

# ✅ DO - Use ARG for build-time variables
ARG PYTHON_VERSION=3.11
FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-bookworm
```

### Health Checks

```dockerfile
# ✅ DO - Add health checks
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')"

# ✅ Alternative - Use curl
HEALTHCHECK CMD curl -f http://localhost:8000/health || exit 1
```

### Minimal Final Image

```dockerfile
# ✅ DO - Use slim base for runtime
FROM python:3.11-slim-bookworm

# ❌ DON'T - Use full base image
FROM python:3.11-bookworm  # Much larger
```

## Security Best Practices

### Scan for Vulnerabilities

```bash
# Scan with trivy
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image my-api:latest

# Scan with docker scout
docker scout cves my-api:latest
```

### Minimal Dependencies

```dockerfile
# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*
```

### No Secrets in Images

```dockerfile
# ❌ NEVER - Don't bake secrets into images
ENV SECRET_KEY=my-secret-key

# ✅ DO - Use environment variables at runtime
# Pass via docker run or docker-compose
docker run -e SECRET_KEY=xxx my-api:latest
```

### Read-Only Filesystem

```yaml
# docker-compose.yml
services:
  api:
    image: my-api:latest
    read_only: true
    tmpfs:
      - /tmp
      - /var/run
```

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/docker.yml
name: Docker Build and Push

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=sha

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

### GitLab CI

```yaml
# .gitlab-ci.yml
variables:
  DOCKER_IMAGE: $CI_REGISTRY_IMAGE
  DOCKER_TAG: $CI_COMMIT_SHORT_SHA

stages:
  - build
  - test
  - deploy

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
    - docker push $DOCKER_IMAGE:$DOCKER_TAG
    - docker tag $DOCKER_IMAGE:$DOCKER_TAG $DOCKER_IMAGE:latest
    - docker push $DOCKER_IMAGE:latest

test:
  stage: test
  image: $DOCKER_IMAGE:$DOCKER_TAG
  script:
    - uv run pytest

deploy:
  stage: deploy
  image: alpine:latest
  script:
    - apk add --no-cache curl
    - curl -X POST $DEPLOY_WEBHOOK_URL
  only:
    - main
```

## Deployment Strategies

### Docker Swarm

```bash
# Initialize swarm
docker swarm init

# Deploy stack
docker stack deploy -c docker-compose.prod.yml myapp

# Scale service
docker service scale myapp_api=5

# Update service
docker service update --image my-api:v2 myapp_api

# Remove stack
docker stack rm myapp
```

### Kubernetes

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-api
  template:
    metadata:
      labels:
        app: my-api
    spec:
      containers:
      - name: api
        image: my-api:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: database-url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 10
```

## Optimization Tips

### Reduce Image Size

```dockerfile
# Use slim base images
FROM python:3.11-slim-bookworm  # ~45MB vs ~350MB full image

# Use Alpine for minimal size
FROM python:3.11-alpine  # ~15MB

# Multi-stage builds
# Only copy what's needed to runtime

# Clean up in same layer
RUN apt-get update && apt-get install -y pkg \
    && rm -rf /var/lib/apt/lists/*
```

### Build Cache

```bash
# Use BuildKit cache mounts
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Layer ordering (least to most frequently changed)
COPY pyproject.toml uv.lock ./  # Changes rarely
RUN uv sync                      # Cached if above unchanged
COPY . .                         # Changes often
```

### Faster Builds

```bash
# Enable BuildKit
export DOCKER_BUILDKIT=1

# Parallel builds
docker buildx build --platform linux/amd64,linux/arm64 .
```

## Common Issues

### Permission Errors

```dockerfile
# Fix ownership before switching user
COPY --chown=appuser:appuser . .
# OR
RUN chown -R appuser:appuser /app
USER appuser
```

### Large Image Size

```bash
# Check layer sizes
docker history my-api:latest

# Analyze with dive
dive my-api:latest
```

### Dependency Issues

```bash
# Ensure uv.lock is up to date
uv lock

# Use frozen install in Docker
RUN uv sync --frozen --no-dev
```

## Integration with Other Skills

- **fastapi-builder** - Containerize FastAPI apps
- **test-runner** - Run tests in containers
- Automatically build on code changes via hooks

---

**Version:** 1.0.0
**Base Images:** uv official Docker images
**Last Updated:** January 10, 2026

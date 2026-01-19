---
description: Create Dockerfile for FastAPI application
---

# Dockerize Command

Create production-ready Dockerfile using uv base images.

## Usage

```
/py-dev:dockerize
/py-dev:dockerize --with-compose
```

## Instructions

1. Check if Dockerfile exists
2. **Create Dockerfile**:
   - Multi-stage build with uv images
   - Non-root user
   - Health check
   - Production optimizations
3. **Create .dockerignore**
4. **Optionally create docker-compose.yml** (if --with-compose flag)
5. **Build and test**:
   - `docker build -t app:latest .`
   - Verify successful build
6. Provide usage instructions

Invoke **docker-builder** skill for templates.

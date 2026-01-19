---
description: Scaffold a new Python project with uv, FastAPI, and pytest
---

# New Project Command

Create a production-ready Python project with modern tooling.

## Usage

```
/py-dev:new-project <project-name>
/py-dev:new-project my-api
```

## Instructions

When the user runs this command:

1. **Parse project name** from `$ARGUMENTS`
2. **Invoke project-scaffold MCP server** or create structure manually
3. **Create project structure** with:
   - `uv init <project-name>`
   - Standard FastAPI structure (src/, tests/, etc.)
   - Configuration files (pyproject.toml, .env.example, etc.)
4. **Add dependencies**:
   - fastapi, uvicorn, pydantic, pydantic-settings
   - pytest, pytest-asyncio, httpx, ruff (dev)
5. **Create initial files**:
   - main.py with basic FastAPI app
   - conftest.py with test fixtures
   - Dockerfile with uv base image
   - .dockerignore, .gitignore
   - README.md
6. **Initialize git** repository
7. **Report** created structure and next steps

Use the **fastapi-builder** skill for implementation details.

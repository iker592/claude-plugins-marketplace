# Enterprise Python Developer Plugin

Modern Python development plugin for Claude Code featuring uv, FastAPI, pytest, and Docker.

## 🎯 Tech Stack

- **uv** - Modern Python package manager (NOT pip)
- **FastAPI** - High-performance web framework
- **pytest** - Testing framework (NEVER unittest)
- **Docker** - Containerization with uv base images
- **Ruff** - Fast Python linter and formatter

## 📦 Components

### Skills (4) - Auto-Invoked
- **fastapi-builder** - Build FastAPI applications
- **test-runner** - Run pytest tests with coverage
- **docker-builder** - Dockerize apps with uv images
- **api-designer** - Design REST APIs

### Commands (4) - User-Invoked
- `/py-dev:new-project <name>` - Scaffold new project
- `/py-dev:add-endpoint <resource>` - Add FastAPI endpoint
- `/py-dev:test [path]` - Run pytest tests
- `/py-dev:dockerize` - Create Dockerfile

### Agents (4) - Specialized Experts
- **api-architect** - REST API design expert
- **test-engineer** - pytest specialist
- **devops-engineer** - Docker & deployment expert
- **code-reviewer** - Python code review specialist

### Hooks (2)
- **format-code.sh** - Auto-format with ruff after edits
- **check-deps.sh** - Verify uv dependencies on start

### MCP Servers (2)
- **project-tools** - Project scaffolding
- **test-tools** - Test execution

## 🚀 Installation

```bash
# Test locally
claude --plugin-dir ./enterprise-py-developer

# Or install from GitHub (after merge)
/plugin install iker592/Brain/enterprise-py-developer
```

## 💡 Usage Examples

```
# Create new FastAPI project
/py-dev:new-project my-api

# Add endpoint
/py-dev:add-endpoint users

# Run tests
/py-dev:test

# Dockerize
/py-dev:dockerize
```

## ✅ Best Practices Enforced

- ✅ Uses **uv** (NOT pip)
- ✅ Uses **pytest** (NEVER unittest)
- ✅ Docker with **uv base images**
- ✅ FastAPI with **async endpoints**
- ✅ Type hints on all functions
- ✅ Auto-formatting with **ruff**
- ✅ Comprehensive test coverage

## 📚 Documentation

See individual skill files for comprehensive guides:
- `skills/fastapi-builder/SKILL.md`
- `skills/test-runner/SKILL.md`
- `skills/docker-builder/SKILL.md`
- `skills/api-designer/SKILL.md`

---

**Version:** 1.0.0  
**Author:** Iker  
**License:** MIT

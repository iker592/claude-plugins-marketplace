---
description: Add a new FastAPI endpoint with CRUD operations
---

# Add Endpoint Command

Add a new REST API endpoint following best practices.

## Usage

```
/py-dev:add-endpoint <resource-name>
/py-dev:add-endpoint users
/py-dev:add-endpoint posts
```

## Instructions

1. Parse resource name from `$ARGUMENTS`
2. Create plural/singular forms (users/user, posts/post)
3. **Generate files**:
   - `src/my_api/models/<resource>.py` - SQLModel model
   - `src/my_api/schemas/<resource>.py` - Pydantic schemas (Create, Read, Update)
   - `src/my_api/crud/<resource>.py` - CRUD operations
   - `src/my_api/api/v1/endpoints/<resource>.py` - FastAPI router
   - `tests/test_api/test_<resource>.py` - pytest tests
4. **Add router** to `api/v1/router.py`
5. **Run tests** to verify
6. Report created files

Invoke **fastapi-builder** and **test-runner** skills.

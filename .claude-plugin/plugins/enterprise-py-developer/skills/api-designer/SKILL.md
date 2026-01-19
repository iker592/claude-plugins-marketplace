---
name: api-designer
description: Design REST APIs following best practices. Use when planning API architecture, designing endpoints, creating OpenAPI specs, or establishing API patterns. Trigger keywords "design api", "api structure", "rest api", "openapi", "api schema".
allowed-tools: Read, Write, Edit, Grep, Glob
model: sonnet
user-invocable: true
---

# API Designer Skill

Design production-ready REST APIs following industry best practices and RESTful principles.

## Quick Start

This skill helps with:
1. **API Architecture** - Plan overall API structure
2. **Endpoint Design** - RESTful route patterns
3. **Schema Definition** - Request/response models
4. **OpenAPI Specs** - Auto-generated documentation
5. **Versioning Strategy** - API evolution patterns

## REST API Principles

### HTTP Methods

```
GET     - Retrieve resources (idempotent, safe)
POST    - Create new resources
PUT     - Update/replace entire resource (idempotent)
PATCH   - Partial update of resource
DELETE  - Remove resource (idempotent)
```

### Status Codes

```
2xx - Success
200 OK           - Successful GET, PUT, PATCH, DELETE
201 Created      - Successful POST (resource created)
204 No Content   - Successful DELETE (no body)

4xx - Client Errors
400 Bad Request  - Invalid request data
401 Unauthorized - Authentication required
403 Forbidden    - Authenticated but no permission
404 Not Found    - Resource doesn't exist
422 Unprocessable Entity - Validation error

5xx - Server Errors
500 Internal Server Error
503 Service Unavailable
```

## URL Design Patterns

### Resource Naming

```
# ✅ Good - Plural nouns, hierarchical
GET    /api/v1/users
GET    /api/v1/users/{id}
POST   /api/v1/users
PUT    /api/v1/users/{id}
DELETE /api/v1/users/{id}

GET    /api/v1/users/{user_id}/posts
GET    /api/v1/users/{user_id}/posts/{post_id}

# ❌ Bad - Verbs in URLs
GET    /api/v1/getUsers
POST   /api/v1/createUser
```

### Filtering and Pagination

```
# Filtering
GET /api/v1/users?status=active
GET /api/v1/users?role=admin&status=active

# Sorting
GET /api/v1/users?sort=created_at
GET /api/v1/users?sort=-created_at  # Descending

# Pagination
GET /api/v1/users?skip=0&limit=20
GET /api/v1/users?page=1&per_page=20

# Search
GET /api/v1/users?search=john
GET /api/v1/users?q=john+doe

# Field selection
GET /api/v1/users?fields=id,email,name
```

## FastAPI Implementation

### Endpoint Structure

```python
from fastapi import APIRouter, Depends, Query, Path
from typing import Optional

router = APIRouter(prefix="/api/v1")


# List resources
@router.get("/users", response_model=list[UserRead])
async def list_users(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    status: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    """
    List users with pagination and filtering.

    - **skip**: Number of records to skip (default: 0)
    - **limit**: Maximum records to return (default: 100)
    - **status**: Filter by status (optional)
    """
    return crud.get_users(db, skip=skip, limit=limit, status=status)


# Get single resource
@router.get("/users/{user_id}", response_model=UserRead)
async def get_user(
    user_id: int = Path(..., gt=0),
    db: Session = Depends(get_db),
):
    """Get user by ID."""
    user = crud.get_user(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


# Create resource
@router.post("/users", response_model=UserRead, status_code=201)
async def create_user(
    user_in: UserCreate,
    db: Session = Depends(get_db),
):
    """Create new user."""
    return crud.create_user(db, obj_in=user_in)


# Update resource (full)
@router.put("/users/{user_id}", response_model=UserRead)
async def update_user(
    user_id: int = Path(..., gt=0),
    user_in: UserUpdate,
    db: Session = Depends(get_db),
):
    """Update user (full replacement)."""
    user = crud.get_user(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return crud.update_user(db, db_obj=user, obj_in=user_in)


# Update resource (partial)
@router.patch("/users/{user_id}", response_model=UserRead)
async def partial_update_user(
    user_id: int = Path(..., gt=0),
    user_in: UserPartialUpdate,
    db: Session = Depends(get_db),
):
    """Partially update user."""
    user = crud.get_user(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return crud.update_user(db, db_obj=user, obj_in=user_in)


# Delete resource
@router.delete("/users/{user_id}", status_code=204)
async def delete_user(
    user_id: int = Path(..., gt=0),
    db: Session = Depends(get_db),
):
    """Delete user."""
    user = crud.get_user(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    crud.delete_user(db, id=user_id)
```

## Schema Design with Pydantic

### Base Schemas

```python
from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime


# Base schema (shared fields)
class UserBase(BaseModel):
    email: EmailStr
    full_name: Optional[str] = None
    is_active: bool = True


# Create schema (input)
class UserCreate(UserBase):
    password: str = Field(..., min_length=8)


# Update schema (all fields optional)
class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    password: Optional[str] = Field(None, min_length=8)
    is_active: Optional[bool] = None


# Read schema (output)
class UserRead(UserBase):
    id: int
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}


# List response with pagination
class UserList(BaseModel):
    items: list[UserRead]
    total: int
    skip: int
    limit: int
```

## API Versioning

### URL Path Versioning (Recommended)

```python
# v1
api_v1 = APIRouter(prefix="/api/v1")
api_v1.include_router(users.router)

# v2
api_v2 = APIRouter(prefix="/api/v2")
api_v2.include_router(users_v2.router)

app.include_router(api_v1)
app.include_router(api_v2)
```

### Header Versioning (Alternative)

```python
from fastapi import Header

@app.get("/api/users")
async def get_users(api_version: str = Header("1.0", alias="API-Version")):
    if api_version == "1.0":
        return v1_users()
    elif api_version == "2.0":
        return v2_users()
```

## OpenAPI Documentation

### Customization

```python
from fastapi import FastAPI

app = FastAPI(
    title="My API",
    description="Production-ready REST API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/api/v1/openapi.json",
    openapi_tags=[
        {
            "name": "users",
            "description": "User management operations",
        },
        {
            "name": "auth",
            "description": "Authentication endpoints",
        },
    ],
)
```

### Endpoint Documentation

```python
@router.post(
    "/users",
    response_model=UserRead,
    status_code=201,
    summary="Create a new user",
    description="Create a new user with email and password",
    responses={
        201: {"description": "User created successfully"},
        400: {"description": "Invalid input"},
        409: {"description": "User already exists"},
    },
    tags=["users"],
)
async def create_user(user_in: UserCreate):
    """
    Create new user with all information:

    - **email**: Valid email address
    - **password**: Minimum 8 characters
    - **full_name**: Optional full name
    """
    pass
```

## Error Responses

### Standard Error Schema

```python
from pydantic import BaseModel

class ErrorResponse(BaseModel):
    detail: str
    error_code: Optional[str] = None
    field_errors: Optional[dict[str, list[str]]] = None


class ValidationErrorResponse(BaseModel):
    detail: list[dict]


# Usage
@router.post(
    "/users",
    responses={
        400: {"model": ErrorResponse},
        422: {"model": ValidationErrorResponse},
    },
)
```

### Exception Handlers

```python
from fastapi import FastAPI, Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
    request: Request,
    exc: RequestValidationError,
):
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "detail": exc.errors(),
            "error_code": "VALIDATION_ERROR",
        },
    )


@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    return JSONResponse(
        status_code=status.HTTP_400_BAD_REQUEST,
        content={
            "detail": str(exc),
            "error_code": "INVALID_VALUE",
        },
    )
```

## Best Practices

### 1. Use Proper HTTP Methods

```python
# ✅ Correct
GET    /users/{id}        # Retrieve
POST   /users             # Create
PUT    /users/{id}        # Full update
PATCH  /users/{id}        # Partial update
DELETE /users/{id}        # Delete

# ❌ Wrong
POST   /users/get/{id}
POST   /users/delete/{id}
GET    /users/create
```

### 2. Return Appropriate Status Codes

```python
# ✅ Correct
@router.post("/users", status_code=201)  # Created
@router.delete("/users/{id}", status_code=204)  # No Content

# ❌ Wrong
@router.post("/users")  # Defaults to 200
@router.delete("/users/{id}")  # Returns 200 instead of 204
```

### 3. Validate Input

```python
from pydantic import Field, validator

class UserCreate(BaseModel):
    email: EmailStr
    age: int = Field(..., ge=18, le=150)
    username: str = Field(..., min_length=3, max_length=50)

    @validator('username')
    def username_alphanumeric(cls, v):
        assert v.isalnum(), 'must be alphanumeric'
        return v
```

### 4. Use Response Models

```python
# ✅ Always specify response_model
@router.get("/users/{id}", response_model=UserRead)

# Prevents accidentally exposing sensitive data
# Validates response structure
# Auto-generates OpenAPI docs
```

### 5. Implement Pagination

```python
from typing import Generic, TypeVar
from pydantic import BaseModel

T = TypeVar('T')

class PaginatedResponse(BaseModel, Generic[T]):
    items: list[T]
    total: int
    page: int
    per_page: int
    pages: int


@router.get("/users", response_model=PaginatedResponse[UserRead])
async def list_users(
    page: int = Query(1, ge=1),
    per_page: int = Query(20, ge=1, le=100),
):
    ...
```

## Advanced Patterns

### HATEOAS (Hypermedia)

```python
class UserRead(BaseModel):
    id: int
    email: str
    links: dict[str, str]

    @classmethod
    def from_orm_with_links(cls, user, request: Request):
        return cls(
            id=user.id,
            email=user.email,
            links={
                "self": f"/api/v1/users/{user.id}",
                "posts": f"/api/v1/users/{user.id}/posts",
                "update": f"/api/v1/users/{user.id}",
                "delete": f"/api/v1/users/{user.id}",
            },
        )
```

### Batch Operations

```python
@router.post("/users/batch", status_code=207)
async def batch_create_users(
    users: list[UserCreate],
    db: Session = Depends(get_db),
):
    """Create multiple users. Returns multi-status."""
    results = []
    for user_data in users:
        try:
            user = crud.create_user(db, obj_in=user_data)
            results.append({"status": 201, "data": user})
        except Exception as e:
            results.append({"status": 400, "error": str(e)})
    return results
```

### Async Endpoints

```python
from fastapi.concurrency import run_in_threadpool

@router.get("/users/{id}/heavy-computation")
async def heavy_computation(id: int):
    # I/O-bound: use async
    data = await fetch_from_external_api(id)

    # CPU-bound: run in thread pool
    result = await run_in_threadpool(expensive_calculation, data)

    return result
```

---

**Version:** 1.0.0
**Framework:** FastAPI + Pydantic
**Last Updated:** January 10, 2026

---
name: fastapi-builder
description: Build FastAPI applications with modern Python practices. Use when creating APIs, adding endpoints, building REST services, or working with FastAPI. Trigger keywords "fastapi", "api endpoint", "rest api", "build api", "create endpoint".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
user-invocable: true
---

# FastAPI Builder Skill

Build production-ready FastAPI applications using modern Python best practices with uv package management.

## Quick Start

This skill helps with:
1. **Creating FastAPI applications** - Full project scaffolding
2. **Adding endpoints** - REST API routes with proper patterns
3. **Database integration** - SQLAlchemy/SQLModel setup
4. **Authentication** - JWT, OAuth2, API keys
5. **Documentation** - OpenAPI/Swagger auto-generation

## Tech Stack

### Required Tools
- **uv** - Modern Python package manager (NOT pip)
- **FastAPI** - High-performance web framework
- **Pydantic** - Data validation
- **pytest** - Testing (NEVER unittest)
- **ruff** - Linting and formatting

### Common Dependencies
```toml
[project]
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
    "pydantic>=2.5.0",
    "pydantic-settings>=2.1.0",
    "sqlmodel>=0.0.14",
    "python-jose[cryptography]>=3.3.0",
    "passlib[bcrypt]>=1.7.4",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.21.0",
    "pytest-cov>=4.1.0",
    "httpx>=0.25.0",
    "ruff>=0.1.0",
]
```

## Project Structure

### Standard FastAPI Application
```
project-name/
├── pyproject.toml          # uv project config
├── uv.lock                 # Dependency lock file
├── .python-version         # Python version (3.11+)
├── Dockerfile              # Docker with uv
├── .dockerignore
├── README.md
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py         # FastAPI app entry
│       ├── config.py       # Settings (pydantic-settings)
│       ├── api/
│       │   ├── __init__.py
│       │   ├── deps.py     # Dependencies
│       │   └── v1/
│       │       ├── __init__.py
│       │       ├── router.py
│       │       └── endpoints/
│       │           ├── __init__.py
│       │           ├── users.py
│       │           └── items.py
│       ├── models/         # SQLModel/Pydantic models
│       │   ├── __init__.py
│       │   ├── user.py
│       │   └── item.py
│       ├── schemas/        # API schemas
│       │   ├── __init__.py
│       │   ├── user.py
│       │   └── item.py
│       ├── crud/           # CRUD operations
│       │   ├── __init__.py
│       │   └── user.py
│       ├── db/             # Database
│       │   ├── __init__.py
│       │   ├── session.py
│       │   └── base.py
│       └── core/           # Core utilities
│           ├── __init__.py
│           ├── security.py
│           └── exceptions.py
└── tests/
    ├── __init__.py
    ├── conftest.py         # Pytest fixtures
    ├── test_api/
    │   ├── test_users.py
    │   └── test_items.py
    └── test_models/
```

## Core Patterns

### 1. Main Application (main.py)

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from .config import settings
from .api.v1.router import api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan events for startup/shutdown"""
    # Startup
    print("Starting up...")
    yield
    # Shutdown
    print("Shutting down...")


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
)

# CORS
if settings.BACKEND_CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

# Include routers
app.include_router(api_router, prefix=settings.API_V1_STR)


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}
```

### 2. Configuration (config.py)

```python
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import AnyHttpUrl


class Settings(BaseSettings):
    """Application settings from environment variables"""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
    )

    # API
    PROJECT_NAME: str = "My API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"

    # CORS
    BACKEND_CORS_ORIGINS: list[AnyHttpUrl] = []

    # Database
    DATABASE_URL: str = "sqlite:///./app.db"

    # Security
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30


settings = Settings()
```

### 3. API Router (api/v1/router.py)

```python
from fastapi import APIRouter

from .endpoints import users, items

api_router = APIRouter()

api_router.include_router(
    users.router,
    prefix="/users",
    tags=["users"],
)

api_router.include_router(
    items.router,
    prefix="/items",
    tags=["items"],
)
```

### 4. Endpoint Example (api/v1/endpoints/users.py)

```python
from fastapi import APIRouter, Depends, HTTPException, status
from sqlmodel import Session

from ....db.session import get_db
from ....schemas.user import UserCreate, UserRead, UserUpdate
from ....crud import user as crud_user

router = APIRouter()


@router.post("/", response_model=UserRead, status_code=status.HTTP_201_CREATED)
async def create_user(
    *,
    db: Session = Depends(get_db),
    user_in: UserCreate,
):
    """
    Create new user.
    """
    user = crud_user.get_by_email(db, email=user_in.email)
    if user:
        raise HTTPException(
            status_code=400,
            detail="User with this email already exists",
        )
    user = crud_user.create(db, obj_in=user_in)
    return user


@router.get("/{user_id}", response_model=UserRead)
async def read_user(
    *,
    db: Session = Depends(get_db),
    user_id: int,
):
    """
    Get user by ID.
    """
    user = crud_user.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@router.get("/", response_model=list[UserRead])
async def read_users(
    *,
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
):
    """
    Retrieve users.
    """
    users = crud_user.get_multi(db, skip=skip, limit=limit)
    return users


@router.put("/{user_id}", response_model=UserRead)
async def update_user(
    *,
    db: Session = Depends(get_db),
    user_id: int,
    user_in: UserUpdate,
):
    """
    Update user.
    """
    user = crud_user.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user = crud_user.update(db, db_obj=user, obj_in=user_in)
    return user


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    *,
    db: Session = Depends(get_db),
    user_id: int,
):
    """
    Delete user.
    """
    user = crud_user.get(db, id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    crud_user.remove(db, id=user_id)
```

### 5. Models (models/user.py)

```python
from sqlmodel import Field, SQLModel
from typing import Optional


class UserBase(SQLModel):
    """Base user model"""
    email: str = Field(unique=True, index=True)
    full_name: Optional[str] = None
    is_active: bool = True


class User(UserBase, table=True):
    """User database model"""
    id: Optional[int] = Field(default=None, primary_key=True)
    hashed_password: str


class UserCreate(UserBase):
    """User creation schema"""
    password: str


class UserRead(UserBase):
    """User read schema (public)"""
    id: int


class UserUpdate(SQLModel):
    """User update schema"""
    email: Optional[str] = None
    full_name: Optional[str] = None
    password: Optional[str] = None
    is_active: Optional[bool] = None
```

### 6. Database Session (db/session.py)

```python
from sqlmodel import Session, create_engine
from ..config import settings

engine = create_engine(
    settings.DATABASE_URL,
    echo=True,  # Set to False in production
)


def get_db():
    """Database session dependency"""
    with Session(engine) as session:
        yield session
```

### 7. CRUD Operations (crud/user.py)

```python
from sqlmodel import Session, select
from typing import Optional

from ..models.user import User, UserCreate, UserUpdate
from ..core.security import get_password_hash


def get(db: Session, id: int) -> Optional[User]:
    """Get user by ID"""
    return db.get(User, id)


def get_by_email(db: Session, email: str) -> Optional[User]:
    """Get user by email"""
    statement = select(User).where(User.email == email)
    return db.exec(statement).first()


def get_multi(
    db: Session,
    *,
    skip: int = 0,
    limit: int = 100,
) -> list[User]:
    """Get multiple users"""
    statement = select(User).offset(skip).limit(limit)
    return db.exec(statement).all()


def create(db: Session, *, obj_in: UserCreate) -> User:
    """Create user"""
    db_obj = User(
        email=obj_in.email,
        full_name=obj_in.full_name,
        hashed_password=get_password_hash(obj_in.password),
        is_active=obj_in.is_active,
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj


def update(db: Session, *, db_obj: User, obj_in: UserUpdate) -> User:
    """Update user"""
    update_data = obj_in.model_dump(exclude_unset=True)

    if "password" in update_data:
        hashed_password = get_password_hash(update_data["password"])
        del update_data["password"]
        update_data["hashed_password"] = hashed_password

    for field, value in update_data.items():
        setattr(db_obj, field, value)

    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj


def remove(db: Session, *, id: int) -> User:
    """Delete user"""
    obj = db.get(User, id)
    db.delete(obj)
    db.commit()
    return obj
```

## Running with uv

### Development

```bash
# Create new project
uv init my-api
cd my-api

# Add dependencies
uv add fastapi uvicorn[standard] pydantic pydantic-settings sqlmodel

# Add dev dependencies
uv add --dev pytest pytest-asyncio pytest-cov httpx ruff

# Run dev server
uv run uvicorn src.my_api.main:app --reload --host 0.0.0.0 --port 8000

# Run tests
uv run pytest

# Lint and format
uv run ruff check .
uv run ruff format .
```

### Production

```bash
# Install production dependencies only
uv sync --no-dev

# Run with uvicorn
uv run uvicorn src.my_api.main:app --host 0.0.0.0 --port 8000 --workers 4
```

## Testing with pytest

### Test Configuration (conftest.py)

```python
import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, create_engine, SQLModel
from sqlmodel.pool import StaticPool

from src.my_api.main import app
from src.my_api.db.session import get_db


@pytest.fixture(name="session")
def session_fixture():
    """Create test database session"""
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    SQLModel.metadata.create_all(engine)
    with Session(engine) as session:
        yield session


@pytest.fixture(name="client")
def client_fixture(session: Session):
    """Create test client with database override"""
    def get_session_override():
        return session

    app.dependency_overrides[get_db] = get_session_override

    client = TestClient(app)
    yield client

    app.dependency_overrides.clear()
```

### Example Test (test_api/test_users.py)

```python
from fastapi.testclient import TestClient
from sqlmodel import Session


def test_create_user(client: TestClient):
    """Test creating a new user"""
    response = client.post(
        "/api/v1/users/",
        json={
            "email": "test@example.com",
            "full_name": "Test User",
            "password": "strongpassword123",
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "test@example.com"
    assert data["full_name"] == "Test User"
    assert "id" in data
    assert "password" not in data


def test_read_user(client: TestClient, session: Session):
    """Test reading a user"""
    # Create user first
    response = client.post(
        "/api/v1/users/",
        json={
            "email": "test@example.com",
            "password": "password123",
        },
    )
    user_id = response.json()["id"]

    # Read user
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == user_id
    assert data["email"] == "test@example.com"


def test_user_not_found(client: TestClient):
    """Test 404 for non-existent user"""
    response = client.get("/api/v1/users/999")
    assert response.status_code == 404
```

## Best Practices

### Always Use uv (NOT python/pip)

```bash
# ❌ DON'T
python -m venv venv
pip install fastapi
python main.py

# ✅ DO
uv init project-name
uv add fastapi
uv run uvicorn main:app
```

### Use pytest (NEVER unittest)

```bash
# ❌ DON'T
python -m unittest discover

# ✅ DO
uv run pytest
uv run pytest -v --cov
uv run pytest tests/test_api/
```

### Async Endpoints When Possible

```python
# ✅ Async (preferred for I/O operations)
@router.get("/users")
async def get_users(db: Session = Depends(get_db)):
    users = await fetch_users(db)
    return users

# ⚠️ Sync (only for CPU-bound operations)
@router.post("/compute")
def heavy_computation(data: dict):
    result = expensive_calculation(data)
    return result
```

### Dependency Injection

```python
# ✅ Use FastAPI dependencies
from fastapi import Depends

async def get_current_user(token: str = Depends(oauth2_scheme)):
    return decode_token(token)

@router.get("/me")
async def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user
```

### Response Models

```python
# ✅ Always specify response_model
@router.get("/users/{user_id}", response_model=UserRead)
async def get_user(user_id: int):
    ...

# ✅ Use status codes
@router.post("/users", status_code=status.HTTP_201_CREATED)
@router.delete("/users/{id}", status_code=status.HTTP_204_NO_CONTENT)
```

### Error Handling

```python
from fastapi import HTTPException, status

# ✅ Use HTTPException for API errors
if not user:
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="User not found",
    )

# ✅ Custom exception handlers
from fastapi.responses import JSONResponse

@app.exception_handler(ValueError)
async def value_error_handler(request, exc):
    return JSONResponse(
        status_code=400,
        content={"detail": str(exc)},
    )
```

## Common Tasks

### Add New Endpoint

1. Create schema in `schemas/`
2. Create model in `models/` (if database)
3. Create CRUD operations in `crud/`
4. Create endpoint in `api/v1/endpoints/`
5. Add router to `api/v1/router.py`
6. Write tests in `tests/test_api/`

### Add Authentication

```python
# core/security.py
from passlib.context import CryptContext
from jose import jwt
from datetime import datetime, timedelta

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
```

### Add Database Migration (Alembic)

```bash
# Add alembic
uv add alembic

# Initialize
uv run alembic init migrations

# Create migration
uv run alembic revision --autogenerate -m "Add users table"

# Run migration
uv run alembic upgrade head
```

## Integration with Other Skills

- **test-runner** - Automatically run pytest tests
- **docker-builder** - Containerize FastAPI app
- **api-designer** - Design API structure before implementation

---

**Version:** 1.0.0
**Tech Stack:** uv, FastAPI, Pydantic, SQLModel, pytest
**Last Updated:** January 10, 2026

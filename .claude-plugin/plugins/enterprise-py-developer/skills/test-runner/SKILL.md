---
name: test-runner
description: Run and manage pytest tests for Python projects. Use when running tests, debugging test failures, checking coverage, or setting up test infrastructure. Trigger keywords "run tests", "pytest", "test coverage", "test failed", "test suite". NEVER use unittest.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
user-invocable: true
---

# Test Runner Skill

Run, debug, and manage pytest test suites for Python applications. Always use pytest, NEVER unittest.

## Quick Start

This skill helps with:
1. **Running tests** - Execute pytest with proper configuration
2. **Coverage reports** - Generate and analyze test coverage
3. **Test debugging** - Diagnose and fix failing tests
4. **Test setup** - Configure pytest, fixtures, and test structure
5. **CI/CD integration** - Prepare tests for automation

## Tech Stack

### Required Tools
- **pytest** - Testing framework (NEVER unittest)
- **pytest-asyncio** - Async test support
- **pytest-cov** - Coverage reporting
- **pytest-xdist** - Parallel test execution
- **httpx** - HTTP testing for FastAPI

### Dependencies

```toml
[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.21.0",
    "pytest-cov>=4.1.0",
    "pytest-xdist>=3.5.0",
    "httpx>=0.25.0",
]
```

## Test Structure

### Standard Layout

```
project/
├── pyproject.toml
├── src/
│   └── my_api/
│       ├── __init__.py
│       └── main.py
└── tests/
    ├── __init__.py
    ├── conftest.py           # Shared fixtures
    ├── test_api/
    │   ├── __init__.py
    │   ├── conftest.py       # API-specific fixtures
    │   ├── test_users.py
    │   └── test_items.py
    ├── test_models/
    │   ├── __init__.py
    │   └── test_user.py
    ├── test_crud/
    │   ├── __init__.py
    │   └── test_user_crud.py
    └── test_core/
        ├── __init__.py
        └── test_security.py
```

## pytest Configuration

### pyproject.toml

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "-v",                          # Verbose
    "--strict-markers",            # Enforce markers
    "--strict-config",             # Enforce config
    "--cov=src",                   # Coverage source
    "--cov-report=term-missing",   # Show missing lines
    "--cov-report=html",           # HTML report
    "--cov-fail-under=80",         # Minimum coverage
    "-n auto",                     # Parallel execution
]
asyncio_mode = "auto"              # Auto async mode
markers = [
    "slow: marks tests as slow",
    "integration: integration tests",
    "unit: unit tests",
]
```

## Running Tests with uv

### Basic Commands

```bash
# Run all tests
uv run pytest

# Run with verbose output
uv run pytest -v

# Run specific file
uv run pytest tests/test_api/test_users.py

# Run specific test
uv run pytest tests/test_api/test_users.py::test_create_user

# Run tests matching pattern
uv run pytest -k "test_user"

# Run with coverage
uv run pytest --cov=src --cov-report=html

# Run in parallel
uv run pytest -n auto

# Run only failed tests from last run
uv run pytest --lf

# Run failed tests first, then others
uv run pytest --ff

# Stop on first failure
uv run pytest -x

# Show local variables on failure
uv run pytest -l

# Run with print statements visible
uv run pytest -s
```

### Advanced Commands

```bash
# Run with detailed coverage
uv run pytest --cov=src --cov-report=term-missing --cov-report=html --cov-fail-under=90

# Run specific markers
uv run pytest -m "not slow"
uv run pytest -m "integration"

# Generate JUnit XML for CI
uv run pytest --junitxml=report.xml

# Run with profiling
uv run pytest --profile

# Dry run (collect tests without running)
uv run pytest --collect-only

# Show slowest tests
uv run pytest --durations=10
```

## Fixtures

### Global Fixtures (conftest.py)

```python
import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, create_engine, SQLModel
from sqlmodel.pool import StaticPool

from src.my_api.main import app
from src.my_api.db.session import get_db
from src.my_api.models.user import User


@pytest.fixture(scope="session")
def engine():
    """Create test database engine (session scope)"""
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    SQLModel.metadata.create_all(engine)
    return engine


@pytest.fixture(name="session")
def session_fixture(engine):
    """Create test database session (function scope)"""
    with Session(engine) as session:
        yield session
        # Rollback after each test
        session.rollback()


@pytest.fixture(name="client")
def client_fixture(session: Session):
    """Create FastAPI test client"""
    def get_session_override():
        return session

    app.dependency_overrides[get_db] = get_session_override
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


@pytest.fixture
def test_user(session: Session):
    """Create a test user"""
    user = User(
        email="test@example.com",
        full_name="Test User",
        hashed_password="hashed",
    )
    session.add(user)
    session.commit()
    session.refresh(user)
    return user


@pytest.fixture
def auth_headers(test_user):
    """Create authentication headers"""
    # Generate token for test_user
    token = create_access_token({"sub": test_user.email})
    return {"Authorization": f"Bearer {token}"}
```

### Async Fixtures

```python
import pytest
from httpx import AsyncClient

@pytest.fixture
async def async_client():
    """Create async test client"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client


@pytest.mark.asyncio
async def test_async_endpoint(async_client):
    """Test async endpoint"""
    response = await async_client.get("/users")
    assert response.status_code == 200
```

## Test Examples

### Unit Tests (test_models/test_user.py)

```python
import pytest
from pydantic import ValidationError

from src.my_api.models.user import UserCreate, UserRead


def test_user_create_valid():
    """Test valid user creation"""
    user = UserCreate(
        email="test@example.com",
        password="strongpassword123",
        full_name="Test User",
    )
    assert user.email == "test@example.com"
    assert user.full_name == "Test User"


def test_user_create_invalid_email():
    """Test invalid email validation"""
    with pytest.raises(ValidationError):
        UserCreate(
            email="invalid-email",
            password="password123",
        )


def test_user_read_no_password():
    """Test UserRead doesn't expose password"""
    user = UserRead(
        id=1,
        email="test@example.com",
        full_name="Test User",
        is_active=True,
    )
    assert not hasattr(user, "password")
    assert not hasattr(user, "hashed_password")
```

### API Tests (test_api/test_users.py)

```python
import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session


def test_create_user(client: TestClient):
    """Test POST /users - create new user"""
    response = client.post(
        "/api/v1/users/",
        json={
            "email": "newuser@example.com",
            "password": "strongpassword123",
            "full_name": "New User",
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "newuser@example.com"
    assert data["full_name"] == "New User"
    assert "id" in data
    assert "password" not in data


def test_create_user_duplicate_email(client: TestClient, test_user):
    """Test creating user with duplicate email fails"""
    response = client.post(
        "/api/v1/users/",
        json={
            "email": test_user.email,
            "password": "password123",
        },
    )
    assert response.status_code == 400
    assert "already exists" in response.json()["detail"]


def test_read_user(client: TestClient, test_user):
    """Test GET /users/{id} - read user"""
    response = client.get(f"/api/v1/users/{test_user.id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == test_user.id
    assert data["email"] == test_user.email


def test_read_user_not_found(client: TestClient):
    """Test GET /users/{id} - 404 for non-existent user"""
    response = client.get("/api/v1/users/999")
    assert response.status_code == 404


def test_update_user(client: TestClient, test_user):
    """Test PUT /users/{id} - update user"""
    response = client.put(
        f"/api/v1/users/{test_user.id}",
        json={"full_name": "Updated Name"},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["full_name"] == "Updated Name"


def test_delete_user(client: TestClient, test_user):
    """Test DELETE /users/{id} - delete user"""
    response = client.delete(f"/api/v1/users/{test_user.id}")
    assert response.status_code == 204

    # Verify deleted
    response = client.get(f"/api/v1/users/{test_user.id}")
    assert response.status_code == 404


def test_list_users(client: TestClient, session: Session):
    """Test GET /users - list users"""
    # Create multiple users
    for i in range(5):
        user = User(email=f"user{i}@example.com", hashed_password="hash")
        session.add(user)
    session.commit()

    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) >= 5


def test_list_users_pagination(client: TestClient, session: Session):
    """Test pagination parameters"""
    response = client.get("/api/v1/users/?skip=2&limit=3")
    assert response.status_code == 200
    data = response.json()
    assert len(data) <= 3
```

### Integration Tests (test_api/test_auth.py)

```python
import pytest


@pytest.mark.integration
def test_login_success(client: TestClient, test_user):
    """Test successful login flow"""
    response = client.post(
        "/api/v1/auth/login",
        data={
            "username": test_user.email,
            "password": "password123",
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"


@pytest.mark.integration
def test_protected_endpoint_authenticated(client: TestClient, auth_headers):
    """Test accessing protected endpoint with auth"""
    response = client.get(
        "/api/v1/users/me",
        headers=auth_headers,
    )
    assert response.status_code == 200


@pytest.mark.integration
def test_protected_endpoint_unauthenticated(client: TestClient):
    """Test accessing protected endpoint without auth"""
    response = client.get("/api/v1/users/me")
    assert response.status_code == 401
```

### Async Tests

```python
import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_async_create_user(async_client: AsyncClient):
    """Test async user creation"""
    response = await async_client.post(
        "/api/v1/users/",
        json={
            "email": "async@example.com",
            "password": "password123",
        },
    )
    assert response.status_code == 201


@pytest.mark.asyncio
async def test_concurrent_requests(async_client: AsyncClient):
    """Test handling concurrent requests"""
    import asyncio

    tasks = [
        async_client.get("/api/v1/users/")
        for _ in range(10)
    ]
    responses = await asyncio.gather(*tasks)

    for response in responses:
        assert response.status_code == 200
```

## Parametrized Tests

```python
import pytest


@pytest.mark.parametrize(
    "email,password,expected_status",
    [
        ("valid@example.com", "strongpass123", 201),
        ("invalid-email", "password", 422),
        ("test@example.com", "weak", 422),
        ("", "password123", 422),
    ],
)
def test_user_creation_validation(client, email, password, expected_status):
    """Test various user creation scenarios"""
    response = client.post(
        "/api/v1/users/",
        json={"email": email, "password": password},
    )
    assert response.status_code == expected_status


@pytest.mark.parametrize("limit", [10, 50, 100])
def test_pagination_limits(client, limit):
    """Test different pagination limits"""
    response = client.get(f"/api/v1/users/?limit={limit}")
    assert response.status_code == 200
    data = response.json()
    assert len(data) <= limit
```

## Markers

### Mark Tests

```python
import pytest


@pytest.mark.slow
def test_complex_operation():
    """Slow test - skip by default"""
    pass


@pytest.mark.integration
def test_database_integration():
    """Integration test"""
    pass


@pytest.mark.unit
def test_pure_function():
    """Unit test"""
    pass


@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    """Skipped test"""
    pass


@pytest.mark.skipif(sys.version_info < (3, 11), reason="Requires Python 3.11+")
def test_python_311_feature():
    """Conditional skip"""
    pass


@pytest.mark.xfail(reason="Known bug")
def test_known_issue():
    """Expected to fail"""
    pass
```

### Run by Marker

```bash
# Run only unit tests
uv run pytest -m unit

# Run all except slow tests
uv run pytest -m "not slow"

# Run integration tests only
uv run pytest -m integration

# Multiple markers
uv run pytest -m "unit and not slow"
```

## Coverage Analysis

### Generate Coverage Report

```bash
# Terminal report with missing lines
uv run pytest --cov=src --cov-report=term-missing

# HTML report
uv run pytest --cov=src --cov-report=html
open htmlcov/index.html

# XML report (for CI)
uv run pytest --cov=src --cov-report=xml

# Multiple formats
uv run pytest --cov=src --cov-report=term-missing --cov-report=html --cov-report=xml

# Fail if coverage below threshold
uv run pytest --cov=src --cov-fail-under=80
```

### Coverage Configuration

```toml
[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/conftest.py",
    "*/__init__.py",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]
precision = 2
show_missing = true
skip_covered = false
```

## Debugging Tests

### Print Debugging

```python
def test_debug_example(client, capsys):
    """Test with print debugging"""
    print(f"Testing endpoint...")

    response = client.get("/api/v1/users/")
    print(f"Response: {response.json()}")

    assert response.status_code == 200

    # Capture output
    captured = capsys.readouterr()
    assert "Testing" in captured.out
```

### Using pdb

```python
def test_with_debugger(client):
    """Test with debugger"""
    response = client.get("/api/v1/users/")

    # Set breakpoint
    import pdb; pdb.set_trace()

    assert response.status_code == 200
```

```bash
# Run with pdb on failure
uv run pytest --pdb

# Drop into debugger on first failure
uv run pytest -x --pdb
```

## CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v1

      - name: Set up Python
        run: uv python install

      - name: Install dependencies
        run: uv sync

      - name: Run tests
        run: uv run pytest --cov=src --cov-report=xml --junitxml=junit.xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml
```

## Best Practices

### ALWAYS Use pytest (NEVER unittest)

```python
# ❌ NEVER DO THIS
import unittest

class TestUser(unittest.TestCase):
    def test_create(self):
        self.assertEqual(...)

# ✅ ALWAYS DO THIS
import pytest

def test_create_user():
    assert ...
```

### Use Fixtures Instead of setUp/tearDown

```python
# ❌ DON'T (unittest style)
def setUp(self):
    self.client = TestClient(app)

# ✅ DO (pytest style)
@pytest.fixture
def client():
    return TestClient(app)
```

### Use Assert Statements

```python
# ✅ Simple and clear
assert response.status_code == 200
assert len(users) == 5
assert user.email == "test@example.com"

# ✅ With messages
assert response.status_code == 200, f"Got {response.status_code}"

# ✅ pytest helpers
with pytest.raises(ValueError):
    invalid_operation()

with pytest.warns(UserWarning):
    deprecated_function()
```

### Test Organization

```python
# ✅ Group related tests in classes (optional)
class TestUserCreation:
    """Tests for user creation endpoint"""

    def test_valid_creation(self, client):
        ...

    def test_duplicate_email(self, client):
        ...

    def test_invalid_email(self, client):
        ...
```

### Arrange-Act-Assert Pattern

```python
def test_update_user(client, session):
    # Arrange
    user = User(email="old@example.com", hashed_password="hash")
    session.add(user)
    session.commit()

    # Act
    response = client.put(
        f"/api/v1/users/{user.id}",
        json={"email": "new@example.com"},
    )

    # Assert
    assert response.status_code == 200
    assert response.json()["email"] == "new@example.com"
```

## Common Tasks

### Run Tests After Code Changes

```bash
# Watch mode (with pytest-watch)
uv add --dev pytest-watch
uv run ptw

# Or run on file save manually
uv run pytest --lf  # Only failed tests
```

### Generate Coverage Report

```bash
# Full coverage workflow
uv run pytest --cov=src --cov-report=html
open htmlcov/index.html

# Check specific module
uv run pytest --cov=src.my_api.crud tests/test_crud/
```

### Debug Failing Test

```bash
# Show locals on failure
uv run pytest -l

# Drop into debugger
uv run pytest --pdb -x

# Show print statements
uv run pytest -s

# Verbose output
uv run pytest -vv
```

## Integration with Other Skills

- **fastapi-builder** - Test FastAPI endpoints
- **docker-builder** - Test in containerized environment
- Run automatically via hooks after code changes

---

**Version:** 1.0.0
**Framework:** pytest (NEVER unittest)
**Last Updated:** January 10, 2026

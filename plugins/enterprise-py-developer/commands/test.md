---
description: Run pytest tests with coverage
---

# Test Command

Run tests using pytest with uv.

## Usage

```
/py-dev:test
/py-dev:test tests/test_api/
/py-dev:test -k test_users
```

## Instructions

1. Parse optional arguments from `$ARGUMENTS`
2. **Run pytest** using uv:
   - `uv run pytest` (all tests)
   - `uv run pytest <path>` (specific path)
   - `uv run pytest -k <pattern>` (pattern matching)
3. **Generate coverage** report
4. **Display results**:
   - Pass/fail status
   - Coverage percentage
   - Failed test details
5. If tests fail, suggest fixes

Invoke **test-runner** skill for execution.

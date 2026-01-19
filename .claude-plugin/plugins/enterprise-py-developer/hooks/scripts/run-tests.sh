#!/bin/bash
# Run pytest after code changes

FILE_PATH="$1"

# Only for Python files
if [[ "$FILE_PATH" != *.py ]]; then
    exit 0
fi

# Skip if in tests directory
if [[ "$FILE_PATH" == *"/tests/"* ]]; then
    exit 0
fi

# Run tests if pytest is available
if command -v uv &> /dev/null && [ -d "tests" ]; then
    echo "Running tests..."
    uv run pytest --lf -x 2>/dev/null || true
fi

exit 0

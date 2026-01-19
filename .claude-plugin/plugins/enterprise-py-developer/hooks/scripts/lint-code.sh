#!/bin/bash
# Lint Python code before commits

COMMAND="$1"

# Only check git commit commands
if [[ "$COMMAND" != *"git commit"* ]]; then
    exit 0
fi

# Run ruff check
if command -v uv &> /dev/null; then
    echo "Linting code..."
    if ! uv run ruff check . 2>/dev/null; then
        echo "Warning: Linting issues found. Fix with: uv run ruff check --fix ."
    fi
fi

exit 0

#!/bin/bash
FILE_PATH="$1"
if [[ "$FILE_PATH" == *.py ]] && [[ -f "$FILE_PATH" ]]; then
    command -v uv &> /dev/null && uv run ruff format "$FILE_PATH" 2>/dev/null || true
fi
exit 0

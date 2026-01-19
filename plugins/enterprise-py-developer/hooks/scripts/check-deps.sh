#!/bin/bash
if ! command -v uv &> /dev/null; then
    echo "Warning: uv not found. Install: curl -LsSf https://astral.sh/uv/install.sh | sh"
fi
exit 0

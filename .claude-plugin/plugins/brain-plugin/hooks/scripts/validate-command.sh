#!/bin/bash
# Validate bash commands for safety before execution

COMMAND="$1"

# List of dangerous commands/patterns to warn about
DANGEROUS_PATTERNS=(
    "rm -rf /"
    "rm -rf /*"
    "> /dev/sda"
    "dd if="
    "mkfs"
    ":(){ :|:& };:"
)

# Check for dangerous patterns
for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -q "$pattern"; then
        echo "WARNING: Potentially dangerous command detected: $pattern"
        echo "Command blocked for safety."
        exit 1
    fi
done

# Allow command to proceed
exit 0

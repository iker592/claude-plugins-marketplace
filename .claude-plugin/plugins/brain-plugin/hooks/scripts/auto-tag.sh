#!/bin/bash
# Auto-tag modified files with metadata

# This hook runs after Write or Edit operations
# It adds/updates metadata tags at the bottom of markdown files

FILE_PATH="$1"

# Only process markdown files
if [[ "$FILE_PATH" != *.md ]]; then
    exit 0
fi

# Skip if file doesn't exist
if [[ ! -f "$FILE_PATH" ]]; then
    exit 0
fi

# Get current date
CURRENT_DATE=$(date +"%Y-%m-%d")

# Check if file has "Last Updated" tag
if grep -q "^\*\*Last Updated:\*\*" "$FILE_PATH"; then
    # Update existing tag
    sed -i "s/^\*\*Last Updated:\*\*.*/\*\*Last Updated:\*\* $CURRENT_DATE/" "$FILE_PATH"
else
    # Add new tag if it doesn't exist
    echo "" >> "$FILE_PATH"
    echo "---" >> "$FILE_PATH"
    echo "**Last Updated:** $CURRENT_DATE" >> "$FILE_PATH"
fi

exit 0

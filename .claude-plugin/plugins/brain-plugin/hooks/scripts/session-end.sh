#!/bin/bash
# Log session end and generate summary

LOG_DIR="${CLAUDE_PROJECT_DIR}/.claude/sessions"
SESSION_DATE=$(date +"%Y-%m-%d")
SESSION_TIME=$(date +"%H:%M:%S")
LOG_FILE="$LOG_DIR/$SESSION_DATE.log"

# Log session end
echo "" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"
echo "Session ended: $SESSION_DATE $SESSION_TIME" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"

# Count files modified today (rough estimate)
MODIFIED_TODAY=$(find "$CLAUDE_PROJECT_DIR" -type f -name "*.md" -mtime 0 2>/dev/null | wc -l)

echo "Files modified today: $MODIFIED_TODAY" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

exit 0

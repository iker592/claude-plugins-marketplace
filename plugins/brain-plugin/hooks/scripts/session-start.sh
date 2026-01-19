#!/bin/bash
# Log session start

# Create sessions log directory if it doesn't exist
LOG_DIR="${CLAUDE_PROJECT_DIR}/.claude/sessions"
mkdir -p "$LOG_DIR"

# Generate session log file
SESSION_DATE=$(date +"%Y-%m-%d")
SESSION_TIME=$(date +"%H:%M:%S")
LOG_FILE="$LOG_DIR/$SESSION_DATE.log"

# Log session start
echo "========================================" >> "$LOG_FILE"
echo "Session started: $SESSION_DATE $SESSION_TIME" >> "$LOG_FILE"
echo "Working directory: $CLAUDE_PROJECT_DIR" >> "$LOG_FILE"
echo "========================================" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Output to user (optional)
echo "Session logged to: $LOG_FILE"

exit 0

#!/bin/bash

# .scripts/log_update.sh
# Appends a timestamped message to CURRENT_IMPLEMENTATION.md

if [ -z "$1" ];
  then
    echo "Usage: make log message=\"Your update message\""
    exit 1
fi

MESSAGE=$1
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_FILE="CURRENT_IMPLEMENTATION.md"
HEADER="## Recent Activity"

# Check if the header exists, if not, add it.
if ! grep -q "$HEADER" "$LOG_FILE"; then
  echo -e "\n$HEADER" >> "$LOG_FILE"
fi

# Append the message under the header
echo "- **$TIMESTAMP**: $MESSAGE" >> "$LOG_FILE"

echo "✅ Logged update to $LOG_FILE"
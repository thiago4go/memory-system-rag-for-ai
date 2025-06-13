#!/bin/bash

# log_update.sh - Adds a timestamped entry to progress.md

if [ -z "$1" ]; then
    echo "❌ Error: Log message is required"
    echo "Usage: make log message=\"Your log message\""
    exit 1
fi

MESSAGE="$1"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "- **${TIMESTAMP}**: ${MESSAGE}" >> progress.md

echo "✅ Logged: ${MESSAGE}"

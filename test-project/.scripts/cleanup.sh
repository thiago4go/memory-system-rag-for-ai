#!/bin/bash

# cleanup.sh - Validates structure and cleans temporary files

echo "🧹 Cleaning up Memory System..."

# Remove any temporary files
find . -name "*.tmp" -delete
find . -name "*~" -delete
find . -name ".DS_Store" -delete

# Validate directory structure
REQUIRED_DIRS=("plans/inprogress" "plans/completed" "critical-lessons" "product-view" "tech-context" ".scripts")

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "⚠️  Missing directory: $dir - Creating..."
        mkdir -p "$dir"
    fi
done

# Validate required files
REQUIRED_FILES=("CURRENT_IMPLEMENTATION.md" "progress.md" "systemPatterns.md" "criticalFindings.md")

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "⚠️  Missing file: $file"
    fi
done

echo "✅ Cleanup complete"

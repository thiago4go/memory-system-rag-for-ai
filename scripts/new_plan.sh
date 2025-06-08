#!/bin/bash

# .scripts/new_plan.sh
# Creates a new plan file in plans/inprogress/

if [ -z "$1" ]; then
  echo "Usage: make new-plan name=\"your-plan-name\""
  exit 1
fi

PLAN_NAME=$1
DATE=$(date +%Y-%m-%d)
FILENAME="${DATE}_${PLAN_NAME}.md"
FILEPATH="plans/inprogress/$FILENAME"

# Create the file
cat > $FILEPATH <<- EOM
---
type: plan
status: in_progress
tags: []
updated: $DATE
priority: medium
parent_epic:
---
# Plan: ${PLAN_NAME//-/ }

## 🎯 Objective

## 📋 Action Plan
- [ ] STEP:  #status:pending

## ✅ Success Criteria
EOM

echo "✅ Created new plan: $FILEPATH"
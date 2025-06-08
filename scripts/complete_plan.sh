#!/bin/bash

# .scripts/complete_plan.sh
# Moves a plan from inprogress to completed and updates indexes.

if [ -z "$1" ]; then
  echo "Usage: make complete-plan name=\"YYYY-MM-DD_your-plan-name\""
  exit 1
fi

PLAN_NAME=$1
INPROGRESS_PATH="plans/inprogress/${PLAN_NAME}.md"
COMPLETED_PATH="plans/completed/${PLAN_NAME}.md"

# 1. Verify the plan exists
if [ ! -f "$INPROGRESS_PATH" ]; then
  echo "❌ Error: Plan not found at $INPROGRESS_PATH"
  exit 1
fi

# 2. Move the file
mv "$INPROGRESS_PATH" "$COMPLETED_PATH"
echo "➡️ Moved plan to plans/completed/"

# 3. Update YAML status to 'completed' (using a temp file for portability)
sed "s/status: in_progress/status: completed/" "$COMPLETED_PATH" > "${COMPLETED_PATH}.tmp" && mv "${COMPLETED_PATH}.tmp" "$COMPLETED_PATH"
echo "✏️ Updated status to 'completed' in YAML."

# 4. Append to progress.md
echo "✅ COMPLETED: [${PLAN_NAME}]" >> progress.md
echo "➕ Appended to progress.md"

# 5. Update plans/index.md
# This is a basic implementation; a more robust script might use awk or python
sed -i.bak "/- ${PLAN_NAME}.md/d" plans/index.md && rm plans/index.md.bak
echo "- ${PLAN_NAME}.md" >> plans/index.md # Assuming it moves to a general completed list
echo "🔄 Updated plans/index.md"

echo "🎉 Plan completion for '${PLAN_NAME}' successful."
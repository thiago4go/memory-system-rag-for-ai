#!/bin/bash

# new_plan.sh - Creates a new PLAN file

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "❌ Error: Both EPIC filename and PLAN title are required"
    echo "Usage: make new-plan epic=\"epic-filename\" title=\"Plan Title\""
    exit 1
fi

EPIC_FILE="$1"
TITLE="$2"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
FILENAME="$(date +"%Y-%m-%d")_${SLUG}.md"
FILEPATH="plans/inprogress/${FILENAME}"

# Check if PLAN already exists
if find plans/inprogress/ -name "*.md" -exec grep -l "type: plan" {} \; 2>/dev/null | head -1 | grep -q .; then
    echo "❌ Error: A PLAN already exists in plans/inprogress/"
    echo "Complete the current PLAN before creating a new one."
    exit 1
fi

# Verify EPIC exists
if [ ! -f "plans/inprogress/${EPIC_FILE}" ]; then
    echo "❌ Error: EPIC file 'plans/inprogress/${EPIC_FILE}' not found"
    exit 1
fi

cat > "$FILEPATH" <<EOL
---
type: plan
status: active
priority: high
parent_epic: ${EPIC_FILE}
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
title: ${TITLE}
---

# PLAN: ${TITLE}

## Hypothesis
**Testing**: <assumption>
**Success**: <measurable_outcome>
**Failure**: <failure_criteria>

## Context
- **EPIC**: ${EPIC_FILE}
- **Phase**: <epic_phase>
- **Value**: <expected_benefit>

## Research
- **RAG**: <memory_context>
- **Lessons**: <critical_findings>
- **External**: <sources_if_needed>

## Steps (Validate every 3)
- [ ] STEP 1: <action> → <deliverable> → <value> #status:pending #validate:<criteria>
- [ ] STEP 2: <action> → <deliverable> → <value> #status:pending #validate:<criteria>
- [ ] STEP 3: <action> → <deliverable> → <value> #status:pending #validate:<criteria>
- [ ] **VALIDATION**: <test_method> → Continue/Pivot/Kill?
- [ ] STEP 4: <action> → <deliverable> → <value> #status:pending #validate:<criteria>

## Outcomes
- **User**: <user_benefit>
- **Business**: <business_impact>
- **Technical**: <system_improvement>

## Pivot Triggers
- User fails task (3 attempts)
- Technical blocker
- No value improvement
- Time > Value

## Notes
<additional_context>
EOL

echo "✅ Created PLAN: $FILEPATH"
echo "📝 Next step: Begin executing steps and update status tags"

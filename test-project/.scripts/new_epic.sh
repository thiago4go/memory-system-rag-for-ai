#!/bin/bash

# new_epic.sh - Creates a new EPIC file

if [ -z "$1" ]; then
    echo "❌ Error: EPIC title is required"
    echo "Usage: make new-epic title=\"Your Epic Title\""
    exit 1
fi

TITLE="$1"
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
FILENAME="$(date +"%Y-%m-%d")_${SLUG}.md"
FILEPATH="plans/inprogress/${FILENAME}"

# Check if EPIC already exists
if find plans/inprogress/ -name "*.md" -exec grep -l "type: epic" {} \; 2>/dev/null | head -1 | grep -q .; then
    echo "❌ Error: An EPIC already exists in plans/inprogress/"
    echo "Complete the current EPIC before creating a new one."
    exit 1
fi

cat > "$FILEPATH" <<EOL
---
type: epic
status: active
priority: high
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
title: ${TITLE}
---

# EPIC: ${TITLE}

## MVP Mission
**Problem**: <specific_problem>
**Solution**: <minimum_viable_approach>
**Success**: <measurable_outcome>

## Value Hypothesis
- **User**: <user_benefit>
- **Business**: <revenue_cost_growth>
- **Technical**: <system_improvement>

## Phases
- [ ] PHASE 1: Core MVP <feature> #value:<user_benefit> #validate:<success_criteria>
- [ ] PHASE 2: Enhanced <addition> #value:<improved_experience> #validate:<metrics_improve>
- [ ] PHASE 3: Scale <optimization> #value:<growth_enablement> #validate:<handles_load>

## Success Criteria
- [ ] Users complete <core_action>
- [ ] <business_metric> improves by <amount>
- [ ] System proves <technical_capability>

## Context
<relevant_background_constraints>

## Risks & Pivots
- **High**: <risk_and_mitigation>
- **Medium**: <risk_and_mitigation>
- **Pivot**: <change_criteria>
EOL

echo "✅ Created EPIC: $FILEPATH"
echo "📝 Next step: Update CURRENT_IMPLEMENTATION.md with the new mission"

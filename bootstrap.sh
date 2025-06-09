#!/bin/bash

# bootstrap.sh
# Initializes the entire Memory System v3.1 directory structure and creates all required files

echo "🚀 Bootstrapping Memory System v3.1..."

# Get current timestamp for file headers
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE=$(date +"%Y-%m-%d")

# 1. Create Core Directory Structure
echo "📁 Creating directory structure..."
mkdir -p .scripts
mkdir -p plans/inprogress
mkdir -p plans/completed
mkdir -p critical-lessons
mkdir -p product-view
mkdir -p tech-context

# 2. Create CURRENT_IMPLEMENTATION.md
echo "📄 Creating CURRENT_IMPLEMENTATION.md..."
cat > CURRENT_IMPLEMENTATION.md <<EOF
---
type: implementation
status: active
priority: high
phase: bootstrap
updated: ${TIMESTAMP}
next_review: $(date -d "+1 day" +"%Y-%m-%d")
---

# CURRENT IMPLEMENTATION - LIVING DOCUMENT

**Date**: ${DATE}
**Status**: BOOTSTRAP - System Initialized. Ready for first mission.
**Priority**: HIGH - Define first EPIC.

## 🎯 CURRENT MISSION: None

**Objective**: Define the first high-level mission by creating an EPIC.
**Progress**: 0% - Waiting for \`make new-epic title="your-epic-name"\`

## 📊 PRODUCTION READINESS SCORE

| Directory | Status | Score |
|-----------|--------|-------|
| plans/    | 🟡 Idle | 0%    |

## ✅ CURRENT STATUS

### TACTICAL STATUS:
- **WIP LIMIT**: 0/2 plans active.
- **EXECUTION MODE**: Awaiting first plan.
- **COMMAND STATUS**: System bootstrap complete.
- **MEMORY PROTOCOL**: ✅ FULLY COMPLIANT
- **GIT STATUS**: Not initialized.

## 🔄 MEMORY HYGIENE PROTOCOL

**RULES**:
1. ✅ **UPDATE THIS FILE** after every action
2. ✅ **COMMIT** after every update (>50 lines)
3. ✅ **STORE IN RAG** after major updates
4. ✅ **SINGLE SOURCE OF TRUTH** for current status
5. ✅ **MOVE COMPLETED PLANS** to plans/completed/ directory

## 🧠 LAST RAG QUERY CONTEXT
*No queries executed yet.*

## 📝 RECENT UPDATES
- ${DATE}: System bootstrapped and initialized
EOF

# 4. Create essential knowledge files
echo "📄 Creating knowledge base files..."

# progress.md - append-only log
cat > progress.md <<EOF
---
type: log
status: active
updated: ${DATE}
---

# Progress Log

## ${DATE}
- **BOOTSTRAP**: Memory System v3.1 initialized
- **STATUS**: Ready for first mission definition
EOF

# systemPatterns.md - validated architectural patterns
cat > systemPatterns.md <<EOF
---
type: knowledge
category: patterns
status: active
updated: ${DATE}
---

# System Patterns

## Validated Architectural Patterns

### Memory System Patterns
- **File-System Memory**: Using structured markdown files with YAML frontmatter
- **RAG Integration**: Hybrid search combining vector and graph-based retrieval
- **WIP Limits**: Maximum 2 active work items (1 EPIC + 1 PLAN)
- **Transactional Execution**: Atomic STEP-based progress tracking

### Operational Patterns
- **Zero-Trust Resumption**: Always read current state from files
- **Knowledge-First Planning**: Query RAG before creating new plans
- **Continuous Assimilation**: Real-time knowledge capture during execution

## Anti-Patterns to Avoid
- Working without consulting existing memory
- Creating plans without RAG context
- Exceeding WIP limits
- Incomplete STEP status tracking
EOF

# criticalFindings.md - mission-critical blockers and lessons
cat > criticalFindings.md <<EOF
---
type: knowledge
category: critical
status: active
updated: ${DATE}
---

# Critical Findings

## Mission-Critical Blockers and Lessons

### Bootstrap Phase Findings
- **FINDING**: System requires proper initialization sequence
- **IMPACT**: Without bootstrap, AI cannot maintain state across sessions
- **RESOLUTION**: Created comprehensive bootstrap.sh script
- **STATUS**: Resolved

## Lessons Learned Template

### [Date] - [Finding Title]
- **CONTEXT**: Situation or task being performed
- **FINDING**: What was discovered or what went wrong
- **IMPACT**: How this affected the mission or system
- **RESOLUTION**: How it was resolved or mitigated
- **PREVENTION**: How to prevent this in the future
- **STATUS**: [Open/Resolved/Monitoring]
EOF

# 5. Create Makefile
echo "📄 Creating Makefile..."
cat > Makefile <<EOF
# Makefile for Memory System v3.1 Operations

# Ensure scripts are executable and system is ready
.PHONY: all setup new-epic new-plan complete-plan log status clean

all: setup

setup:
	@chmod +x .scripts/*.sh
	@echo "🛠️  All scripts are now executable."
	@echo "✅ Memory System v3.1 is ready for operation."

# --- Protocol Automation ---

# Creates a new EPIC file
# Usage: make new-epic title="High Level Mission Description"
new-epic:
	@.scripts/new_epic.sh "\$(title)"

# Creates a new PLAN file
# Usage: make new-plan epic="epic-filename" title="Specific Plan Title"
new-plan:
	@.scripts/new_plan.sh "\$(epic)" "\$(title)"

# Completes and archives a plan
# Usage: make complete-plan name="plan-filename"
complete-plan:
	@.scripts/complete_plan.sh "\$(name)"

# Logs a quick update to the main status file
# Usage: make log message="Completed database migration"
log:
	@.scripts/log_update.sh "\$(message)"

# Shows current system status
status:
	@.scripts/show_status.sh

# Check if current EPIC is complete (all PHASEs marked [x])
check-epic:
	@.scripts/check_epic_completion.sh

# Clean up temporary files and validate structure
clean:
	@.scripts/cleanup.sh

# Initialize a git repository if not already done
git-init:
	@if [ ! -d ../.git ]; then 	cd .. && git init; 		cd .. && git add .; 		cd .. && git commit -m "Initial Memory System v3.0 bootstrap"; 		echo "📦 Git repository initialized"; 	else 		echo "📦 Git repository already exists"; 	fi

EOF

# 6. Create helper scripts
echo "🔧 Creating helper scripts..."

# new_epic.sh
cat > .scripts/new_epic.sh <<'EOF'
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

## Mission Objective
[Describe the high-level mission and desired outcome]

## Success Criteria
- [ ] [Define measurable success criteria]
- [ ] [Add more criteria as needed]

## Phases
- [ ] PHASE 1: [First major phase description]
- [ ] PHASE 2: [Second major phase description]
- [ ] PHASE 3: [Additional phases as needed]

## Context & Background
[Provide relevant context, constraints, and background information]

## Dependencies
- [List any external dependencies or prerequisites]

## Risk Assessment
- **High Risk**: [Identify high-risk areas]
- **Medium Risk**: [Identify medium-risk areas]
- **Mitigation**: [Describe risk mitigation strategies]
EOL

echo "✅ Created EPIC: $FILEPATH"
echo "📝 Next step: Update CURRENT_IMPLEMENTATION.md with the new mission"
EOF

# new_plan.sh
cat > .scripts/new_plan.sh <<'EOF'
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

## Objective
[Describe the specific objective this plan will accomplish]

## Parent EPIC
- **File**: ${EPIC_FILE}
- **Phase**: [Which phase of the EPIC does this plan address]

## Prerequisites
- [List any prerequisites or dependencies]

## Steps
- [ ] STEP 1: [First specific, actionable step] #status:pending
- [ ] STEP 2: [Second specific, actionable step] #status:pending
- [ ] STEP 3: [Continue with detailed steps] #status:pending

## Verification Criteria
- [How will you verify each step is complete]
- [What tests or checks will be performed]

## Expected Outcomes
- [List the expected deliverables or outcomes]

## Notes
- [Any additional notes, considerations, or context]
EOL

echo "✅ Created PLAN: $FILEPATH"
echo "📝 Next step: Begin executing steps and update status tags"
EOF

# complete_plan.sh
cat > .scripts/complete_plan.sh <<'EOF'
#!/bin/bash

# complete_plan.sh - Archives a completed plan and marks corresponding PHASE as complete in parent EPIC

if [ -z "$1" ]; then
    echo "❌ Error: Plan filename is required"
    echo "Usage: make complete-plan name=\"plan-filename\""
    exit 1
fi

PLAN_FILE="$1"
SOURCE_PATH="plans/inprogress/${PLAN_FILE}"
DEST_PATH="plans/completed/${PLAN_FILE}"

# Check if plan exists
if [ ! -f "$SOURCE_PATH" ]; then
    echo "❌ Error: Plan file '$SOURCE_PATH' not found"
    exit 1
fi

# Extract parent EPIC filename from the plan's YAML front-matter
PARENT_EPIC=$(grep "^parent_epic:" "$SOURCE_PATH" | sed 's/parent_epic: *//' | tr -d '\r')

if [ -z "$PARENT_EPIC" ]; then
    echo "⚠️  Warning: No parent_epic found in plan YAML front-matter"
    echo "📝 Plan will be archived but EPIC phase won't be auto-marked as complete"
else
    EPIC_PATH="plans/inprogress/${PARENT_EPIC}"
    
    # Check if parent EPIC exists
    if [ -f "$EPIC_PATH" ]; then
        echo "🔍 Found parent EPIC: $EPIC_PATH"
        
        # Extract plan title for matching with PHASE
        PLAN_TITLE=$(grep "^title:" "$SOURCE_PATH" | sed 's/title: *//' | tr -d '\r')
        
        # Create a backup of the EPIC before modifying
        cp "$EPIC_PATH" "${EPIC_PATH}.backup"
        
        # Strategy 1: Try to find PHASE that matches plan title (case-insensitive, partial match)
        if [ -n "$PLAN_TITLE" ]; then
            # Convert plan title to lowercase for matching
            PLAN_TITLE_LOWER=$(echo "$PLAN_TITLE" | tr '[:upper:]' '[:lower:]')
            
            # Look for a PHASE line that contains keywords from the plan title
            PHASE_MATCHED=false
            
            # Try to find and mark the matching phase
            while IFS= read -r line; do
                if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE.*: ]]; then
                    # Extract the phase description
                    PHASE_DESC=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[^:]*:[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
                    
                    # Check if plan title keywords appear in phase description
                    MATCH_FOUND=false
                    for word in $PLAN_TITLE_LOWER; do
                        if [[ ${#word} -gt 3 && "$PHASE_DESC" == *"$word"* ]]; then
                            MATCH_FOUND=true
                            break
                        fi
                    done
                    
                    if [ "$MATCH_FOUND" = true ]; then
                        # Mark this phase as complete
                        sed -i "0,/^\\([[:space:]]*\\)-[[:space:]]*\\[[[:space:]]*\\]\\([[:space:]]*PHASE.*\\)/s//\\1- [x]\\2/" "$EPIC_PATH"
                        echo "✅ Marked PHASE as complete: $(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*//')"
                        PHASE_MATCHED=true
                        break
                    fi
                fi
            done < "$EPIC_PATH"
        fi
        
        # Strategy 2: If no title match found, mark the first uncompleted PHASE
        if [ "$PHASE_MATCHED" = false ]; then
            echo "🔍 No title match found, marking first uncompleted PHASE..."
            
            # Find the first uncompleted PHASE and mark it as complete
            if grep -q "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE" "$EPIC_PATH"; then
                sed -i "0,/^\\([[:space:]]*\\)-[[:space:]]*\\[[[:space:]]*\\]\\([[:space:]]*PHASE.*\\)/s//\\1- [x]\\2/" "$EPIC_PATH"
                COMPLETED_PHASE=$(grep "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE" "$EPIC_PATH" | tail -1 | sed 's/^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*//')
                echo "✅ Marked first uncompleted PHASE as complete: $COMPLETED_PHASE"
                PHASE_MATCHED=true
            fi
        fi
        
        if [ "$PHASE_MATCHED" = false ]; then
            echo "⚠️  Warning: Could not find any uncompleted PHASE to mark in EPIC"
            echo "📝 You may need to manually update the EPIC file"
        else
            # Update EPIC's updated timestamp
            sed -i "s/updated: .*/updated: $(date -u +\"%Y-%m-%dT%H:%M:%SZ\")/" "$EPIC_PATH"
            
            # Remove backup since update was successful
            rm "${EPIC_PATH}.backup"
        fi
        
    else
        echo "⚠️  Warning: Parent EPIC file not found: $EPIC_PATH"
        echo "📝 Plan will be archived but EPIC phase won't be auto-marked as complete"
    fi
fi

# Move plan to completed directory
mv "$SOURCE_PATH" "$DEST_PATH"

# Update the plan's status to completed
sed -i 's/status: active/status: completed/' "$DEST_PATH"
sed -i "s/updated: .*/completed: $(date -u +\"%Y-%m-%dT%H:%M:%SZ\")/" "$DEST_PATH"


echo ""
echo "✅ Plan completion summary:"
echo "   📦 Plan archived: $DEST_PATH"
if [ -n "$PARENT_EPIC" ] && [ "$PHASE_MATCHED" = true ]; then
    echo "   🎯 Marked corresponding PHASE as complete in EPIC"
fi
echo ""
echo "🔄 Next steps:"
echo "   1. Update CURRENT_IMPLEMENTATION.md with detailed state"
echo "   2. Proceed with storing completed plan in RAG system"
echo "   3. Check if EPIC is fully complete (all PHASEs marked [x])"
EOF

# log_update.sh
cat > .scripts/log_update.sh <<'EOF'
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
EOF

# show_status.sh
cat > .scripts/show_status.sh <<'EOF'
#!/bin/bash

# show_status.sh - Shows current system status

echo "🔍 Memory System Status Report"
echo "=============================="

echo ""
echo "📁 Directory Structure:"
echo "  plans/inprogress/: $(ls -1 plans/inprogress/ 2>/dev/null | wc -l) files"
echo "  plans/completed/:  $(ls -1 plans/completed/ 2>/dev/null | wc -l) files"
echo "  critical-lessons/: $(ls -1 critical-lessons/ 2>/dev/null | wc -l) files"

echo ""
echo "🎯 Active Work Items:"
if ls plans/inprogress/*.md 1> /dev/null 2>&1; then
    for file in plans/inprogress/*.md; do
        TYPE=$(grep "^type:" "$file" | cut -d' ' -f2)
        TITLE=$(grep "^title:" "$file" | cut -d' ' -f2-)
        echo "  - $TYPE: $TITLE ($(basename "$file"))"
    done
else
    echo "  - No active work items"
fi

echo ""
echo "📊 Recent Progress:"
tail -5 progress.md 2>/dev/null || echo "  - No progress entries yet"

echo ""
echo "🔧 System Health:"
if [ -f "CURRENT_IMPLEMENTATION.md" ]; then
    echo "  ✅ CURRENT_IMPLEMENTATION.md exists"
else
    echo "  ❌ CURRENT_IMPLEMENTATION.md missing"
fi

if [ -f "AI_OPERATIONAL_PROTOCOL.md" ]; then
    echo "  ✅ AI_OPERATIONAL_PROTOCOL.md exists"
else
    echo "  ❌ AI_OPERATIONAL_PROTOCOL.md missing"
fi

echo "  📦 Git status: $(if [ -d ../.git ]; then echo "Initialized"; else echo "Not initialized"; fi)"
EOF

# check_epic_completion.sh
cat > .scripts/check_epic_completion.sh <<'EOF'
#!/bin/bash

# check_epic_completion.sh - Checks if the current EPIC is complete and suggests next actions

echo "🎯 EPIC Completion Status Check"
echo "==============================="

# Find active EPIC in inprogress directory
EPIC_FILE=$(find plans/inprogress/ -name "*.md" -exec grep -l "type: epic" {} \; 2>/dev/null | head -1)

if [ -z "$EPIC_FILE" ]; then
    echo "❌ No active EPIC found in plans/inprogress/"
    echo "🚀 Next action: Create a new EPIC with 'make new-epic title=\"Your Mission\"'"
    exit 0
fi

echo "📋 Active EPIC: $(basename "$EPIC_FILE")"
EPIC_TITLE=$(grep "^title:" "$EPIC_FILE" | sed 's/title: *//')
echo "📝 Title: $EPIC_TITLE"
echo ""

# Count total phases and completed phases
TOTAL_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\][[:space:]]*PHASE" "$EPIC_FILE")
COMPLETED_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE" "$EPIC_FILE")
REMAINING_PHASES=$((TOTAL_PHASES - COMPLETED_PHASES))

echo "📊 Progress Summary:"
echo "   Total PHASEs: $TOTAL_PHASES"
echo "   Completed: $COMPLETED_PHASES"
echo "   Remaining: $REMAINING_PHASES"

if [ $REMAINING_PHASES -eq 0 ]; then
    echo ""
    echo "🎉 EPIC IS COMPLETE! All phases are marked as [x]"
    echo ""
    echo "🔄 Recommended next actions:"
    echo "   1. Archive this EPIC: mv \"$EPIC_FILE\" plans/completed/"
    echo "   2. Store EPIC in RAG system for future reference"
    echo "   3. Define next high-level mission with new EPIC"
else
    echo ""
    echo "⏳ EPIC IN PROGRESS"
    echo ""
    echo "📋 Remaining PHASEs:"
    grep "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE" "$EPIC_FILE" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*/   • /'
    
    echo ""
    echo "🔄 Recommended next actions:"
    echo "   1. Create a PLAN for the next PHASE"
    echo "   2. Use: make new-plan epic=\"$(basename "$EPIC_FILE")\" title=\"Plan Title\""
fi

echo ""
echo "📈 Completion Rate: $(( (COMPLETED_PHASES * 100) / TOTAL_PHASES ))%"
EOF

# cleanup.sh
cat > .scripts/cleanup.sh <<'EOF'
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
EOF

# 7. Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x .scripts/*.sh

# 8. Create product-view and tech-context placeholder files
echo "📄 Creating context files..."

cat > product-view/README.md <<EOF
---
type: context
category: product
status: active
updated: ${DATE}
---

# Product View

This directory contains product-related context, goals, and definitions.

## Files to Create:
- \`goals.md\` - High-level product goals and objectives
- \`requirements.md\` - Functional and non-functional requirements
- \`stakeholders.md\` - Key stakeholders and their concerns
- \`metrics.md\` - Success metrics and KPIs
EOF

cat > tech-context/README.md <<EOF
---
type: context
category: technical
status: active
updated: ${DATE}
---

# Technical Context

This directory contains technical environment specifications and constraints.

## Files to Create:
- \`architecture.md\` - System architecture overview
- \`constraints.md\` - Technical constraints and limitations
- \`dependencies.md\` - External dependencies and integrations
- \`environment.md\` - Development and deployment environments
EOF

# 9. Final status report
echo ""
echo "🎉 Bootstrap Complete!"
echo "====================="
echo ""
echo "✅ Created directory structure:"
echo "   - plans/inprogress/ (WIP limit: 2)"
echo "   - plans/completed/ (archive)"
echo "   - critical-lessons/ (knowledge)"
echo "   - product-view/ (context)"
echo "   - tech-context/ (context)"
echo "   - .scripts/ (automation)"
echo ""
echo "✅ Created core files:"
echo "   - CURRENT_IMPLEMENTATION.md (single source of truth)"
echo "   - progress.md (append-only log)"
echo "   - systemPatterns.md (validated patterns)"
echo "   - criticalFindings.md (critical lessons)"
echo "   - Makefile (automation commands)"
echo ""
echo "✅ Created helper scripts:"
echo "   - .scripts/new_epic.sh"
echo "   - .scripts/new_plan.sh"
echo "   - .scripts/complete_plan.sh (enhanced with auto-PHASE marking)"
echo "   - .scripts/log_update.sh"
echo "   - .scripts/show_status.sh"
echo "   - .scripts/check_epic_completion.sh"
echo "   - .scripts/cleanup.sh"
echo ""
echo "🚀 Next Steps:"
echo "   1. Run 'make setup' to verify all scripts are executable"
echo "   2. Run 'make status' to see current system status"
echo "   3. Run 'make git-init' to initialize git repository"
echo "   4. Create your first EPIC: make new-epic title=\"Your Mission\""
echo ""
echo "📖 Memory System v3.1 is ready for AI operation!"
EOF

echo "✅ Bootstrap script created successfully!"
echo "🚀 Run './bootstrap.sh' to initialize the Memory System v3.1"

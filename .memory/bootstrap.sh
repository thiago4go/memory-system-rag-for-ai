#!/bin/bash

# bootstrap.sh
# Initializes the entire Memory System directory structure and creates all required files

SYSTEMVERSION="v4.1"
echo "🚀 Bootstrapping Memory System ${SYSTEMVERSION}..."

# Get current timestamp for file headers
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE=$(date +"%Y-%m-%d")

# 1. Create Core Directory Structure
echo "📁 Creating directory structure..."
mkdir -p .scripts
mkdir -p plans/inprogress
mkdir -p plans/completed
mkdir -p critical-lessons


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
- **BOOTSTRAP**: Memory System ${SYSTEMVERSION} initialized
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
# Makefile for Memory System ${SYSTEMVERSION} Operations

# Ensure scripts are executable and system is ready
.PHONY: all setup new-epic new-plan complete-plan log status clean

all: setup

setup:
	@chmod +x .scripts/*.sh
	@echo "🛠️  All scripts are now executable."
	@echo "✅ Memory System ${SYSTEMVERSION} is ready for operation."

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

# Analyze documents and determine processing strategy (Hybrid Strategy 2+3)
# Usage: make analyze-docs path="path/to/docs/directory"
analyze-docs:
	@.scripts/analyze_documents.sh "\$(path)"

# Process document using hybrid strategy based on size
# Usage: make process-doc file="path/to/document.md" 
process-doc:
	@.scripts/process_document_hybrid.sh "\$(file)"

# Legacy: Process large documents progressively
# Usage: make process-large-doc file="path/to/large/file.md"
process-large-doc:
	@.scripts/process_large_document.sh "\$(file)"

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

echo "✅ Created EPIC: $FILEPATH" - GO AND UPDATE IT!
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
- **Web Search**: <relevant_links>
- **Assumptions**: <assumptions>
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

echo "✅ Created PLAN: $FILEPATH" - GO AND UPDATE IT!
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
                if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*: ]]; then
                    # Extract the phase description
                    PHASE_DESC=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
                    
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
                        sed -i "0,/^\\([[:space:]]*\\)-[[:space:]]*\\[[[:space:]]*\\]\\([[:space:]]*PHASE[[:space:]]*[0-9]*:.*\\)/s//\\1- [x]\\2/" "$EPIC_PATH"
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
            if grep -q "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$EPIC_PATH"; then
                sed -i "0,/^\\([[:space:]]*\\)-[[:space:]]*\\[[[:space:]]*\\]\\([[:space:]]*PHASE[[:space:]]*[0-9]*:.*\\)/s//\\1- [x]\\2/" "$EPIC_PATH"
                COMPLETED_PHASE=$(grep "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$EPIC_PATH" | tail -1 | sed 's/^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*//')
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

# show_status.sh - Enhanced system status with actionable guidance

echo "🔍 Memory System v4.1 Status Report"
echo "====================================="

# WIP Limit Validation (CRITICAL)
WIP_COUNT=$(ls -1 plans/inprogress/*.md 2>/dev/null | wc -l)
echo ""
echo "🚨 WIP STATUS: $WIP_COUNT/2 files in plans/inprogress/"
if [ "$WIP_COUNT" -gt 2 ]; then
    echo "❌ WIP LIMIT EXCEEDED - IMMEDIATE ACTION REQUIRED"
    echo "   → Archive completed plans with: make complete-plan"
elif [ "$WIP_COUNT" -eq 0 ]; then
    echo "🟡 No active work - ready for new mission"
else
    echo "✅ WIP limit compliant"
fi

echo ""
echo "📁 Directory Structure:"
echo "  plans/inprogress/: $WIP_COUNT files"
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

# Next Action Guidance (ACTIONABLE)
echo ""
echo "🎯 NEXT ACTION REQUIRED:"
HAS_EPIC=$(find plans/inprogress/ -name "*.md" -exec grep -l "type: epic" {} \; 2>/dev/null | head -1)
HAS_PLAN=$(find plans/inprogress/ -name "*.md" -exec grep -l "type: plan" {} \; 2>/dev/null | head -1)

if [ -z "$HAS_EPIC" ]; then
    echo "   → make new-epic title=\"[MISSION DESCRIPTION]\""
    echo "   → Follow with: make new-plan epic=\"[EPIC-FILE]\" title=\"[PHASE]\""
elif [ -z "$HAS_PLAN" ]; then
    EPIC_FILE=$(basename "$HAS_EPIC")
    echo "   → make new-plan epic=\"$EPIC_FILE\" title=\"[PHASE DESCRIPTION]\""
else
    echo "   → Continue executing PLAN steps (mark inprogress → completed)"
    echo "   → When done: make complete-plan name=\"$(basename "$HAS_PLAN")\""
fi

# RAG Integration Requirements (MANDATORY)
echo ""
echo "🧠 RAG INTEGRATION REQUIRED:"
echo "   → MANDATORY: rag_memory___getKnowledgeGraphStats"
echo "   → MANDATORY: rag_memory___hybridSearch query=\"mission context\" useGraph=true"
echo "   → MANDATORY: Read CURRENT_IMPLEMENTATION.md for context"

echo ""
echo "📊 Recent Progress:"
tail -5 progress.md 2>/dev/null || echo "  - No progress entries yet"

echo ""
echo "🔧 System Health:"
if [ -f "CURRENT_IMPLEMENTATION.md" ]; then
    echo "  ✅ CURRENT_IMPLEMENTATION.md exists"
else
    echo "  ❌ CURRENT_IMPLEMENTATION.md missing - CRITICAL"
fi

if [ -f "AI_OPERATIONAL_PROTOCOL.md" ]; then
    echo "  ✅ AI_OPERATIONAL_PROTOCOL.md exists"
else
    echo "  ❌ Protocol file missing - CRITICAL"
fi

echo "  📦 Git status: $(if [ -d ../.git ]; then echo "Initialized"; else echo "Not initialized"; fi)"

echo ""
echo "📁 Enhanced Directory Structure:"
echo "📝 File structure with type indicators:"
tree .. -L 3 --noreport --charset ascii -F --dirsfirst 2>/dev/null || tree .. -L 3 --noreport --charset ascii 2>/dev/null || echo "tree command not available"

echo ""
echo "⚠️  PROTOCOL ENFORCEMENT:"
echo "   → NEVER work without consulting RAG memory first"
echo "   → NEVER exceed WIP limit (2 files maximum)"
echo "   → ALWAYS follow procedures A/B/C from protocol"
echo "   → ALWAYS commit changes after each step"

echo "====================================="
echo "🔚 Enhanced Status Report Complete"
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
TOTAL_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$EPIC_FILE")
COMPLETED_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$EPIC_FILE")
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
    grep "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$EPIC_FILE" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*/   • /'
    
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
REQUIRED_DIRS=("plans/inprogress" "plans/completed" "critical-lessons" ".scripts")

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

# process_large_document.sh
cat > .scripts/process_large_document.sh <<'EOF'
#!/bin/bash

# process_large_document.sh - Progressive processing for large documents (>10KB or >200 lines)
# Based on critical lesson: /critical-lessons/about-large-documents-processing.md

if [ -z "$1" ]; then
    echo "❌ Error: File path is required"
    echo "Usage: make process-large-doc file=\"path/to/large/file.md\""
    exit 1
fi

FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")
FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
LINE_COUNT=$(wc -l < "$FILE_PATH")

echo "📊 Analyzing document: $FILE_NAME"
echo "   Size: ${FILE_SIZE} bytes"
echo "   Lines: ${LINE_COUNT}"

# Check if document needs progressive processing
if [ "$FILE_SIZE" -lt 10240 ] && [ "$LINE_COUNT" -lt 200 ]; then
    echo "✅ Document is small enough for normal processing"
    echo "   Use: rag_memory___storeDocument id=\"$FILE_NAME\" content=\"\$(cat $FILE_PATH)\""
    exit 0
fi

echo "⚠️  Large document detected - using progressive processing strategy"

# Create temporary directory for sections
TEMP_DIR="/tmp/doc_sections_$$"
mkdir -p "$TEMP_DIR"

# STEP 1: Analyze structure (first 1000 lines)
echo "🔍 Step 1: Analyzing document structure..."
head -1000 "$FILE_PATH" > "$TEMP_DIR/analysis_sample.txt"

# STEP 2: Identify sections via markdown headers
echo "🔍 Step 2: Identifying natural sections..."
grep -n "^#" "$FILE_PATH" > "$TEMP_DIR/headers.txt" 2>/dev/null || echo "No markdown headers found"

# STEP 3: Split into sections based on headers or line count
echo "📤 Step 3: Creating manageable sections..."

if [ -s "$TEMP_DIR/headers.txt" ]; then
    # Split by markdown sections
    echo "   Splitting by markdown headers..."
    SECTION_NUM=1
    CURRENT_LINE=1
    
    while IFS=: read -r line_num header_text; do
        if [ "$SECTION_NUM" -gt 1 ]; then
            # Extract previous section
            PREV_END=$((line_num - 1))
            sed -n "${CURRENT_LINE},${PREV_END}p" "$FILE_PATH" > "$TEMP_DIR/section_${SECTION_NUM}.md"
            echo "   Created section $SECTION_NUM: lines $CURRENT_LINE-$PREV_END"
        fi
        CURRENT_LINE="$line_num"
        SECTION_NUM=$((SECTION_NUM + 1))
    done < "$TEMP_DIR/headers.txt"
    
    # Last section
    sed -n "${CURRENT_LINE},\$p" "$FILE_PATH" > "$TEMP_DIR/section_${SECTION_NUM}.md"
    echo "   Created final section $SECTION_NUM: lines $CURRENT_LINE-end"
    
else
    # Split by line count (every 150 lines to stay under 200 limit)
    echo "   No headers found - splitting by line count (150 lines per section)..."
    split -l 150 -d "$FILE_PATH" "$TEMP_DIR/section_"
    
    # Rename to .md files
    for file in "$TEMP_DIR"/section_*; do
        if [ ! "${file##*.}" = "md" ]; then
            mv "$file" "${file}.md"
        fi
    done
fi

# STEP 4: Process each section with size check
echo "🚀 Step 4: Processing sections into RAG system..."
SECTION_COUNT=0

for section_file in "$TEMP_DIR"/section_*.md; do
    if [ -f "$section_file" ]; then
        SECTION_COUNT=$((SECTION_COUNT + 1))
        SECTION_NAME="${FILE_NAME}_section_${SECTION_COUNT}"
        SECTION_SIZE=$(stat -f%z "$section_file" 2>/dev/null || stat -c%s "$section_file" 2>/dev/null)
        
        echo "   Processing $SECTION_NAME (${SECTION_SIZE} bytes)..."
        
        if [ "$SECTION_SIZE" -gt 30720 ]; then
            echo "   ⚠️  Section still large (>30KB) - applying chunked fallback"
            # Further split large sections
            split -l 100 -d "$section_file" "${section_file}_chunk_"
            for chunk in "${section_file}_chunk_"*; do
                CHUNK_NAME="${SECTION_NAME}_$(basename "$chunk")"
                echo "      Processing chunk: $CHUNK_NAME"
                echo "      📋 GUIDANCE: rag_memory___storeDocument id=\"$CHUNK_NAME\" content=\"\$(cat '$chunk')\""
                echo "      📋 GUIDANCE: rag_memory___chunkDocument documentId=\"$CHUNK_NAME\""
                echo "      📋 GUIDANCE: rag_memory___embedChunks documentId=\"$CHUNK_NAME\""
            done
        else
            echo "   📋 GUIDANCE: rag_memory___storeDocument id=\"$SECTION_NAME\" content=\"\$(cat '$section_file')\""
            echo "   📋 GUIDANCE: rag_memory___chunkDocument documentId=\"$SECTION_NAME\""
            echo "   📋 GUIDANCE: rag_memory___embedChunks documentId=\"$SECTION_NAME\""
        fi
    fi
done

# STEP 5: Create parent document with section references
echo "📋 Step 5: Creating document index..."
SECTION_LIST=""
for i in $(seq 1 $SECTION_COUNT); do
    SECTION_LIST="${SECTION_LIST}${FILE_NAME}_section_${i}, "
done
SECTION_LIST=${SECTION_LIST%, }

DOC_INDEX="# Document Index: $FILE_NAME

Original file: $FILE_PATH
Total sections: $SECTION_COUNT  
Section IDs: $SECTION_LIST

This large document was processed using progressive strategy to maintain semantic integrity.
Query individual sections for detailed content, or use hybridSearch for cross-section discovery.
"

echo "📋 GUIDANCE: rag_memory___storeDocument id=\"${FILE_NAME}_index\" content=\"$DOC_INDEX\""

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "⚠️  DOCUMENT STRUCTURE ANALYSIS COMPLETE - NO RAG PROCESSING PERFORMED"
echo "   📊 Created $SECTION_COUNT section analysis from $FILE_NAME"
echo "   🤖 AI AGENT MUST NOW PROCESS EACH SECTION USING RAG TOOLS"
echo ""
echo "   ⚠️  THIS SCRIPT ONLY PROVIDED GUIDANCE - NO ACTUAL RAG PROCESSING PERFORMED"
echo "   💡 AI AGENT MUST EXECUTE THESE COMMANDS:"
echo "      1. Run the rag_memory___storeDocument commands above"
echo "      2. Extract terms: rag_memory___extractTerms for each section"
echo "      3. Create entities: rag_memory___createEntities based on extracted terms"
echo "      4. Test with: rag_memory___hybridSearch query=\"[document topic]\" useGraph=true"
echo ""
echo "📖 Critical lesson applied: Helper scripts provide honest guidance only"
EOF

# analyze_documents.sh - Hybrid Strategy 2+3 Document Analysis
cat > .scripts/analyze_documents.sh <<'EOF'
#!/bin/bash

# analyze_documents.sh - Analyze documents and determine processing strategy
# Based on proven Hybrid Strategy 2+3 implementation

if [ -z "$1" ]; then
    echo "❌ Error: Documents directory path is required"
    echo "Usage: make analyze-docs path=\"path/to/docs/directory\""
    exit 1
fi

DOCS_PATH="$1"

if [ ! -d "$DOCS_PATH" ]; then
    echo "❌ Error: Directory '$DOCS_PATH' not found"
    exit 1
fi

echo "🔍 HYBRID STRATEGY 2+3 DOCUMENT ANALYSIS"
echo "======================================="
echo "Directory: $DOCS_PATH"
echo ""

# Initialize counters
STANDARD_COUNT=0
PROGRESSIVE_COUNT=0
PROGRESSIVE_CHUNKED_COUNT=0

# Create analysis report
ANALYSIS_FILE="/tmp/doc_analysis_$$.md"
echo "# Document Processing Strategy Analysis" > "$ANALYSIS_FILE"
echo "Generated: $(date)" >> "$ANALYSIS_FILE"
echo "" >> "$ANALYSIS_FILE"

echo "📊 PROCESSING STRATEGY CLASSIFICATION:"
echo ""

for file in "$DOCS_PATH"/*.md "$DOCS_PATH"/*.txt; do
    if [ -f "$file" ]; then
        FILE_NAME=$(basename "$file")
        FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        FILE_SIZE_KB=$((FILE_SIZE / 1024))
        
        # Determine strategy based on proven thresholds
        if [ "$FILE_SIZE" -lt 30720 ]; then
            # <30KB - STANDARD Processing
            STRATEGY="🟢 STANDARD"
            STRATEGY_CODE="STANDARD"
            DESCRIPTION="Direct RAG pipeline: Store → Chunk → Embed → Extract → Link"
            STANDARD_COUNT=$((STANDARD_COUNT + 1))
            
        elif [ "$FILE_SIZE" -lt 102400 ]; then
            # 30-100KB - PROGRESSIVE Processing  
            STRATEGY="🟡 PROGRESSIVE"
            STRATEGY_CODE="PROGRESSIVE"
            DESCRIPTION="Section-by-section processing with structure preservation"
            PROGRESSIVE_COUNT=$((PROGRESSIVE_COUNT + 1))
            
        else
            # >100KB - PROGRESSIVE + CHUNKED FALLBACK
            STRATEGY="🔴 PROGRESSIVE_CHUNKED"
            STRATEGY_CODE="PROGRESSIVE_CHUNKED"
            DESCRIPTION="Progressive + timeout-resistant chunking for oversized sections"
            PROGRESSIVE_CHUNKED_COUNT=$((PROGRESSIVE_CHUNKED_COUNT + 1))
        fi
        
        printf "%-50s %8s KB  %s\n" "$FILE_NAME" "$FILE_SIZE_KB" "$STRATEGY"
        
        # Add to analysis report
        echo "- **$FILE_NAME**: ${FILE_SIZE_KB}KB ($STRATEGY_CODE)" >> "$ANALYSIS_FILE"
        
    fi
done

TOTAL_COUNT=$((STANDARD_COUNT + PROGRESSIVE_COUNT + PROGRESSIVE_CHUNKED_COUNT))

echo ""
echo "📈 STRATEGY DISTRIBUTION:"
echo "🟢 STANDARD Processing:           $STANDARD_COUNT documents"
echo "🟡 PROGRESSIVE Processing:        $PROGRESSIVE_COUNT documents"  
echo "🔴 PROGRESSIVE + CHUNKED:         $PROGRESSIVE_CHUNKED_COUNT documents"
echo "📊 Total Documents:               $TOTAL_COUNT"

if [ "$TOTAL_COUNT" -gt 0 ]; then
    STANDARD_PCT=$((STANDARD_COUNT * 100 / TOTAL_COUNT))
    PROGRESSIVE_PCT=$((PROGRESSIVE_COUNT * 100 / TOTAL_COUNT))
    PROGRESSIVE_CHUNKED_PCT=$((PROGRESSIVE_CHUNKED_COUNT * 100 / TOTAL_COUNT))
    
    echo ""
    echo "📊 Distribution Percentages:"
    echo "   STANDARD: ${STANDARD_PCT}%"
    echo "   PROGRESSIVE: ${PROGRESSIVE_PCT}%"  
    echo "   PROGRESSIVE + CHUNKED: ${PROGRESSIVE_CHUNKED_PCT}%"
fi

# Add distribution to analysis report
echo "" >> "$ANALYSIS_FILE"
echo "## Strategy Distribution" >> "$ANALYSIS_FILE"
echo "- STANDARD: $STANDARD_COUNT documents (${STANDARD_PCT}%)" >> "$ANALYSIS_FILE"
echo "- PROGRESSIVE: $PROGRESSIVE_COUNT documents (${PROGRESSIVE_PCT}%)" >> "$ANALYSIS_FILE"
echo "- PROGRESSIVE + CHUNKED: $PROGRESSIVE_CHUNKED_COUNT documents (${PROGRESSIVE_CHUNKED_PCT}%)" >> "$ANALYSIS_FILE"

echo ""
echo "⚠️  ANALYSIS COMPLETE - NO PROCESSING PERFORMED"
echo "🤖 AI AGENT NEXT STEPS:"
echo ""
echo "1. Store analysis results:"
echo "   📋 GUIDANCE: rag_memory___storeDocument id=\"doc_analysis_$(date +%Y%m%d)\" content=\"\$(cat $ANALYSIS_FILE)\""
echo ""
echo "2. Process documents by strategy:"
echo "   🟢 For STANDARD docs:      make process-doc file=\"path/to/doc.md\""
echo "   🟡 For PROGRESSIVE docs:   make process-doc file=\"path/to/doc.md\""
echo "   🔴 For LARGE docs:         make process-doc file=\"path/to/doc.md\""
echo ""
echo "3. Verify strategy effectiveness:"
echo "   📋 GUIDANCE: rag_memory___getKnowledgeGraphStats"
echo ""
echo "⚠️  THIS SCRIPT PROVIDED ANALYSIS ONLY - AI AGENT MUST EXECUTE PROCESSING"

# Cleanup
rm -f "$ANALYSIS_FILE"
EOF

# process_document_hybrid.sh - Size-aware processing dispatcher
cat > .scripts/process_document_hybrid.sh <<'EOF'
#!/bin/bash

# process_document_hybrid.sh - Execute size-aware processing using Hybrid Strategy 2+3
# Routes documents to appropriate processing based on proven size thresholds

if [ -z "$1" ]; then
    echo "❌ Error: Document file path is required"
    echo "Usage: make process-doc file=\"path/to/document.md\""
    exit 1
fi

FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")

if [ ! -f "$FILE_PATH" ]; then
    echo "❌ Error: File '$FILE_PATH' not found"
    exit 1
fi

FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null || stat -c%s "$FILE_PATH" 2>/dev/null)
FILE_SIZE_KB=$((FILE_SIZE / 1024))

echo "🎯 HYBRID STRATEGY 2+3 DOCUMENT PROCESSOR"
echo "==========================================="
echo "File: $FILE_NAME"
echo "Size: ${FILE_SIZE_KB}KB ($FILE_SIZE bytes)"
echo ""

# Determine processing strategy
if [ "$FILE_SIZE" -lt 30720 ]; then
    # <30KB - STANDARD Processing
    STRATEGY="🟢 STANDARD"
    STRATEGY_CODE="STANDARD"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Direct RAG pipeline"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Execute STANDARD processing commands:"
    echo "   rag_memory___storeDocument id=\"$FILE_NAME\" content=\"\$(cat '$FILE_PATH')\""
    echo "   rag_memory___chunkDocument documentId=\"$FILE_NAME\""
    echo "   rag_memory___embedChunks documentId=\"$FILE_NAME\""
    echo "   rag_memory___extractTerms documentId=\"$FILE_NAME\""
    echo "   rag_memory___searchNodes query=\"[extract key concepts]\" limit=10"
    echo "   rag_memory___createEntities entities=\"[based on extracted terms]\""
    echo "   rag_memory___linkEntitiesToDocument documentId=\"$FILE_NAME\" entityNames=\"[entity list]\""
    
elif [ "$FILE_SIZE" -lt 102400 ]; then
    # 30-100KB - PROGRESSIVE Processing
    STRATEGY="🟡 PROGRESSIVE"
    STRATEGY_CODE="PROGRESSIVE"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Section-by-section with structure preservation"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Use progressive processing helper:"
    echo "   make process-large-doc file=\"$FILE_PATH\""
    echo "   [Then execute all provided rag_memory___ commands]"
    
else
    # >100KB - PROGRESSIVE + CHUNKED FALLBACK
    STRATEGY="🔴 PROGRESSIVE_CHUNKED"
    STRATEGY_CODE="PROGRESSIVE_CHUNKED"
    echo "Strategy: $STRATEGY Processing"
    echo "Method: Progressive + timeout-resistant chunking"
    echo ""
    
    echo "⚠️  PROCESSING GUIDANCE PROVIDED - AI AGENT MUST EXECUTE"
    echo ""
    echo "📋 GUIDANCE: Use enhanced progressive processing:"
    echo "   make process-large-doc file=\"$FILE_PATH\""
    echo "   [Monitor for timeout-resistant chunking fallbacks]"
    echo "   [Execute all provided rag_memory___ commands sequentially]"
fi

echo ""
echo "🎯 PROVEN STRATEGY BENEFITS:"
case "$STRATEGY_CODE" in
    "STANDARD")
        echo "   ✅ Fast processing (no section splitting needed)"
        echo "   ✅ Maintains document context integrity"
        echo "   ✅ Optimal for documents with unified content"
        ;;
    "PROGRESSIVE")
        echo "   ✅ Preserves document structure via markdown headers"
        echo "   ✅ Prevents timeout failures with section processing"
        echo "   ✅ Maintains semantic relationships between sections"
        ;;
    "PROGRESSIVE_CHUNKED")
        echo "   ✅ Handles massive documents (proven up to 145KB)"
        echo "   ✅ Timeout-resistant fallback for oversized sections"
        echo "   ✅ Zero failure rate in production testing"
        ;;
esac

echo ""
echo "📊 NEXT VERIFICATION STEPS:"
echo "   📋 GUIDANCE: rag_memory___getKnowledgeGraphStats"
echo "   📋 GUIDANCE: rag_memory___hybridSearch query=\"$FILE_NAME content overview\" limit=5"
echo ""
echo "⚠️  STRATEGY GUIDANCE COMPLETE - NO ACTUAL RAG PROCESSING PERFORMED"
echo "🤖 AI AGENT MUST NOW EXECUTE ALL PROVIDED RAG COMMANDS"
EOF

# test_regex_patterns.sh - Validation script for regex patterns
cat > .scripts/test_regex_patterns.sh <<'EOF'
#!/bin/bash

# test_regex_patterns.sh - Test regex patterns work with optimized templates

echo "🧪 REGEX PATTERN VALIDATION TEST"
echo "================================="

# Create test EPIC file
TEST_EPIC="/tmp/test_epic_$$.md"
cat > "$TEST_EPIC" <<EOL
---
type: epic
title: Test Epic
---

# EPIC: Test Epic

## Phases
- [ ] PHASE 1: Core MVP <feature> #value:<user_benefit> #validate:<success_criteria>
- [ ] PHASE 2: Enhanced <addition> #value:<improved_experience> #validate:<metrics_improve>
- [x] PHASE 3: Scale <optimization> #value:<growth_enablement> #validate:<handles_load>
EOL

echo "📋 Test EPIC created with optimized template format"

# Test PHASE detection regex
echo ""
echo "🔍 Testing PHASE detection regex..."

TOTAL_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$TEST_EPIC")
COMPLETED_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$TEST_EPIC")
PENDING_PHASES=$(grep -c "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$TEST_EPIC")

echo "   Total PHASEs detected: $TOTAL_PHASES (expected: 3)"
echo "   Completed PHASEs: $COMPLETED_PHASES (expected: 1)"  
echo "   Pending PHASEs: $PENDING_PHASES (expected: 2)"

# Test PHASE listing regex
echo ""
echo "🔍 Testing PHASE listing regex..."
echo "   Pending PHASEs found:"
grep "^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$TEST_EPIC" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]]*\][[:space:]]*/   • /'

# Test PHASE completion regex
echo ""
echo "🔍 Testing PHASE completion regex..."
cp "$TEST_EPIC" "${TEST_EPIC}.backup"

# Mark first pending phase as complete
sed -i "0,/^\\([[:space:]]*\\)-[[:space:]]*\\[[[:space:]]*\\]\\([[:space:]]*PHASE[[:space:]]*[0-9]*:.*\\)/s//\\1- [x]\\2/" "$TEST_EPIC"

COMPLETED_AFTER=$(grep -c "^[[:space:]]*-[[:space:]]*\[x\][[:space:]]*PHASE[[:space:]]*[0-9]*:" "$TEST_EPIC")
echo "   Completed PHASEs after marking: $COMPLETED_AFTER (expected: 2)"

# Cleanup
rm -f "$TEST_EPIC" "${TEST_EPIC}.backup"

echo ""
if [ "$TOTAL_PHASES" -eq 3 ] && [ "$COMPLETED_PHASES" -eq 1 ] && [ "$PENDING_PHASES" -eq 2 ] && [ "$COMPLETED_AFTER" -eq 2 ]; then
    echo "✅ ALL REGEX PATTERNS WORKING CORRECTLY"
    echo "   ✅ PHASE detection: $TOTAL_PHASES/3"
    echo "   ✅ Completion tracking: $COMPLETED_PHASES → $COMPLETED_AFTER"
    echo "   ✅ Pending detection: $PENDING_PHASES"
else
    echo "❌ REGEX PATTERN FAILURES DETECTED"
    echo "   Expected: Total=3, Completed=1→2, Pending=2"
    echo "   Actual: Total=$TOTAL_PHASES, Completed=$COMPLETED_PHASES→$COMPLETED_AFTER, Pending=$PENDING_PHASES"
fi

echo ""
echo "📖 Template compatibility validated"
EOF

# 7. Make all scripts executable
echo "🔧 Making scripts executable..."
chmod +x .scripts/*.sh


# 9. Final status report
echo ""
echo "🎉 Bootstrap Complete!"
echo "====================="
echo ""
echo "✅ Created directory structure:"
echo "   - plans/inprogress/ (WIP limit: 2)"
echo "   - plans/completed/ (archive)"
echo "   - critical-lessons/ (knowledge)"
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
echo "   4. **CRITICAL**: Create EPIC 0 for knowledge bootstrap:"
echo "      make new-epic title=\"Knowledge Base Bootstrap\""
echo "   5. **IMMEDIATELY**: Populate your RAG system with project knowledge:"
echo "      - Store all existing docs: README, package.json, etc."
echo "      - Create project entities in knowledge graph"
echo "      - Test with: rag_memory___hybridSearch query=\"project overview\""
echo ""
echo "📖 Memory System v4.1 is ready for AI operation!"
EOF

echo "✅ Bootstrap script created successfully!"
echo "🚀 Run './bootstrap.sh' to initialize the Memory System ${SYSTEMVERSION}"

#!/bin/bash

# .scripts/bootstrap.sh
# Initializes the entire directory structure and creates blueprint files for the memory system.

echo "🚀 Bootstrapping Memory System v1.5..."

# 1. Create Core Directories
# Based on the map in README.md
echo "Creating directory structure..."
mkdir -p .scripts
mkdir -p plans/inprogress
mkdir -p plans/completed
mkdir -p critical-lessons
mkdir -p product-view
mkdir -p tech-context

# 2. Create Blueprint for CURRENT_IMPLEMENTATION.md
echo "Creating .memory/CURRENT_IMPLEMENTATION.md..."
cat > .memory/CURRENT_IMPLEMENTATION.md <<- EOM
---
type: implementation
status: active
priority: high
phase: bootstrap
updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
next_review: $(date -d "+1 day" +"%Y-%m-%d")
---
# CURRENT IMPLEMENTATION - LIVING DOCUMENT

**Date**: $(date +"%Y-%m-%d")
**Status**: BOOTSTRAP - System Initialized. Ready for first mission.
**Priority**: HIGH - Define first EPIC.

## 🎯 CURRENT MISSION: None

**Objective**: Define the first high-level mission by creating an EPIC.
**Progress**: 0% - Waiting for `make new-plan type=epic name=\"your-epic-name\"`

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
EOM

# 3. Create Blueprint for plans/index.md
echo "Creating plans/index.md..."
cat > plans/index.md <<- EOM
---
type: index
status: active
updated: $(date +"%Y-%m-%d")
---
# Plan Index

## In Progress (WIP)
*This section tracks active EPIC and PLAN files.*

### EPIC:
- *None*

### PLAN:
- *None*

## Completed
*This section is a reference to archived plans.*
EOM

# 4. Create other essential but empty files from the system map
echo "Creating placeholder knowledge files..."
touch .memory/progress.md
touch .memory/systemPatterns.md
touch .memory/criticalFindings.md

# Copy existing protocol and readme if they exist, otherwise create placeholders
if [ -f "AI_OPERATIONAL_PROTOCOL.md" ]; then
    cp AI_OPERATIONAL_PROTOCOL.md .memory/
else
    touch .memory/AI_OPERATIONAL_PROTOCOL.md
fi

if [ -f "README.md" ]; then
    cp README.md .memory/
else
    touch .memory/README.md
fi


echo "🎉 Bootstrap complete. System is ready."
echo "➡️ Next step: Run 'make setup' to ensure all scripts are executable."


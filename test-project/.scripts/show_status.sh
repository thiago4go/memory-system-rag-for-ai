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

if [ -f "AI_OPERATIONAL_PROTOCOL_v4_OPTIMIZED.md" ]; then
    echo "  ✅ AI_OPERATIONAL_PROTOCOL_v4_OPTIMIZED.md exists"
else
    echo "  ❌ Protocol file missing - CRITICAL"
fi

echo "  📦 Git status: $(if [ -d ../.git ]; then echo "Initialized"; else echo "Not initialized"; fi)"

echo ""
echo "📁 Enhanced Directory Structure:"
echo "📝 File structure with type indicators:"
tree -L 3 --noreport --charset ascii -F --dirsfirst 2>/dev/null || tree -L 3 --noreport --charset ascii 2>/dev/null || echo "tree command not available"

echo ""
echo "⚠️  PROTOCOL ENFORCEMENT:"
echo "   → NEVER work without consulting RAG memory first"
echo "   → NEVER exceed WIP limit (2 files maximum)"
echo "   → ALWAYS follow procedures A/B/C from protocol"
echo "   → ALWAYS commit changes after each step"

echo "====================================="
echo "🔚 Enhanced Status Report Complete"

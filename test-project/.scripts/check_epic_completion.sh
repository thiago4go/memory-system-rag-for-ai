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

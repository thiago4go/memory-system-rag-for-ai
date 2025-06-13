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

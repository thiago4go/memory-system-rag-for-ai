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

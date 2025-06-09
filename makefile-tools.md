COMPLETE AI INSTRUCTION GUIDE FOR MEMORY SYSTEM v3.1

## CRITICAL RULES (NEVER BREAK THESE)
1. ALWAYS FOLLOW THE PROTOCOL - No exceptions
2. FOLLOW RULE 1 - If confused, re-read the protocol

## MANDATORY BOOT SEQUENCE (DO THIS FIRST, EVERY SESSION)

bash
# Step 1: Setup system
make setup

# Step 2: Check current state
make status

## TOOL USAGE FLOWCHART

### DECISION TREE:
START → make status → 
├─ No EPIC exists? → make new-epic → make new-plan
├─ EPIC exists, no PLAN? → make new-plan  
├─ PLAN exists? → Execute steps → make complete-plan
└─ All done? → make check-epic


### TOOL REFERENCE CARD:

INFORMATION TOOLS (Use frequently):
• make status - Check what's happening NOW
• make check-epic - See if mission is complete
• rag_memory___getKnowledgeGraphStats - Check memory health

CREATION TOOLS (Use when starting work):
• make new-epic title="Mission Name" - Start new mission
• make new-plan epic="filename" title="Phase Name" - Create detailed plan

COMPLETION TOOLS (Use when finishing):
• make complete-plan name="filename" - Archive finished plan
• make log message="What I did" - Record important events

MAINTENANCE TOOLS (Use regularly):
• make clean - Clean up mess
• rag_memory___listDocuments - See all stored documents

## STEP-BY-STEP PROCEDURES

### PROCEDURE A: Starting New Work
1. make status
2. If no EPIC: make new-epic title="[DESCRIBE MISSION]"
3. make new-plan epic="[EPIC-FILENAME]" title="[PHASE NAME]"
4. Update CURRENT_IMPLEMENTATION.md
5. Commit changes
6. make log message="Started new work: [DESCRIPTION]"


### PROCEDURE B: Continuing Existing Work
1. make status
2. Read active PLAN file
3. Find first step marked #status:pending
4. Change to #status:inprogress
5. DO THE WORK
6. Change to #status:complete
7. Commit changes
8. make log message="Completed step: [DESCRIPTION]"


### PROCEDURE C: Finishing Work
1. make status
2. Verify all steps are #status:complete
3. make complete-plan name="[PLAN-FILENAME]"
4. Store in RAG: rag_memory___storeDocument
5. Process: rag_memory___chunkDocument → rag_memory___embedChunks
6. Update CURRENT_IMPLEMENTATION.md
7. make log message="Completed plan: [DESCRIPTION]"


## SAFETY CHECKLIST (CHECK EVERY 30 MINUTES)

□ make status (know current state)
□ CURRENT_IMPLEMENTATION.md updated?
□ All changes committed to git?
□ WIP limit: Only 2 files in plans/inprogress/?
□ rag_memory___getKnowledgeGraphStats (memory healthy?)


## ERROR RECOVERY PROTOCOL

IF CONFUSED:
1. make status
2. Read CURRENT_IMPLEMENTATION.md
3. Read AI_OPERATIONAL_PROTOCOL.md
4. rag_memory___hybridSearch for context

IF TOOLS FAIL:
1. make clean
2. make setup
3. Try again

IF LOST:
1. make status
2. rag_memory___readGraph
3. Start from PROCEDURE A

## FORBIDDEN ACTIONS
• ❌ Never skip make status
• ❌ Never work without reading protocol
• ❌ Never create work without checking existing context
• ❌ Never forget to update CURRENT_IMPLEMENTATION.md
• ❌ Never exceed WIP limit (2 files in inprogress/)

## REQUIRED ACTIONS
• ✅ Always start with boot sequence
• ✅ Always check status before acting
• ✅ Always query RAG before creating new work
• ✅ Always commit changes
• ✅ Always log important events

## SIMPLE COMMAND TEMPLATES

Check what's happening:
bash
make status


Start new mission:
bash
make new-epic title="Fix the database problem"


Create plan for mission:
bash
make new-plan epic="2025-06-09_fix-database.md" title="Step 1 Analysis"


Record what you did:
bash
make log message="Fixed the connection issue"


Finish a plan:
bash
make complete-plan name="2025-06-09_step-1-analysis.md"


## MEMORY INTEGRATION (CRITICAL)

After completing ANY plan:
bash
# Store the completed work
rag_memory___storeDocument id="plan-name" content="[PLAN CONTENT]"

# Process it
rag_memory___chunkDocument documentId="plan-name"
rag_memory___embedChunks documentId="plan-name"

# Extract knowledge
rag_memory___extractTerms documentId="plan-name"
rag_memory___linkEntitiesToDocument documentId="plan-name" entityNames="[RELEVANT ENTITIES]"


## FINAL RULE
WHEN IN DOUBT: make status → read protocol → ask for help
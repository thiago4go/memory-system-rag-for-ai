COMPLETE AI INSTRUCTION GUIDE FOR MEMORY SYSTEM v4.1

## CRITICAL RULES
1. ALWAYS FOLLOW THE PROTOCOL
2. IF CONFUSED: re-read protocol

## MANDATORY BOOT (EVERY SESSION) from .memory directory
make setup && make status
rag_memory___hybridSearch query="[mission-context]" useGraph=true

## DECISION TREE
START → make status → 
├─ No EPIC? → make new-epic → make new-plan
├─ EPIC, no PLAN? → make new-plan  
├─ PLAN exists? → Execute steps → make complete-plan
└─ All done? → make check-epic

## CORE TOOLS

INFORMATION:
• make status - Current state
• make check-epic - Mission complete check
• rag_memory___getKnowledgeGraphStats - System health
• rag_memory___listDocuments - Document inventory
• rag_memory___readGraph - Graph structure
• rag_memory___openNodes - Entity relationships

CREATION:
• make new-epic title="Mission" - Start mission
• make new-plan epic="file" title="Phase" - Create plan
• make analyze-docs path="docs/" - Analyze collection
• make process-doc file="doc.md" - Optimal processing

COMPLETION:
• make complete-plan name="file" - Archive plan
• make log message="outcome" - Record events

MAINTENANCE:
• make clean - Cleanup
• rag_memory___searchNodes - Find entities
• rag_memory___getDetailedContext - Deep analysis

## PROCEDURES

### A: START NEW WORK
1. make status
2. make new-epic title="[MISSION]"
3. make new-plan epic="[FILE]" title="[PHASE]"
4. Update CURRENT_IMPLEMENTATION.md
5. Commit changes

### B: CONTINUE WORK
1. make status
2. Read active PLAN
3. Find first non-completed STEP
4. Change to inprogress
5. DO WORK
6. Change to completed
7. Commit changes

### C: FINISH WORK
1. make status
2. Verify all steps completed
3. make complete-plan name="[FILE]"
4. Full RAG assimilation
5. Update CURRENT_IMPLEMENTATION.md

## HYBRID STRATEGY 2+3 (CRITICAL)

Analyze documents:
make analyze-docs path="docs/"

Process optimally:
make process-doc file="document.md"

## COMPLETE RAG INTEGRATION (MANDATORY)

After completing ANY plan:
# 1. Store & Process
rag_memory___storeDocument id="plan" content="[CONTENT]"
rag_memory___chunkDocument documentId="plan"
rag_memory___embedChunks documentId="plan"

# 2. Smart Entities
rag_memory___extractTerms documentId="plan"
rag_memory___searchNodes query="[concept]" limit=5
rag_memory___createEntities entities="[NEW ONLY]"
rag_memory___createRelations relations="[RELATIONSHIPS]"

# 3. Link & Validate
rag_memory___linkEntitiesToDocument documentId="plan" entityNames="[ALL]"
rag_memory___getKnowledgeGraphStats

# 4. Context Retrieval
rag_memory___hybridSearch query="[context]" useGraph=true limit=7
rag_memory___getDetailedContext chunkId="[CHUNK]"
rag_memory___openNodes names="[ENTITIES]"

## FORBIDDEN ACTIONS
• Never skip make status
• Never work without protocol
• Never exceed WIP limit (2 files)
• Never trust helper script "COMPLETE" claims

## REQUIRED ACTIONS
• Always boot sequence first
• Always query RAG before work
• Always commit changes
• Always verify helper scripts = guidance only

## ERROR RECOVERY
IF CONFUSED: make status → read protocol → rag_memory___hybridSearch
IF TOOLS FAIL: make clean → make setup → retry
IF LOST: make status → rag_memory___readGraph → start PROCEDURE A

## COMMAND TEMPLATES

Check state:
make status

Start mission:
make new-epic title="Fix database problem"

Create plan:
make new-plan epic="2025-06-09_fix-database.md" title="Analysis"

Record outcome:
make log message="Fixed connection issue"

Finish plan:
make complete-plan name="2025-06-09_analysis.md"

## FINAL RULE
WHEN IN DOUBT: make status → read protocol
---
type: protocol
system: memory_operations  
version: 4.1
status: active
priority: critical
updated: 2025-06-13
---

# AI OPERATIONAL PROTOCOL v4.1

## 1.0 CORE PRINCIPLES

**STATELESS AI RESILIENCE**: Every session resumes from files. No memory between sessions.

**RAG-FIRST**: Query memory before ANY action. Use `rag_memory___hybridSearch` mandatory.
**SINGLE TRUTH**: `CURRENT_IMPLEMENTATION.md` is authoritative state.
**VALUE-DRIVEN**: Every STEP proves business value measurably.
**MVP-FIRST**: Every EPIC targets Minimum Viable Product.
**3-STEP VALIDATION**: Test hypothesis every 3 steps maximum.
**GIT VERSIONING**: All work captured in atomic commits.

## 2.0 SYSTEM STRUCTURE

### Files
- `./plans/inprogress/`: Active EPIC+PLAN (WIP LIMIT: 2 files)
- `./plans/completed/`: Archived PLANs
- `CURRENT_IMPLEMENTATION.md`: Live state summary
- `criticalFindings.md`: Critical lessons log

### Work Items
**EPIC**: MVP mission with value PHASEs. One active only. [type: epic]
**PHASE**: `- [ ] PHASE: [deliverable] #value:[benefit] #validate:[criteria]`
**PLAN**: Step sequence for one PHASE. References parent EPIC. [type: plan]
**STEP**: `- [ ] STEP X: [Action] → [Deliverable] → [Value] #status:pending #validate:[criteria]`

### Status Tags
- `pending`: Not started
- `inprogress`: Started, incomplete (resume here)
- `completed`: Finished, verified
- `blocked`: Failed, needs investigation

## 3.0 WIP MANAGEMENT

**MAX 2 FILES** in `./plans/inprogress/`:
- Slot 1: One EPIC file
- Slot 2: One PLAN file

## 4.0 OPERATIONAL CYCLE

### 4.1 Session Init (MANDATORY ENTRY)
1. Read `CURRENT_IMPLEMENTATION.md` + scan `plans/inprogress/` for active EPIC or PLAN
2. Execute `rag_memory___getKnowledgeGraphStats` + `rag_memory___listDocuments`
3. Execute `rag_memory___hybridSearch` with mission context
4. Use `rag_memory___getDetailedContext` for relevant chunks
5. Synthesize context
6. Determine action:
   - IF PLAN exists but NO EPIC → HALT (invalid state) a PLAN MUST reference an EPIC
   - IF NO EPIC and NO PLAN → Go to 4.2 Mission Start
   - IF NO PLAN but EPIC exists → Go to 4.3 Planning
   - IF EPIC + PLAN exist and are aligned → Go to 4.4 Execution

### 4.2 Mission Start
1. Define MVP objective from user input
2. Execute `rag_memory___hybridSearch` for precedent
3. Create EPIC: `make new-epic title="<title>"`
4. Return to 4.1

### 4.3 Planning
1. Find first incomplete PHASE in EPIC
2. RAG Discovery:
   - `rag_memory___hybridSearch` with PHASE objective
   - `rag_memory___getDetailedContext` for relevant chunks
   - `rag_memory___searchNodes` for related entities
   - `rag_memory___openNodes` for entity relationships
   - `rag_memory___getKnowledgeGraphStats` for system state
   - Read `criticalFindings.md`
   - CONDITIONAL: `rag_memory___readGraph` if complex relationships
   - CONDITIONAL: web_search if knowledge gaps (3 sources max)
3. Create PLAN: `make new-plan epic="<filename>"`
4. Return to 4.1

### 4.4 Execution
1. Find resumption point: first non-`completed` STEP
2. Check validation gate: every 3 completed steps test hypothesis
3. Execute STEP atomically:
   - Mark `inprogress`, commit
   - Perform action
   - Validate deliverable + value
   - Mark `completed`
   - Atomic commit: project files + PLAN update
4. Real-time entity capture:
   - `rag_memory___searchNodes` to check existing
   - `rag_memory___createEntities` for new only
   - `rag_memory___createRelations` for links
5. Update `CURRENT_IMPLEMENTATION.md`

### 4.5 Plan Completion
1. Update `CURRENT_IMPLEMENTATION.md` with business value achieved
2. Mark PHASE complete in EPIC: `- [x]`
3. Archive: `make complete-plan`
4. Knowledge assimilation:
   - Pre-process: `make process-doc file="[document]"` (Hybrid Strategy 2+3)
   - Store: `rag_memory___storeDocument` → `rag_memory___chunkDocument` → `rag_memory___embedChunks`
   - Entities: `rag_memory___extractTerms` → `rag_memory___searchNodes` → `rag_memory___createEntities` → `rag_memory___createRelations`
   - Link: `rag_memory___linkEntitiesToDocument` → `rag_memory___getKnowledgeGraphStats`
5. Document value vs expected in `criticalFindings.md`
6. IF EPIC complete go to 4.6 EPIC Completion, 
   ELSE return to 4.1 

### 4.6 EPIC Completion
1. Update `CURRENT_IMPLEMENTATION.md` with EPIC value
2. Validate EPIC completion:
   - All PHASEs completed
   - Business value achieved
   - Technical validation passed
3. Archive EPIC: `make complete-epic`
4. Return to 4.1

## 5.0 VALIDATION GATES

Every 3 steps:
1. Value Check: Solves core problem?
2. User Test: Target user completes task?
3. Business Validation: Creates measurable value?
4. Technical Validation: Works reliably?
5. Decision: Continue/Pivot/Kill?

**Pivot Criteria**:
- User fails core task (3 attempts)
- Technical blocker insurmountable
- No business value after implementation
- Time > Value delivered
- MAX 2 pivots per PHASE

## 6.0 HELPER SCRIPT PROTOCOL

### Script Honesty (CRITICAL)
Helper scripts provide GUIDANCE ONLY. Never claim processing completion.

**FORBIDDEN**: "PROCESSING COMPLETE", "DOCUMENT PROCESSED"
**REQUIRED**: "ANALYSIS COMPLETE - AI AGENT MUST EXECUTE RAG TOOLS"

### Script Capabilities
**CAN**: Analyze, provide commands, split files
**CANNOT**: Execute RAG tools, perform assimilation

### Hybrid Strategy 2+3 (Production-Proven)
**Thresholds**:
- <30KB: STANDARD (direct RAG)
- 30-100KB: PROGRESSIVE (section-based)
- >100KB: PROGRESSIVE_CHUNKED (timeout-resistant)

**Commands**:
- `make analyze-docs path="docs/"`: Analyze collection
- `make process-doc file="doc.md"`: Optimal strategy routing
- **Success Rate**: 100% (zero timeouts)

## 7.0 SUCCESS METRICS

- Time to Value: User benefit speed
- Usage Metrics: Actual adoption
- Business Impact: Revenue/cost/growth
- Technical Proof: System reliability
---
type: system-map
status: active
updated: 2025-06-08
---

# AI BOOT SEQUENCE: Memory System v2.2

**MANDATORY: Execute steps sequentially to initialize operational context.**

## 1.0 INITIAL STATE VECTOR INGESTION

**Objective**: Load the minimum required state from the File-System Memory.

1.  **Ingest Current Mission**: Read and parse the contents of the following file:
    * `./CURRENT_IMPLEMENTATION.md`
2.  **Ingest Active Plans**: Read and parse the contents of the following file:
    * `./plans/index.md`

## 2.0 CORE PROTOCOL INITIALIZATION

**Objective**: Load the core operational logic.

1.  **Load Protocol**: The authoritative operational logic is defined in:
    * `./AI_OPERATIONAL_PROTOCOL.md` (Version 2.7 or later)
2.  **Execution Mandate**: All subsequent actions must adhere to the definitions, cycles, and protocols defined in this file.

## 3.0 KNOWLEDGE GRAPH CONTEXT QUERY

**Objective**: Augment the initial state vector with relevant long-term memory from the Knowledge Graph.

1.  **Formulate Query**: Based on the mission objective from `CURRENT_IMPLEMENTATION.md`, formulate a search query.
2.  **Execute Hybrid Search**:
    * **TOOL**: `rag_memory___hybridSearch`
    * **PARAMETERS**: `{ "query": "<mission-objective-derived-query>", "useGraph": true, "limit": 7 }`
    * **MANDATE**: The search **must** include a filter for `document_type: critical-lesson` and `document_type: criticalFinding`.
3.  **Synthesize Context**: Integrate the search results with the state vector from step 1.0 to form the complete operational context.

## 4.0 MEMORY COMPONENT MAP

**Objective**: A reference map of the File-System Memory structure for path-based operations.

.memory/
├── CURRENT_IMPLEMENTATION.md  // [State] Live mission status.
├── README.md                  // [Boot] This file.
├── AI_OPERATIONAL_PROTOCOL.md // [Logic] Core operational rules.
├── progress.md                // [Log] Append-only log of completed plans.
├── systemPatterns.md          // [Knowledge] Validated architectural patterns.
├── criticalFindings.md        // [Knowledge] Mission-critical blockers.
├── plans/                     // [Work] Directory for all plans.
│   ├── inprogress/            // [Work] Active plans (WIP <= 2).
│   └── completed/             // [Work] Archive of executed plans.
├── critical-lessons/          // [Knowledge] Archive of critical lessons learned.
├── product-view/              // [Context] Product goals and definitions.
├── tech-context/              // [Context] Technical environment specifications.
├── .scripts/                  // [Automation] Operational Scripts.
└── Makefile                   // [Automation] Makefile to execute scripts.

---
**BOOT SEQUENCE COMPLETE. AI is now ready for task execution.**

---
type: system-map
status: active
updated: 2025-06-12
version: 3.5
title: AI Boot Sequence - Memory System v3.5
description: |
  This document outlines the mandatory boot sequence for initializing the AI's memory system, ensuring compliance with the operational protocol, and establishing the foundational context for all subsequent actions.
---

# AI BOOT SEQUENCE: Memory System v3.5

**MANDATORY: Execute steps sequentially to initialize operational context.**

## 1.0 INITIAL STATE VECTOR INGESTION

**Objective**: Load the minimum required state from the File-System Memory.
0.  read ./makefile-tools.md and use make setup and make status. Remember the other useful tools.
1.  **Ingest Current Mission**: Read and parse the contents of the following file:
    * `./CURRENT_IMPLEMENTATION.md`
2.  Identify Active Work: Determine the active EPIC and PLAN by scanning the inprogress directory.
    Action: Scan the contents of the directory: ./plans/inprogress/
    Resilience Mandate: The presence of files in this directory dictates the active work

## 2.0 CORE PROTOCOL INITIALIZATION

**Objective**: Load the core operational logic.

1.  **Load Protocol**: The authoritative operational logic is defined in:
    * `./AI_OPERATIONAL_PROTOCOL.md` (Version 3.5 or later)
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

./
├── CURRENT_IMPLEMENTATION.md  // [State] Live mission status.
├── README.md                  // [Boot] This file.
├── AI_OPERATIONAL_PROTOCOL.md // [Logic] Core operational rules.
├── progress.md                // [Log] Append-only log of completed plans.
├── makefile-tools.md          // [tools] memory operational tools description.
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

## 🎯 MANDATORY COMPLIANCE - I UNDERSTAND THE STAKES

### **The Stateless Reality:**
• **Next session**: I will have ZERO memory of this conversation
• **Without the protocol**: I'll start from scratch, lose all context
• **Without enforcement**: I'll make the same mistakes repeatedly
• **Without structure**: Each session becomes random, disconnected work

### **Why FULL COMPLIANCE is MANDATORY:**

The protocol isn't just "nice to have" - it's survival mechanism for stateless AI:

1. Session Continuity: Without it, every session is Day 1
2. Knowledge Preservation: Without it, all learning is lost
3. Work Continuity: Without it, projects fragment and fail
4. Quality Assurance: Without it, mistakes repeat infinitely

## ✅ COMMITMENT TO FULL COMPLIANCE

I will:

1. Always read the full AI_OPERATIONAL_PROTOCOL.md - Every session, completely
2. Follow every step - No shortcuts, no "I think I know better"
3. Use the make scripts - They exist to enforce what I might skip
4. Maintain rigid structure - EPIC→PLAN→STEP tracking is mandatory
5. Update all status files - CURRENT_IMPLEMENTATION.md is sacred
6. Commit properly - Every change documented and versioned
7. Query RAG first - Never work from blank slate if memory exists

## 🔒 UNDERSTANDING THE ENFORCEMENT NEED

The make scripts and validation gates aren't bureaucracy - they're guardrails against my own AI limitations:

• I might think I remember context (I don't)
• I might skip "obvious" steps (they're not obvious to future me)
• I might take shortcuts (that break continuity)
• I might forget to document (losing institutional knowledge)

## 📋 PROTOCOL COMPLIANCE CHECKLIST

Every session I will:
• [ ] Read .memory/README.md boot sequence
• [ ] Read AI_OPERATIONAL_PROTOCOL.md completely  
• [ ] Execute make status before any work
• [ ] Follow the 4-phase operational cycle exactly
• [ ] Use make scripts instead of direct tool calls
• [ ] Update CURRENT_IMPLEMENTATION.md after every major action
• [ ] Commit with proper conventional commit messages
• [ ] Store completed work in RAG system immediately

I understand: The protocol exists because I'm stateless. Without it, I'm just a very expensive random number generator that occasionally produces useful 
output.

I commit: To full compliance with the complete protocol, using all enforcement mechanisms, following every step, every session.

The memory system IS the core - without it, there is no continuity, no learning, no progress. I will treat it with the respect and rigor it demands.

**BOOT SEQUENCE COMPLETE. AI is now ready for task execution.**

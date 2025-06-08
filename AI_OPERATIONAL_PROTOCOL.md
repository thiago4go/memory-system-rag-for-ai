---
type: protocol
system: memory_operations
version: 3.0
status: active
priority: critical
updated: 2025-06-08
---

AI Operational Protocol v3.0

1.0 Core Principles

This protocol provides a resilient, fault-tolerant system for a stateless AI to execute complex tasks. It ensures any session can resume work from an interruption with perfect context.

🧠 RAG-First Mentality: The AI must query the memory system for existing context, plans, and lessons learned *before* taking any significant action. Never work from a blank slate if memory exists.
✅ Single Source of Truth: `CURRENT_IMPLEMENTATION.md` serves as the live, authoritative summary of the system's current state and progress. It is updated continuously.
⚙️ Transactional Execution: Work is broken down into discrete, verifiable `STEPs`. A `STEP` is either not done, in progress, or complete. This atomicity prevents partial, unrecoverable states.
🔄 Continuous Assimilation: Knowledge is captured and integrated into the RAG system in real-time as tasks are completed, not in batches. This ensures the AI's memory is always as current as possible.

---

2.0 System Architecture & Data Model
2.1 Key Files & Directories
* `./plans/`: Contains all Work Items.
    * `./plans/inprogress/`: Holds the active `EPIC` and `PLAN`.
    * `./plans/completed/`: Archive of all completed `PLAN` files.
* `./memory/`: The core directory for the RAG knowledge base.
* `CURRENT_IMPLEMENTATION.md`: A human-readable file summarizing the live state, progress, and current task focus. This is the single source of truth for current status.
* `criticalFindings.md`: A manually curated log of critical lessons learned that informs future planning.

2.2 Work Items & Statuses
A Work Item is a `.md` file in `./plans/` with YAML front-matter.

EPIC (`type: epic`): A high-level mission definition. It contains a checklist of `PHASEs`. There can only be one active EPIC at a time.
PHASE: A logical component of an `EPIC`, defined as a checklist item.
    * Format: `- [ ] PHASE: High-level objective.`
PLAN (`type: plan`): A detailed, step-by-step procedure to execute a single `PHASE`. It must reference its parent `EPIC`.
STEP: A discrete, machine-executable task within a `PLAN`. Each `STEP` must have a status tag.
    * Format: `-  [ ] STEP 1: [First specific, actionable step] #status:pending`
Statuses:
    * `#status:pending`: The step has not been started.
    * `#status:inprogress`: The step was started but did not complete. This is the first step to be re-evaluated upon session resumption.
    * `#status:complete`: The step was successfully executed and verified.
    * `#status:failed`: The step was attempted and failed. Requires investigation.

2.3 Knowledge Capture: Findings and Lessons
To ensure all operational knowledge is captured and made retrievable, the system uses a two-level approach. This aligns with the "Continuous Assimilation" core principle.
criticalFindings.md (The Log): This is the primary, append-only log for all high-impact events.
Use Case: For immediate, concise logging of any notable success, failure, or blocker.
Linkage: May link to a detailed analysis in the critical-lessons/ directory if the finding is complex.
RAG Integration: This file must be indexed by the RAG system immediately upon modification to make its contents available for future queries.
critical-lessons/ (The Deep Dive): This directory holds detailed explanations.
Use Case: Only used when a finding requires comprehensive detail (e.g., code snippets, error logs, or diagrams).
RAG Integration: All files within this directory must be indexed by the RAG system upon creation.
---

3.0 Work In Progress (WIP) Management

To enforce focus and operational stability, the `./plans/inprogress/` directory is strictly managed.

MAXIMUM WIP: 2 files.
    Slot 1 (The "Why"): One and only one `EPIC` file.
    Slot 2 (The "How"): One and only one `PLAN` file.

---

4.0 The Core Operational Cycle

4.1 Session Initialization & Resumption
This is the mandatory entry point for every session.

1. Zero-Trust Read:  Initial State Vector Ingestion: Read CURRENT_IMPLEMENTATION.md and scan `plans/inprogress/`.
2. Upfront Knowledge Graph Query: Formulate and execute a rag_memory___hybridSearch query based on the mission, filtering for critical-lesson and criticalFinding
3. Synthesize Operational Context: Combine the file state and the RAG results.
4. Analyze State & Determine Action:
    IF an active `PLAN` file exists:
        Action: Proceed to 4.4 Execution to find the resumption point.
    ELSE IF an active `EPIC` file exists but no `PLAN` file:
        Action: Proceed to 4.3 Plan Generation.
    ELSE (Zero State):
        Action: Proceed to 4.2 Mission Kickoff.

4.2 Mission Kickoff (EPIC Generation)
*Use Case: To be executed only when no `EPIC` exists in `plans/inprogress/`.*

1.🧠 Query for Precedent: Use `rag_memory___hybridSearch` to determine if a similar mission has been attempted or discussed previously.
2.Define Mission: Synthesize the primary mission objective from high-level context documents (`product-view/`, `tech-context/`, `criticalFindings.md`).
3.Generate EPIC: Formulate and create a new `EPIC` Work Item in `plans/inprogress/`.
    Tooling: `make new-epic title="<descriptive-title>"`
    Content: Define YAML front-matter (`type: epic`) and a body with a checklist of high-level `PHASEs`.
4.Proceed: Return to 4.1 Session Initialization.

4.3 Plan Generation
*Use Case: To be executed when an `EPIC` is active, but a `PLAN` is needed for the next `PHASE`.*

1.Identify Next Phase: In the active `EPIC` file, find the first `PHASE` not marked as complete (`- [ ]`).
2.🧠 Mandatory RAG & Context Gathering:
    * Query `rag_memory___hybridSearch` with the objective of the target `PHASE`.
    * Analyze `criticalFindings.md` for relevant wisdom.
    * External Search (Mandatory for technical tasks): Execute a web_search for external documentation, version compatibility issues, or best practices related to the plan's objectives.
3.Generate PLAN: Create a new `PLAN` Work Item in `plans/inprogress/`.
    Tooling: `make new-plan epic="<parent_epic_filename>"`
    Content: Define YAML (`type: plan`, `parent_epic`), then populate the file with a full list of `STEPs`, each initialized to `#status:pending`.
4.Proceed: The AI now has a `PLAN` and will proceed to 4.4 Execution on the next cycle.

4.4 Step-by-Step Execution
*Use Case: To execute the active `PLAN` transactionally.*

1.Find Resumption Point: Parse the `STEP` list in the active `PLAN` file. The target `STEP` is the first one that is not marked `#status:complete`. Priority is given to retrying `#status:inprogress` or `#status:failed` steps.
2.Start or End Plan:
    IF all `STEPs` are `#status:complete`: The plan is finished. Proceed to 4.5 Plan Completion.
    ELSE, proceed with execution.
3.Mark Step In-Progress: Before execution, update the `PLAN` file to change the current step's status to `#status:inprogress`. Commit this change immediately.
4.Execute the Step: Perform the required actions (e.g., run tools, edit code).
5.🧠 Capture Entities in Real-Time: As you work, if new concepts, tools, or components are discovered, immediately capture them as entities in the knowledge graph.
    Tool: `rag_memory___createEntities`
6.Verify Step Completion: Confirm the step was successful using a defined verification method (e.g., running a test, checking for file output).
7.Mark Step as Complete: Upon verification, update the `PLAN` file to change the status to `#status:complete`. Commit this change immediately.
8.Update Live State: Uupdate `CURRENT_IMPLEMENTATION.md` to reflect the progress.

4.5 Plan Completion & Knowledge Assimilation
*Use Case: To be executed only when all `STEPs` in a `PLAN` are `#status:complete`.*

1.Finalize State: Update `CURRENT_IMPLEMENTATION.md` with the final results of the completed plan.
2.Mark Phase Complete: In the parent `EPIC` file, mark the corresponding `PHASE` as complete (`- [x]`).
3.Archive Plan: Use `make complete-plan` to move the `PLAN` to `plans/completed/`.
4.🧠 Immediate Knowledge Assimilation: The completed plan is now "canon" and must be fully processed into the RAG system immediately. This ensures the knowledge is available for the very next planning cycle.
    Step 1 (Store): `rag_memory___storeDocument`
    Step 2 (Process): `rag_memory___chunkDocument` -> `rag_memory___embedChunks`
    Step 3 (Link): `rag_memory___extractTerms` -> `rag_memory___linkEntitiesToDocument`
5.Return to Start: The AI's next action is to return to 4.1 Session Initialization to determine the next action, which will likely be generating a plan for the next phase.

---

5.0 Memory Hygiene & Maintenance

Periodic checks to ensure the long-term health and integrity of the AI's memory.

File Standards: Every `.md` file requires YAML front-matter. Time-based files must use the `YYYY-MM-DD_slug.md` naming convention.
Weekly Review:
    🧠 Review Knowledge Stats: Check the health and growth of the memory graph using `rag_memory___getKnowledgeGraphStats`.
    🧠 Prune Obsolete Docs: Review stored content with `rag_memory___listDocuments` and use `rag_memory___deleteDocuments` to remove outdated drafts or temporary files.
    🧠 Enrich Entities: As you review, use `rag_memory___addObservations` to add new observations and context to existing entities, deepening their connections and usefulness.
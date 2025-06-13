---
type: knowledge
category: patterns
status: active
updated: 2025-06-13
---

# System Patterns

## Validated Architectural Patterns

### Memory System Patterns
- **File-System Memory**: Using structured markdown files with YAML frontmatter
- **RAG Integration**: Hybrid search combining vector and graph-based retrieval
- **WIP Limits**: Maximum 2 active work items (1 EPIC + 1 PLAN)
- **Transactional Execution**: Atomic STEP-based progress tracking

### Operational Patterns
- **Zero-Trust Resumption**: Always read current state from files
- **Knowledge-First Planning**: Query RAG before creating new plans
- **Continuous Assimilation**: Real-time knowledge capture during execution

## Anti-Patterns to Avoid
- Working without consulting existing memory
- Creating plans without RAG context
- Exceeding WIP limits
- Incomplete STEP status tracking

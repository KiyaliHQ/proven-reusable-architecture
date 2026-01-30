---
title: "ADR Process"
description: Architecture Decision Records - Process for documenting architectural decisions
pra:
  name: ADR Process
  category: pratique-architecture
  status: candidate
  tags: [adr, architecture, documentation, decisions]
  created_at: 2025-01-30
  updated_at: 2025-01-30
  proven_in_use: []
---

# ADR Process (Architecture Decision Records)

## Context

**ADRs (Architecture Decision Records)** are a structured way to document important architectural decisions and their context.

## Problem Solved

- Undocumented architectural decisions
- Loss of context over time
- Difficulty understanding "why" a decision was made

## Solution

Standardized process for:
- Documenting each significant decision
- Capturing context and alternatives
- Maintaining a decision history

## ADR Template

```markdown
# ADR-XXX: Decision Title

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Context
What is the problem or situation?

## Decision
What is the decision made?

## Consequences
What are the positive and negative impacts?

## Alternatives Considered
What other options were evaluated?
```

## Workflow

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│ Proposed │ → │ Review   │ → │ Accepted │
└──────────┘    └──────────┘    └──────────┘
                     ↓
               ┌──────────┐
               │ Rejected │
               └──────────┘
```

## Best Practices

1. **One ADR = One decision** - Stay focused
2. **Immutable** - Don't modify, create a new ADR
3. **Rich context** - Document the "why"
4. **Links** - Reference related ADRs

## Status

🔵 **Candidate** - Under validation

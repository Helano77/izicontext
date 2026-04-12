# Architectural Decisions

This directory contains Architecture Decision Records (ADRs) for this service.

## Format

Files are named `NNN-short-title.md` (e.g., `001-use-postgres.md`).

### Template

```markdown
# ADR-NNN: [Title]

**Status:** Proposed | Accepted | Deprecated | Superseded by [ADR-NNN]
**Date:** YYYY-MM-DD
**Deciders:** [names or team]

## Context
[What situation prompted this decision?]

## Decision
[What was decided?]

## Consequences
### Positive
- [benefit]

### Negative / Trade-offs
- [trade-off]

## History
| Version | Date | Change |
|---------|------|--------|
| 1.0 | YYYY-MM-DD | Initial |
```

## Conventions
- Sequential numbering: `001`, `002`, `003`
- Status values: `Proposed`, `Accepted`, `Deprecated`, `Superseded by ADR-NNN`
- When superseding: mark old ADR as `Superseded by ADR-NNN`, create new ADR with `Supersedes ADR-NNN` in context

## Adding a Decision
Use `/add-decision` in Claude Code for interactive creation.

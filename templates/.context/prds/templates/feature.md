# PRD: [Feature Name]

**Created:** YYYY-MM-DD
**Status:** Draft | Approved | In Progress | Done
**Author:** [name]
**Notion page:** [link if applicable]

---

## Problem Statement
[What user or business problem are we solving? Be specific.]

## Goal
[What does success look like? Measurable if possible.]

---

## Clarifying Questions (answered before writing this PRD)
1. [question and answer]
2. [question and answer]
3. [question and answer]

---

## Scope

### In scope
- [what this feature covers]

### Out of scope
- [what is explicitly NOT part of this]

---

## Services Affected
| Service | Impact | Changes needed |
|---------|--------|----------------|
| [service-name] | [owner / new endpoint / schema change] | [what changes] |

---

## API Changes

### New endpoints
```
METHOD /v1/[path]
Request: { ... }
Response: { ... }
```

### Modified endpoints
[what changes and why — include migration path if breaking]

### New events
| Topic | Schema | Producer | Consumers |
|-------|--------|----------|----------|
| `org.service.entity.action` | `{ ... }` | [service] | [services] |

---

## Data Model Changes
[New tables / columns / indexes. Include migration strategy.]

---

## Architecture Decisions Required
- [ ] [decision that needs to be made]

## Existing ADRs to respect
- [ADR-NNN: title] — [how it constrains this feature]

---

## Implementation Phases

### Phase 1: [name]
- [ ] [task]
- [ ] [task]
**Validation:** [how we know this phase is complete]

### Phase 2: [name]
- [ ] [task]
**Validation:** [test or check]

---

## Success Criteria
- [ ] [measurable criterion]
- [ ] All existing tests pass
- [ ] New unit tests written for new business logic
- [ ] Integration tests cover the happy path

---

## Risks & Open Questions
| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| [risk] | high/med/low | [how to mitigate] |

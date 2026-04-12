# /generate-prd [feature description]

Generate a Product Requirements Document (PRD) for a new feature. Optimized for microservices — captures service impact, API contracts, and event changes at the right level of detail.

---

## Phase 1 — Ask 10 clarifying questions

**Do not skip this phase.** Ask all questions before writing the PRD.

Use `AskUserQuestion` with a multiline prompt containing all 10 questions:

1. Who is the user or system that needs this feature? (internal service, end user, other team)
2. What is the specific problem being solved? What breaks or is missing today?
3. Which services do you think will be affected? (even rough guesses)
4. Will this require new API endpoints, changes to existing ones, or only internal changes?
5. Are there new events to publish or consume? Which topics?
6. Does this touch shared data models or require database migrations?
7. What are the hard constraints? (latency SLA, backward compatibility, zero-downtime deploy)
8. Are there existing ADRs in `.context/decisions/` that constrain the approach?
9. What's the priority order if trade-offs arise: delivery speed / correctness / extensibility?
10. Is there a Notion page or ticket with more context? (share the URL)

Wait for answers. Do not proceed until all are answered.

---

## Phase 2 — Analyze current state

Read:
- `CLAUDE.md` — service identity, stack, rules
- `.context/CONTEXT.md` — current API contracts, events, service map
- `.context/decisions/` — ADRs that may apply
- `.context/services/` — service docs for affected services
- Relevant `internal/` packages mentioned in answers

Identify:
- What exists that can be reused
- What will need to change
- ADR conflicts to flag
- Services that need coordination

---

## Phase 3 — Draft the PRD

Create `.context/prds/generated/YYYYMMDD-[feature-slug].md` using `.context/prds/templates/feature.md`.

Fill in every section:

**Services Affected table**: be specific — list each service and exactly what changes (new endpoint, schema change, new consumer, etc.)

**API Changes**: write actual request/response shapes, not just "add endpoint". For breaking changes, include migration path.

**Events**: full topic name (`org.service.entity.action`), schema struct shape, producer, all known consumers.

**Data Model Changes**: actual column/table names if determinable. Always include migration strategy (zero-downtime vs maintenance window).

**Implementation Phases**: break into phases of 1–3 days each. Each phase must have a concrete validation step.

**ADR conflicts**: if any existing decision is in tension with this feature, flag it explicitly and propose resolution options.

---

## Phase 4 — Confirm and save

Show the user the PRD summary (services affected, API changes, phases).

Ask: "Does this PRD capture what you need, or should we adjust anything?"

After confirmation, report the file path and suggest next step: `/execute-prd [filename]`

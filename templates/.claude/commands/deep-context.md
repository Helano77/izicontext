# /deep-context [query] [--repo path] [--cache]

Structured 4-step exploration of a Go microservice. Uses specialized agents to build understanding from architecture down to data flow.

**Flags:**
- `--repo path` — explore a specific repo (local path or git URL)
- `--cache` — reference previous discoveries from `.context/discoveries/`

---

## Phase 0 — Gather focused context

Load: `.claude/agents/gather-context/gather-context.md`
Context: [query argument]

Wait for the Context Block.

If `--cache`: list files in `.context/discoveries/` whose slug matches the query. Read the most recent matching file and append its Key Findings to the Context Block as "Cached findings."

---

## Steps 1+2 — Run in parallel

### Step 1 — Overview Agent
Context: Context Block from Phase 0
Load: `.claude/agents/deep-context/step1-overview.md`

### Step 2 — Services Agent
Context: Context Block from Phase 0
Load: `.claude/agents/deep-context/step2-services.md`

Wait for both to complete before proceeding.

---

## Step 3 — Drill Agent (uses Steps 1+2 output)
Load: `.claude/agents/deep-context/step3-drill.md`
Context: query + Step 1 output + Step 2 output

---

## Step 4 — Data Flow Agent (uses Step 3 output)
Load: `.claude/agents/deep-context/step4-dataflow.md`
Context: query + Step 3 output

---

## Output

Filter: remove any finding with confidence < 50%.

Every finding must cite `file:line`. No fabrication.

Save to `.context/discoveries/YYYYMMDD-[query-slug].md`:

```markdown
# Discovery: [query]
Date: YYYY-MM-DD

## Overview
[Step 1 summary]

## Service Map
[Step 2 summary]

## Deep Dive
[Step 3 findings with file:line]

## Data Flow
[Step 4 trace]

## Key Findings
- [finding with file:line]

## Open Questions
- [what couldn't be determined from code alone]
```

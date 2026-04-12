# /execute-prd [prd-name]

Implement a feature from a PRD in `.context/prds/generated/`. Follows decision compliance, Go conventions, and validates each phase.

---

## Step 1 — Load context

Read:
- `.context/prds/generated/[prd-name].md` — the PRD
- `CLAUDE.md` — service rules and conventions
- `.context/decisions/` — ADRs
- `.context/CONTEXT.md` — current API surface
- Relevant source files mentioned in the PRD

If the PRD file is not found, list available PRDs in `.context/prds/generated/` and ask which one.

---

## Step 2 — Decision compliance check

Before writing a single line of code, check every implementation decision in the PRD against `.context/decisions/`:

- Does the approach conflict with any accepted ADR?
- If yes: **stop and inform the user** which ADR(s) are affected
- Ask: proceed and supersede the ADR / modify approach to comply / cancel

Only proceed if there are no unresolved conflicts.

---

## Step 3 — Offer worktree isolation

Ask the user via `AskUserQuestion`:

> "Would you like to work in an isolated git worktree for this feature? This lets you keep your main workspace clean and work on multiple features in parallel."
>
> Options: Yes / No

If yes, detect branch type from PRD content:
- New functionality → `feature/[prd-slug]`
- Bug correction → `bugfix/[prd-slug]`
- Urgent fix → `hotfix/[prd-slug]`
- Maintenance → `chore/[prd-slug]`

Create worktree and switch to it.

---

## Step 4 — Implement phase by phase

For each phase in the PRD:

1. **Announce the phase** — print phase name and tasks
2. **Implement tasks** — follow Go conventions from CLAUDE.md:
   - Import organization (stdlib → external → internal)
   - Error wrapping with context
   - Context as first param
   - Constructor pattern
   - No business logic in handlers
3. **Write tests** — table-driven unit tests for new business logic; integration tests for new endpoints
4. **Validate** — run the phase's validation step:
   - `go build ./...` — must pass
   - `go test ./[affected-packages]/...` — must pass
   - `golangci-lint run ./[affected-packages]/...` — must pass (if lint available)
5. **Stop on failure** — diagnose the error, fix it, revalidate. Do not proceed to next phase with broken code.

---

## Step 5 — Update context files

After all phases complete:

- Update `.context/CONTEXT.md` API Contracts section with new endpoints/events
- If a new ADR was needed, create it in `.context/decisions/`
- Update PRD status to `Done` with completion date

---

## Step 6 — Final report

Summary:
- Phases completed
- Files changed (list with line counts)
- Tests added
- Any TODOs left for follow-up
- Suggested next step: `/create-pr` or `/code-review`

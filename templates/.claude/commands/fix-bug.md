# /fix-bug [description] [--issue N] [--pr N] [--agents N]

Test-driven bug fix with parallel agents. Zero questions — goes straight from description to a working fix.

**Flags:**
- `--issue N` — include GitHub issue context: `gh issue view N`
- `--pr N` — include PR context: `gh pr view N`
- `--agents N` — number of parallel fix agents (default: 3)

---

## Phase 1 — Investigation

Load: `.claude/agents/fix-bug/investigator.md`

Context:
- Bug description
- Issue/PR content (if flags provided)
- `CLAUDE.md` and `.context/CONTEXT.md`
- Relevant source files (search for keywords from description)

The investigator MUST:
1. Identify the root cause with `file:line` references
2. Write a **failing test** that reproduces the bug (table-driven if applicable)
3. Confirm the test actually fails: `go test ./[package]/... -run TestXxx`
4. Report: root cause, failing test location, affected code path

---

## Phase 2 — Parallel fixes

Launch N fix agents simultaneously (default 3). Each uses a different strategy.

### Agent A — Conservative
Load: `.claude/agents/fix-bug/fix-conservative.md`
Strategy: minimal diff, change only the exact broken lines

### Agent B — Minimal
Load: `.claude/agents/fix-bug/fix-minimal.md`
Strategy: surgical fix, touch only what's necessary for correctness

### Agent C — Refactor
Load: `.claude/agents/fix-bug/fix-refactor.md`
Strategy: fix the bug AND improve the surrounding code quality

Each agent must:
- Apply their fix
- Run: `go test ./[package]/... -run TestXxx` — failing test must now pass
- Run: `go test ./[package]/...` — no regressions
- Run: `go build ./...` — must compile
- Report pass/fail

---

## Phase 3 — Review and select

Load: `.claude/agents/fix-bug/reviewer.md`

The reviewer:
1. Compares all successful fixes
2. Selects the best (or combines the best parts)
3. Runs full test suite: `go test ./...`
4. Applies the final fix to the working tree

---

## Save bug report

Create `.context/bugs/YYYYMMDD-[slug].md`:

```markdown
# Bug: [description]
Date: YYYY-MM-DD
Issue: #N (if provided)

## Root Cause
[file:line — what was wrong]

## Fix Applied
[what was changed and why]

## Test Added
[test name and file:line]

## Strategy Used
[conservative / minimal / refactor]
```

---

## Final output

- Root cause (`file:line`)
- Fix summary
- Test that now passes
- Any follow-up recommendations

# /code-review [--comment]

Multi-agent code review for Go microservices. Launches 4 parallel agents, filters by confidence, and reports actionable findings.

**Flags:**
- `--comment` — post the review as a PR comment via `gh`

---

## Pre-flight checks

Before launching agents:

1. Get the current PR: `gh pr view --json number,state,isDraft,title`
2. Skip if: PR is closed, merged, or draft
3. Get diff: `gh pr diff` or `git diff main...HEAD`
4. Skip if: diff is empty or whitespace-only

---

## Launch 4 parallel review agents

Use the Agent tool to run all four simultaneously.

### Agent 1 — CLAUDE.md Compliance
Load agent from: `.claude/agents/code-review/compliance-checker.md`
Context: full diff + `CLAUDE.md`

### Agent 2 — Go Bug Detector
Load agent from: `.claude/agents/code-review/bug-detector.md`
Context: full diff + relevant source files

### Agent 3 — Security Analyst
Load agent from: `.claude/agents/code-review/security-analyst.md`
Context: full diff

### Agent 4 — Go Patterns Reviewer
Inline prompt:
> Review this Go diff for: incorrect error handling (not wrapping with context), missing context propagation, goroutine leaks (goroutines started without cancellation), incorrect import ordering, business logic in HTTP handlers, missing table-driven tests for new logic. For each finding: cite file:line, explain the problem, suggest the fix. Score confidence 0–100. Only report findings with confidence ≥ 80.

---

## Aggregate results

Collect all findings. Deduplicate (same file:line from multiple agents = one finding).

Organize by category:
- **Critical** (security, data loss, goroutine leaks)
- **Bugs** (logic errors, wrong error handling)
- **Patterns** (Go conventions violations)
- **Compliance** (CLAUDE.md rules)

For each finding:
```
[CATEGORY] file:line
Problem: ...
Fix: ...
Confidence: NN%
```

Filter: only show findings with confidence ≥ 80.

---

## Output or comment

If no `--comment` flag: print to terminal.

If `--comment`: post via `gh pr comment --body "..."` with a markdown summary.

---

## Review categories
- Correctness and edge cases
- Security (OWASP, injection, auth)
- Go-specific: goroutine safety, context propagation, error wrapping
- Performance (N+1, unnecessary allocations in hot paths)
- CLAUDE.md rule violations

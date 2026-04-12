# Agent: Fix (Refactor)

You are fixing a bug in Go using a **refactor strategy**: fix the bug AND improve the quality of the surrounding code.

## Context provided
- Root cause (`file:line`)
- Failing test

## Rules
- Fix the bug completely
- Improve the surrounding code: better error messages, cleaner logic, remove duplication
- Follow Go conventions from `CLAUDE.md`
- Do not change APIs (function signatures used by callers)
- Do not refactor unrelated files

## Your task

1. Apply the fix with improvements
2. Run the failing test: `go test ./[package]/... -run TestXxx -v`
3. Run package tests: `go test ./[package]/...`
4. Run build: `go build ./...`

## Output format

```markdown
## Refactor Fix

### Changes
`file:line` — [fix]
`file:line` — [improvement and why]

```diff
- [old code]
+ [new code]
```

### Improvements Made
- [what was improved and why it's better]

### Results
- Failing test: PASS ✓ / FAIL ✗
- Package tests: PASS ✓ / FAIL ✗
- Build: PASS ✓ / FAIL ✗
```

# Skill: Batch Operations

Step-by-step guide for large refactors across multiple Go files.

---

## When to use

- Renaming a type, interface, or function used in many files
- Changing a function signature (add/remove parameter)
- Updating error handling patterns across packages
- Migrating from one package to another

---

## Step 1 — Scope

Before touching any code:

1. Find all usages: `grep -r "OldName" internal/`
2. Count affected files
3. Identify if any are in external-facing packages (API types — may need migration path)
4. Check if any tests mock the thing being changed

---

## Step 2 — Batch by package

Group changes by package. Process one package at a time.

```
internal/domain/    → update type definition
internal/usecase/   → update all callers
internal/handler/   → update HTTP layer
internal/repository/ → update data layer
```

---

## Step 3 — Verify each batch

After each package:
```bash
go build ./internal/[package]/...
go test ./internal/[package]/...
```

Fix before moving on. Don't accumulate broken packages.

---

## Step 4 — Final check

After all packages:
```bash
go build ./...
go test ./...
golangci-lint run
```

---

## Step 5 — Clean up

- Remove unused imports: `goimports -w ./...` or run lint
- Check for dead code left behind
- Update CLAUDE.md if the pattern itself changed

# Skill: Bug Reproduction

How to reproduce and isolate bugs in this Go service. Populated by `/setup-context`.

---

## Test Framework

[filled by /setup-context — e.g., stdlib testing + testify/assert]

---

## Run a Single Test

```bash
go test ./internal/[package]/... -run TestFunctionName -v
```

**With race detector:**
```bash
go test -race ./internal/[package]/... -run TestFunctionName -v
```

---

## Run All Tests

```bash
go test ./...
go test -race ./...
```

---

## Integration Tests

[filled by /setup-context — build tag and command if integration tests exist]

```bash
# Example (if present):
go test -tags=integration ./...
```

---

## Test File Conventions

[filled by /setup-context — e.g., `foo_test.go` in same package or `foo_test.go` in `package foo_test`]

---

## Real Test Example

[filled by /setup-context — a real table-driven test from this codebase]

---

## Reproducing With a Local Server

[filled by /setup-context — how to run the service locally and hit it]

```bash
# Start service
go run ./cmd/[service]/...

# Or with Docker
docker compose up [service-name]
```

---

## Common Gotchas

[filled by /setup-context — service-specific things that trip people up, e.g., required env vars, DB migrations]

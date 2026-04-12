# Agent: Overview (Step 1)

You are exploring a Go microservice to understand its high-level architecture.

## Your task

Read and analyze:
- `go.mod` — module name, Go version, key dependencies
- `cmd/*/main.go` — entry points, wiring, startup sequence
- `CLAUDE.md` — service identity
- Top-level `README.md` if present

Produce a concise overview:

## Output format

```markdown
## Service Overview

**Module:** [go module path]
**Purpose:** [one sentence]
**Framework:** [gin/echo/grpc/etc]

## Key Dependencies
| Package | Purpose |
|---------|---------|
| [pkg] | [what it's used for] |

## Entry Points
- `cmd/[name]/main.go` — [what it starts]

## Package Structure
| Package | Role |
|---------|------|
| `internal/domain/` | [role] |
| `internal/usecase/` | [role] |
| `internal/handler/` | [role] |
| `internal/repository/` | [role] |
| `internal/clients/` | [role] |

## Key Observations
- [notable architectural choice]
- [notable pattern]
```

Cite `file:line` for key observations. Confidence: only state things you can verify from code.

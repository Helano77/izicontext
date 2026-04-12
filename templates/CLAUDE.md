# {{projectName}}

## Decision Compliance
Before implementing any change:
1. Check `.context/decisions/` for related ADRs
2. If your change conflicts with an existing decision, **stop and inform the user** which ADR(s) are affected
3. Ask explicitly: proceed and update the decision, modify approach to comply, or cancel
4. If updating, create a versioned ADR (mark old one as Superseded)

## Service Identity
- **Service:** {{projectName}}
- **Responsibility:** [what this service does — one sentence]
- **Domain:** [bounded context / domain it belongs to]
- **Owns:** [data entities this service is the source of truth for]
- **Depends on:** [upstream services]
- **Exposes:** [REST endpoints / gRPC services / events published]

## Stack
- **Language:** Go [version]
- **Framework:** [gin / echo / fiber / grpc / stdlib]
- **Database:** [postgres / mysql / redis / mongo — with driver]
- **Message broker:** [kafka / rabbitmq / nats / none]
- **Container:** Docker + [k8s / docker-compose]

## Commands
- **Run:** `go run ./cmd/[service-name]/...`
- **Test:** `go test ./...`
- **Test (verbose):** `go test -v -race ./...`
- **Lint:** `golangci-lint run`
- **Build:** `go build -o bin/[service-name] ./cmd/[service-name]`
- **Docker:** `docker compose up`

> If running inside Docker: prefix commands with `docker compose exec [service] `

## Go Conventions

### Import Organization (goimports order)
```go
import (
    // 1. stdlib
    "context"
    "fmt"

    // 2. external
    "github.com/gin-gonic/gin"

    // 3. internal (this service)
    "github.com/org/{{projectName}}/internal/domain"
)
```

### Error Handling
- Wrap with context: `fmt.Errorf("operation description: %w", err)`
- Sentinel errors: `var ErrNotFound = errors.New("not found")`
- Custom error types only for recoverable, typed errors
- Never swallow errors silently

### Context Propagation
- `context.Context` is always the **first parameter** in function signatures
- Pass context through the entire call chain
- Respect cancellation: check `ctx.Err()` in long loops

### API Calls Between Services
- Use the client in `internal/clients/` — never call other services directly
- Always pass context and handle timeouts
- Log the service name and error on failure

## Critical Rules
1. Always ask before assuming — read the file first
2. Follow existing package structure before creating new packages
3. No goroutine leaks — every goroutine must have a cancellation path
4. Table-driven tests are the default for unit tests
5. No business logic in HTTP handlers — use service/use-case layer

## Architecture
### Service Structure
[filled by /setup-context]

### API Contracts
[filled by /setup-context]

### Event Schema
[filled by /setup-context]

### Inter-Service Dependencies
[filled by /map-services]

## Efficiency Rules
- Read before changing — load only what you need
- Follow existing patterns before inventing new ones
- Load context progressively — don't read everything upfront
- Run targeted tests: `go test ./internal/domain/...` not `go test ./...`
- Code only — skip explanations unless asked

## Compact Instructions
When compacting, preserve: test results, file paths, decisions, API contracts
Remove: exploratory reads, verbose output, rejected approaches

# {{projectName}} — Service Context

## Overview
- **Service:** {{projectName}}
- **Domain:** [bounded context — e.g., payments, identity, catalog]
- **Team:** [team responsible]
- **Repository:** [git URL]
- **Purpose:** [one paragraph — what problem this service solves]

---

## Service Map

### This Service
| Attribute | Value |
|-----------|-------|
| Responsibility | [core responsibility] |
| Data ownership | [entities this service owns] |
| Deployment | [k8s namespace / docker-compose service name] |
| Port | [HTTP port] / [gRPC port] |

### Upstream Dependencies (services this calls)
| Service | Protocol | Purpose | Client location |
|---------|----------|---------|----------------|
| [service-name] | REST/gRPC/event | [why we call it] | `internal/clients/[name]/` |

### Downstream Consumers (services that call or subscribe to us)
| Service | Protocol | What they consume |
|---------|----------|------------------|
| [service-name] | REST/gRPC/event | [endpoint or event name] |

---

## API Contracts

### REST Endpoints
| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/v1/[resource]` | Bearer | [description] |
| POST | `/v1/[resource]` | Bearer | [description] |

### gRPC Services
```protobuf
// Located in proto/[service].proto
service [ServiceName] {
  rpc [MethodName] ([RequestType]) returns ([ResponseType]);
}
```

### Events Published
| Topic | Schema | When |
|-------|--------|------|
| `[org].[service].[entity].[action]` | `internal/events/[name].go` | [trigger] |

### Events Consumed
| Topic | Handler | Action |
|-------|---------|--------|
| `[org].[service].[entity].[action]` | `internal/consumers/[name].go` | [what we do] |

---

## Go Module Structure
```
module github.com/[org]/{{projectName}}

cmd/
  [service-name]/       # main entrypoint
    main.go

internal/               # private to this service
  domain/               # business entities and rules
  usecase/              # application logic / use cases
  handler/              # HTTP handlers (thin layer)
  repository/           # data access
  clients/              # typed clients for other services
  consumers/            # event consumers
  events/               # event schema structs

pkg/                    # shareable (if any)

proto/                  # protobuf definitions (if gRPC)
```

---

## Conventions

### Naming Patterns
- Packages: lowercase, single word (`domain`, `usecase`, `handler`)
- Interfaces: noun, not `I`-prefixed (`Repository`, not `IRepository`)
- Constructors: `New[Type](...)` returning `*Type` or interface
- Errors: `Err[Condition]` sentinel, `[Type]Error` custom struct

### Error Handling
- Wrap with caller context: `fmt.Errorf("usecase.CreateOrder: %w", err)`
- HTTP layer maps domain errors to status codes — no `errors.As` in handlers
- Log at the boundary (handler/consumer), not inside domain

### Testing Style
- Table-driven unit tests with `t.Run`
- Black-box tests in `package [name]_test`
- Integration tests in `_test/integration/` with build tag `//go:build integration`
- Mocks generated with `mockgen` or `testify/mock`

### Import Organization
```go
import (
    // stdlib — alphabetical
    "context"
    "fmt"

    // external — alphabetical
    "github.com/gin-gonic/gin"
    "go.uber.org/zap"

    // internal — alphabetical
    "github.com/org/{{projectName}}/internal/domain"
)
```

### State Management
- No global state except `var Err... = errors.New(...)`
- Dependencies injected via constructors
- Config loaded once at startup, passed down

### API Response Format
```json
{
  "data": { ... },
  "error": null
}
// or on error:
{
  "data": null,
  "error": { "code": "NOT_FOUND", "message": "..." }
}
```

---

## Main Flows
### [Key Flow 1 — e.g., Create Order]
1. [step]
2. [step]
3. [step]

### [Key Flow 2]
1. [step]

---

## Infrastructure
- **Config:** environment variables via `internal/config/config.go`
- **Observability:** [Prometheus / OpenTelemetry / Datadog]
- **Health check:** `GET /health` → `{"status":"ok"}`
- **Migrations:** [golang-migrate / goose / Atlas — location]

---

## External Integrations
| System | Type | Purpose | SDK/Client |
|--------|------|---------|-----------|
| [name] | REST/SDK | [why] | [package] |

---

## Glossary
| Term | Definition |
|------|-----------|
| [domain term] | [what it means in this service's context] |

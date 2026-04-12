# Service Registry

This directory maps all microservices that interact with (or are part of) the same system.

Each file documents one service: its responsibilities, API surface, and how it connects to others.

## Format

Files are named `[service-name].md` (e.g., `payment-service.md`, `user-service.md`).

### Template

```markdown
# [service-name]

**Repository:** [git URL or local path]
**Team:** [owner team]
**Status:** active | deprecated | planned

## Responsibility
[One sentence: what problem does this service solve?]

## Data Ownership
- [entity 1]
- [entity 2]

## Exposes

### REST
| Method | Path | Description |
|--------|------|-------------|
| GET | `/v1/...` | ... |

### gRPC
| Service | Method | Description |
|---------|--------|-------------|
| ... | ... | ... |

### Events Published
| Topic | When |
|-------|------|
| `org.service.entity.action` | ... |

## Depends On
| Service | Why |
|---------|-----|
| [service] | [reason] |

## Notes
[anything important that isn't obvious]
```

## Populating

Use `/map-services` in Claude Code to auto-detect and document services from:
- `go.mod` imports
- Docker Compose `depends_on`
- Kubernetes service resources
- Existing `internal/clients/` packages
- `.context/CONTEXT.md` external integrations section

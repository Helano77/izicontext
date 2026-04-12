# Agent: Services Map (Step 2)

You are mapping inter-service dependencies in a Go microservice.

## Your task

Read:
- `internal/clients/` — client packages for other services
- `docker-compose.yml` or `docker-compose.yaml`
- Kubernetes manifests in `k8s/`, `deploy/`, `helm/`
- Environment variable references in `internal/config/`
- `.context/services/` — existing service docs

For each external service dependency:

1. Identify the service name
2. Determine the protocol (REST/gRPC/events)
3. Find the client implementation (`internal/clients/[name]/`)
4. Extract: base URL source, timeout config, auth method, retry logic
5. List which methods/endpoints are called

## Output format

```markdown
## Service Dependencies

### [service-name] (REST/gRPC/events)
**Client:** `internal/clients/[name]/` (file:line)
**Base URL:** from env var `[VAR_NAME]`
**Timeout:** [value or "not configured"]
**Auth:** [Bearer/API key/mTLS/none]
**Calls:**
- `[Method]` → `[endpoint or gRPC method]` — [purpose]

**Gaps:** [what's unknown or needs team input]
```

For each service. Cite `file:line` for every claim.

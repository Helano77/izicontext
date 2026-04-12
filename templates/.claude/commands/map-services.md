# /map-services

Map all services in the system that interact with this service. Creates or updates `.context/services/` docs.

---

## Step 1 — Discover services

Find references to other services from:

1. **`internal/clients/`** — each subdirectory is typically a service client
2. **`docker-compose.yml`** — `services:` keys and `depends_on:`
3. **Kubernetes manifests** (`k8s/`, `deploy/`, `helm/`) — `Service` resources and env vars like `*_SERVICE_URL`
4. **Environment variable names** — `*_SERVICE_URL`, `*_GRPC_ADDR`, `*_BASE_URL`
5. **`.context/CONTEXT.md`** — upstream/downstream tables already filled
6. **`go.mod`** — internal org packages that suggest sibling services

List all discovered services before proceeding.

---

## Step 2 — Document each service

For each discovered service, create or update `.context/services/[service-name].md` using the template in `services/README.md`.

Fill in from what's observable:
- **Responsibility**: infer from client package name, env var names, comments
- **Exposes**: extract from client method names and request/response types in `internal/clients/[name]/`
- **Protocol**: REST, gRPC, or events — infer from client implementation
- **Events**: look for topic constants or string literals in consumers/publishers

If a service is in a known repo path, note it. Mark uncertain fields with `[unknown — verify with team]`.

---

## Step 3 — Update CONTEXT.md Service Map

Sync the upstream/downstream tables in `.context/CONTEXT.md` with the service docs just created.

---

## Step 4 — Report

List:
- Services documented (new or updated)
- Services where info is incomplete (needs team input)
- Any circular dependencies found
- Suggestion: run `/deep-context` for deeper analysis of a specific service interaction

# /setup-context

Analyze this Go microservice and populate all context files. Work through each task in order.

---

## Task 1 — Detect service basics

Read: `go.mod`, `cmd/*/main.go`, `Dockerfile`, `docker-compose.yml`, `README.md` (if exists).

Extract:
- Module path (e.g. `github.com/org/service-name`)
- Go version
- Framework (gin/echo/fiber/grpc/stdlib)
- Key external dependencies (database drivers, message brokers, observability)
- Entry point(s)

---

## Task 2 — Populate CLAUDE.md

Fill in all placeholder sections in `CLAUDE.md`:
- **Service Identity**: responsibility, domain, what it owns, upstream deps, what it exposes
- **Stack**: Go version, framework, database, message broker
- **Commands**: exact run/test/lint/build commands from go.mod scripts or Makefile
- **Architecture sections**: structure, API contracts, event schema (stubs — Task 5 fills details)

Rules:
- Replace all `[placeholder]` text with real values
- If Docker Compose is present, add the `docker compose exec` prefix note
- Do NOT modify the Decision Compliance or Efficiency Rules sections

---

## Task 3 — Fill CONTEXT.md domain sections

Fill in `.context/CONTEXT.md`:
- **Overview**: service name, domain, purpose paragraph
- **Service Map**: populate upstream/downstream tables from `internal/clients/`, import paths, and docker-compose `depends_on`
- **Glossary**: extract domain terms from package names, type names, comments

Leave API Contracts and Events for Task 4.

---

## Task 4 — Document API contracts and events

Read: `internal/handler/`, `internal/transport/`, `proto/*.proto`, `internal/events/`, `internal/consumers/`.

Fill in CONTEXT.md:
- **REST Endpoints**: method, path, auth, description for each handler
- **gRPC Services**: from proto files
- **Events Published**: topic names, schema struct, trigger
- **Events Consumed**: topic, handler file, action taken

Use `file:line` references for each entry.

---

## Task 5 — Detect Go conventions

Sample 5–15 Go files across: `internal/domain/`, `internal/usecase/`, `internal/handler/`, `internal/repository/`.

Detect and document in CONTEXT.md Conventions section:
- **Import organization**: are they using goimports grouping? custom order?
- **Error handling**: sentinel errors, custom types, wrapping pattern
- **Testing style**: table-driven? testify? standard library only? naming pattern?
- **Constructor pattern**: `New*` functions, dependency injection approach
- **Context propagation**: always first param? any deviations?
- **API response format**: envelope struct? raw types?

---

## Task 6 — Create ADRs for existing decisions

Identify architectural decisions already made (evidenced by the code):
- Choice of framework
- Database and ORM/driver
- Message broker
- Error handling approach
- Testing strategy

For each: create `.context/decisions/NNN-[slug].md` using the template in `decisions/README.md`.
Start numbering from `001`. Use status `Accepted`.

---

## Task 7 — Populate go-patterns skill

Read `.claude/skills/go-patterns/SKILL.md`.

Fill in with real patterns from this codebase:
- Actual constructor examples from `internal/`
- Real error wrapping patterns found
- Actual table-driven test examples
- Interface usage patterns

---

## Task 8 — Populate bug-reproduction skill

Read `.claude/skills/bug-reproduction/SKILL.md`.

Fill in:
- Test command (`go test ./...` or with flags)
- Test file naming convention
- Integration test build tag if present
- A real test example from the codebase

---

## Task 9 — Populate service-communication skill

Read `.claude/skills/service-communication/SKILL.md`.

Fill in with real patterns from `internal/clients/`:
- How HTTP clients are constructed (base URL, timeout, auth)
- How context is passed to external calls
- How errors from other services are handled
- How retries are done (if any)

---

## Task 10 — Verify MCP configuration

Check `.mcp.json`:
- If `notion` is configured but `NOTION_API_KEY` env var isn't set, warn the user
- If Context7 is configured, confirm `npx` is available
- If `.mcp.json` doesn't exist, remind user to run `izicontext init` or configure manually

---

## Task 11 — Configure StatusLine

Check `.claude/scripts/statusline.sh` exists and is executable.
If not, remind user to run `izicontext update`.

---

## Task 12 — Verify .gitignore

Check `.gitignore` excludes:
- `bin/`, `dist/`, `*.out`, `coverage.txt`
- `.env` (but not `.env.example`)
- `vendor/` (if not using vendor mode)

If any are missing, append them and note what was added.

---

## Completion

After all tasks, summarize:
- Files populated
- ADRs created (list titles)
- Any warnings (missing config, incomplete sections)
- Next suggested command: `/map-services` to document inter-service dependencies

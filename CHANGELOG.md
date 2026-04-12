# Changelog

## v0.1.0 — 2026-04-12

Initial release.

### Features
- `izicontext init` — initialize context structure for Go microservices
- `izicontext update` — update CLI and templates (Terraform-style preview)
- `izicontext doctor` — health check (Go toolchain + context structure)
- `izicontext completion` — bash/zsh tab completion

### Claude Code Commands (13)
- `/setup-context` — analyze Go service and populate all context files (12 tasks)
- `/generate-prd` — plan a feature with 10 clarifying questions (microservices-aware)
- `/execute-prd` — implement a PRD phase by phase with decision compliance
- `/map-services` — auto-detect and document inter-service dependencies
- `/code-review` — 4 parallel agents (compliance, Go bugs, security, Go patterns)
- `/commit` — style-aware commit message generation
- `/create-pr` — PR with auto-detected architecture diagrams
- `/pr-comment` — add comments and diagrams to PRs
- `/deep-context` — 4-step service exploration (overview → services → drill → dataflow)
- `/fix-bug` — test-driven bug fix with parallel agents
- `/add-decision` — interactive ADR creation
- `/add-skill` — interactive skill guide creation
- `/add-command` — custom command creation

### Template Structure
```
.context/
  CONTEXT.md          # Go microservice context (service map, API contracts, events)
  decisions/          # ADRs
  services/           # Inter-service registry
  prds/               # Product Requirements Documents (replaces PRPs)
  bugs/
  discoveries/

.claude/
  commands/           # 13 slash commands
  agents/             # 12 agent prompts
  skills/
    go-patterns/      # Go-specific patterns
    service-communication/  # Inter-service call patterns
    bug-reproduction/
    batch-operations/
    git-platform/
  scripts/
    statusline.sh
```

### MCP Servers
- **Context7** — up-to-date library docs
- **Notion** — tasks and docs via Notion API (`NOTION_API_KEY` required)

### Key differences from dotcontext
- Microservices architecture focus (service registry, inter-service docs)
- Go-first (imports, error handling, context propagation in all templates and agents)
- PRDs (Product Requirements Documents) with service impact analysis
- `/map-services` command for dependency mapping
- `go-patterns` and `service-communication` skills
- Notion MCP instead of Atlassian
- `deep-context` step 2 maps service dependencies instead of generic subsystems

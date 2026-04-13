<p align="center">
  <img src="assets/izicontext.png" alt="izicontext logo" width="150">
</p>

<h1 align="center">izicontext</h1>
<p align="center">
  <a href="https://github.com/Helano77/izicontext/releases/latest"><img src="https://img.shields.io/github/v/release/Helano77/izicontext" alt="Release"></a>
  <a href="https://github.com/Helano77/izicontext/blob/main/LICENSE"><img src="https://img.shields.io/github/license/Helano77/izicontext" alt="License"></a>
</p>

AI context toolkit for Go microservices. Bootstraps a structured `.context/` and `.claude/` hierarchy with commands, agents, and skills that make Claude Code effective on real Go services.

---

## What it does

`izicontext init` sets up two things in your repository:

1. **`.context/`** — Human-readable documentation: architectural decisions (ADRs), inter-service maps, feature PRDs, bug reports, domain glossaries.
2. **`.claude/`** — Claude Code commands, multi-agent workflows, and skill guides tuned for Go microservices.

After init, commands like `/setup-context`, `/generate-prd`, `/fix-bug`, and `/code-review` are available directly inside Claude Code.

---

## Requirements

- Bash 3.2+
- `curl` or `wget`
- [Claude Code](https://claude.ai/code) CLI
- Go toolchain (for the projects you manage, not for izicontext itself)

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/Helano77/izicontext/main/izicontext \
  -o /usr/local/bin/izicontext && chmod +x /usr/local/bin/izicontext
```

Verify:

```bash
izicontext --version
```

---

## Quick start

```bash
cd your-go-service
izicontext init --name payment-service
```

This will:
- Create `.context/` directories for decisions, services, PRDs, discoveries, and bugs
- Download 13 Claude Code commands, 12 agents, 5 skill guides, and 3 hook scripts to `.claude/`
- Optionally configure MCP servers (Context7 for library docs, Notion for tasks)
- Prompt to run `/setup-context` automatically

Then in Claude Code:

```
/setup-context
```

Claude will analyze your codebase and populate `CLAUDE.md` and `.context/CONTEXT.md` with your service identity, stack, conventions, and API contracts.

---

## CLI reference

### `izicontext init`

Initialize the context structure in the current directory.

```
izicontext init [OPTIONS]
```

| Option | Description |
|---|---|
| `--name, -n <name>` | Service name (defaults to directory name) |
| `--yes, -y` | Skip all prompts, use defaults |
| `--no-setup` | Skip automatic `/setup-context` invocation |

### `izicontext update`

Update the CLI executable and/or managed templates.

```
izicontext update [OPTIONS]
```

| Option | Description |
|---|---|
| `--cli` | Update only the CLI executable |
| `--templates` | Update only managed templates |
| `--yes, -y` | Update without confirmation prompts |
| `--dry-run` | Show what would change without applying |

Seed files (user-owned: `CLAUDE.md`, `CONTEXT.md`, skills, PRD templates) are never overwritten. Managed files (commands, agents, scripts) are always synced to the latest version.

### `izicontext doctor`

Check project health and configuration.

```
izicontext doctor
```

Validates: Git config, Claude CLI, Go toolchain, `.context/` structure, `CLAUDE.md` placeholders, MCP server config, hook scripts, ADR count, command/agent/skill counts.

### `izicontext completion`

Generate shell tab completions.

```
izicontext completion bash
izicontext completion zsh
```

---

## Claude Code commands

After `izicontext init`, these commands are available in Claude Code as `/command-name`.

### Context & documentation

| Command | Description |
|---|---|
| `/setup-context` | Analyze the codebase and populate `CLAUDE.md`, `CONTEXT.md`, API contracts, and Go conventions |
| `/map-services` | Discover and document inter-service dependencies; updates `.context/services/` and the Service Map in `CONTEXT.md` |
| `/deep-context [query]` | 4-step structured exploration (overview → services → drill → data flow); saves to `.context/discoveries/` |
| `/add-decision [title]` | Interactively create a numbered ADR in `.context/decisions/` |

### Feature development

| Command | Description |
|---|---|
| `/generate-prd [description]` | Plan a feature: 10 clarifying questions → current state analysis → PRD with service impact, API changes, events, data model changes |
| `/execute-prd [prd-name]` | Implement a PRD: checks ADR conflicts, implements in phases, validates each phase, runs test suite |

### Code quality

| Command | Description |
|---|---|
| `/code-review [--comment]` | 4-agent parallel review: CLAUDE.md compliance, Go bugs, security, Go patterns. Optionally posts as PR comment |
| `/fix-bug [description]` | Test-driven bug fix: investigator identifies root cause and writes failing test → 3 parallel fix strategies → reviewer selects best |

### Git workflow

| Command | Description |
|---|---|
| `/commit [--amend]` | Generate style-aware commit messages (Conventional Commits, free-form, or Jira-prefixed) based on git log history |
| `/create-pr` | Create PRs with auto-detected architectural changes and Mermaid diagrams (sequence, flowchart, ER) |

### Customization

| Command | Description |
|---|---|
| `/add-skill` | Create a reusable skill guide in `.claude/skills/` |
| `/add-command` | Scaffold a new Claude Code command template |

---

## Agents

Multi-agent workflows are orchestrated by the commands above. The following agents run in parallel or sequentially as subprocesses:

| Agent | Used by |
|---|---|
| `gather-context` | Most commands (pre-flight context loading) |
| `compliance-checker` | `/code-review` |
| `bug-detector` | `/code-review` |
| `security-analyst` | `/code-review` |
| `step1-overview`, `step2-services` | `/deep-context` (parallel) |
| `step3-drill`, `step4-dataflow` | `/deep-context` (sequential) |
| `investigator` | `/fix-bug` |
| `fix-conservative`, `fix-minimal`, `fix-refactor` | `/fix-bug` (parallel) |
| `reviewer` | `/fix-bug` |

---

## Directory structure

After `izicontext init`:

```
your-service/
├── CLAUDE.md                          # Service identity, stack, commands, Go conventions
├── .claudeignore
├── .mcp.json                          # MCP server configuration
├── .context/
│   ├── CONTEXT.md                     # Domain docs, service map, API contracts, glossary
│   ├── decisions/                     # Architectural Decision Records (ADRs)
│   │   └── README.md
│   ├── services/                      # Inter-service documentation
│   │   └── README.md
│   ├── prds/
│   │   ├── templates/feature.md       # PRD template
│   │   └── generated/                 # Generated PRDs (YYYYMMDD-slug.md)
│   ├── discoveries/                   # Deep context outputs
│   └── bugs/                          # Bug investigation reports
└── .claude/
    ├── commands/                      # 13 Claude Code command templates
    ├── agents/                        # 12 agent templates
    │   ├── gather-context/
    │   ├── code-review/
    │   ├── deep-context/
    │   └── fix-bug/
    ├── skills/                        # 5 skill guides
    │   ├── go-patterns/
    │   ├── service-communication/
    │   ├── bug-reproduction/
    │   ├── batch-operations/
    │   └── git-platform/
    └── scripts/                       # Hook scripts
        ├── statusline.sh
        ├── notify.sh
        └── tool-failure-guard.sh
```

---

## MCP servers

During init you can configure:

- **Context7** — real-time library documentation via `npx @upstash/context7-mcp`
- **Notion** — tasks and docs via `npx @notionhq/notion-mcp-server` (requires `NOTION_API_KEY`)

Both are written to `.mcp.json`. Skip with `--yes` to configure later.

---

## Seed files vs managed files

izicontext distinguishes between two categories of files:

**Seed files** are created once and owned by you. `izicontext update` never overwrites them:
- `CLAUDE.md`, `.context/CONTEXT.md`
- ADR and service doc templates
- PRD feature template
- Skill guides

**Managed files** are always synced to the latest release:
- All 13 commands in `.claude/commands/`
- All 12 agents in `.claude/agents/`
- Hook scripts in `.claude/scripts/`

---

## Building from source

```bash
git clone https://github.com/Helano77/izicontext
cd izicontext
make build
./izicontext --help
```

`make build` concatenates the 14 modules in `src/` into a single executable. No compiler or runtime required.

---

## Typical workflow

```bash
# 1. Initialize
izicontext init --name payment-service

# 2. Populate context (in Claude Code)
/setup-context

# 3. Map dependencies (in Claude Code)
/map-services

# 4. Plan a feature (in Claude Code)
/generate-prd "add webhook delivery with retry logic"

# 5. Implement (in Claude Code)
/execute-prd 20260412-webhook-delivery

# 6. Review and ship (in Claude Code)
/code-review --comment
/commit
/create-pr
```

---

## License

MIT

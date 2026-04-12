# izicontext

## Decision Compliance
Before implementing any change, check `.context/decisions/` for related ADRs.

## Stack
- Bash 3.2+ (POSIX-compatible, no bashisms)
- Single executable distribution
- No external runtime dependencies

## Commands
- **Build:** `make build`
- **Clean:** `make clean`
- **Test locally:** `./izicontext --help`, `./izicontext init --no-setup`

## Critical Rules
1. Always ask before assuming
2. POSIX compatibility — Bash 3.2+ only (`[[ ]]` is ok, no `local -A` associative arrays in older bash)
3. Safe defaults — never overwrite user content without explicit confirmation
4. Validate downloads — check shebang before installing
5. Cross-platform — macOS, Linux, Windows/WSL
6. All template references must use `${BASE_URL}` — never hardcode paths

## Architecture
### Single Executable Pattern
`src/` contains 14 modular files. `make build` concatenates them into `izicontext`.
Distribution: single `izicontext` bash script.

### Template-Based Init
Templates in `templates/` are downloaded during `izicontext init`.
Two categories:
- **Seed files**: created once, owned by user (CLAUDE.md, CONTEXT.md, skills, PRD templates)
- **Managed files**: always updated (commands, agents, scripts)

### Key differences from dotcontext
- **Microservices-focused**: service registry (`.context/services/`), inter-service docs
- **Go-first**: Go conventions, import patterns, context propagation in all templates
- **PRD instead of PRP**: Product Requirements Documents with service impact analysis
- **Notion MCP** instead of Atlassian
- **New commands**: `/generate-prd`, `/execute-prd`, `/map-services`
- **New skills**: `go-patterns`, `service-communication`
- **deep-context step2**: services agent (maps dependencies) instead of generic subsystems

## Source File Order (Makefile)
```
src/header.sh → src/core/{colors,icons,ui,spinner,utils}.sh →
src/setup/{notifications,mcp}.sh →
src/commands/{init,update,doctor,help,completion}.sh →
src/main.sh
```

# /create-pr

Create a well-structured pull request. Auto-detects architectural changes and generates Mermaid diagrams when relevant.

---

## Step 1 — Analyze commits

Run:
- `git log main...HEAD --oneline`
- `git diff main...HEAD --stat`
- `git diff main...HEAD`

---

## Step 2 — Load context

Read `CLAUDE.md`, `.context/CONTEXT.md`.

Check for PR template: `.github/PULL_REQUEST_TEMPLATE.md`.

---

## Step 3 — Detect architectural changes

Look for signals in the diff:
- New files in `internal/handler/` or `internal/transport/` → new endpoint → sequence diagram
- New files in `internal/events/` or `internal/consumers/` → event flow → sequence diagram
- New files in `internal/clients/` → new service dependency → flowchart
- Changes to database schema or migrations → ER diagram
- Changes to `cmd/*/main.go` wiring → component diagram

---

## Step 4 — Generate PR

Use `gh pr create` with:
- **Title**: short, imperative, matches commit style
- **Body**: summary bullets + test plan + Mermaid diagram (if architectural change detected)

Push branch first if not on remote: ask user to confirm before `git push -u origin HEAD`.

If `.github/PULL_REQUEST_TEMPLATE.md` exists, fill its sections instead of generating free-form.

---

## Step 5 — Report

Print the PR URL.

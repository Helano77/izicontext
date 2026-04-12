# /commit [--amend]

Smart commit with style-aware message generation for Go services.

---

## Step 1 — Check staged changes

Run `git status` and `git diff --cached`.

If nothing staged: run `git diff` to see unstaged changes, then ask via `AskUserQuestion` (multiSelect) which files to stage.

---

## Step 2 — Detect commit style

Run `git log --oneline -10`.

Detect:
- **Conventional commits** (feat:, fix:, chore:, etc.)
- **Free-form** (plain sentences)
- **Jira-prefixed** (PROJ-123: ...)

---

## Step 3 — Generate commit message

Analyze the staged diff. Generate a message matching detected style.

For Go changes, be specific:
- Don't write "update handler" — write "add POST /v1/orders handler with validation"
- Don't write "fix bug" — write "fix nil pointer in OrderService.Create when items is empty"
- For refactors: mention what changed structurally

---

## Step 4 — Confirm

Show the proposed message. Ask via `AskUserQuestion`:
> "Commit with this message?"
> Options: Yes / Edit / Cancel

If Edit: ask for the revised message.

---

## Step 5 — Commit

Run `git commit -m "..."` (or `git commit --amend` if `--amend` flag).

Report the commit hash.

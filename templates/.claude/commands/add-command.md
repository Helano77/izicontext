# /add-command [name]

Create a custom Claude Code slash command for this service.

---

## Step 1 — Ask about the command

Ask via `AskUserQuestion`:
> "Tell me about this command:"
> 1. What should `/[name]` do?
> 2. What inputs or flags does it need?
> 3. What files or context should it always read first?
> 4. What's the expected output?

---

## Step 2 — Create command file

Create `.claude/commands/[name].md` with:
- Clear description
- Steps to execute
- Context files to load
- Output format

---

## Step 3 — Confirm

Report: "Created `/[name]` — available immediately in Claude Code."

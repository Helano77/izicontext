# /add-skill [name]

Create and populate a skill guide for a recurring pattern in this service.

---

## Step 1 — Ask about the skill

Ask via `AskUserQuestion`:
> "Tell me about this skill:"
> 1. What recurring task or pattern does this cover?
> 2. When should someone use this guide?
> 3. What are the most common mistakes or anti-patterns to avoid?

---

## Step 2 — Analyze codebase for examples

Search the codebase for real examples of this pattern.
Find 2–3 concrete code examples with `file:line` references.

---

## Step 3 — Create skill

Create `.claude/skills/[slug]/SKILL.md` with:
- **Purpose**: what this skill is for
- **When to use**: trigger conditions
- **Step-by-step guide**: concrete steps
- **Real examples**: from this codebase with `file:line`
- **Anti-patterns**: what NOT to do and why

---

## Step 4 — Confirm

Report the file path.

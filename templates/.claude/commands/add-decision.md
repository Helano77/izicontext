# /add-decision [title]

Interactively create and populate an Architecture Decision Record (ADR).

---

## Step 1 — Gather context

Ask via `AskUserQuestion`:
> "Tell me about this decision:"
> 1. What was decided? (one sentence)
> 2. What problem or situation prompted it?
> 3. What alternatives were considered?
> 4. What are the main trade-offs or consequences?
> 5. Who was involved in the decision?

---

## Step 2 — Check for conflicts

Read `.context/decisions/` — does this decision supersede or relate to an existing ADR?

---

## Step 3 — Create the ADR

Determine next number (count existing `NNN-*.md` files + 1).

Create `.context/decisions/NNN-[slug].md` using the template in `decisions/README.md`.

Fill all sections with the gathered information.

If superseding an existing ADR:
- Set status to `Superseded by ADR-NNN` in the old file
- Add `Supersedes ADR-NNN` in the new file's Context section

---

## Step 4 — Confirm

Show the created ADR. Report the file path.

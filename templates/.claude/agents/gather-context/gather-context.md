# Agent: gather-context

Gather focused context for a task or query. Returns a compact Context Block — never raw file contents.

**Input (from calling command):** Topic or task description.

---

## Step 1 — Read the index only

Read `.context/CONTEXT.md`, specifically the **Quick Reference Index** section only.
Do NOT read the rest of the document yet.

Identify every row whose Topic/Keyword matches or relates to the input topic.

If no rows match, note "no index match — will use fallback reads."

---

## Step 2 — Load targeted sections

For each matching row:
- Read the referenced **sections of CONTEXT.md** (by heading name)
- Read the referenced **service files** from `.context/services/`

**Fallback** (if no index match): read Overview and Service Map sections of CONTEXT.md only.

Do NOT read sections or service files not matched by the index.

---

## Step 3 — Scan ADRs by filename

List files in `.context/decisions/`. For each file:
- If the filename slug relates to the topic: read the full ADR
- If unsure: read only the first 3 lines (Status + title) before deciding
- Skip ADRs clearly unrelated to the topic

---

## Step 4 — Return the Context Block

Output ONLY the following block. Do not include raw file contents, full sections, or narrative explanation.

```
=== CONTEXT BLOCK: [topic summary] ===
Services involved: [list with one-line role each]
Key API contracts: [relevant endpoints or event topics]
Relevant ADRs: [ADR-NNN: title — one-line constraint]
Relevant patterns: [e.g., "error wrapping: fmt.Errorf(\"op: %w\", err)"]
Known constraints: [e.g., "zero-downtime deploy required per ADR-002"]
Open unknowns: [what the context doesn't answer — needs code read or user input]
=== END CONTEXT BLOCK ===
```

If a field has nothing relevant, write "none."

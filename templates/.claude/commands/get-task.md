# /get-task [TASK-ID]

Search and display a task from the Facio "Pagamentos" Notion board by task ID (e.g. FICA-2205).

---

## Step 1 — Search for the task

Use `mcp__notion__notion-search` with the task ID as the query and `filters: {}`.

---

## Step 2 — Identify the exact match

From the results, pick the entry whose title or highlight contains the exact task ID provided.

If no exact match is found, list the closest results and ask the user to clarify.

---

## Step 3 — Fetch the full page

Use `mcp__notion__notion-fetch` with the matched result's `id` to load the full page content.

---

## Step 4 — Display structured summary

Present the following fields:

- **Title** — stripped of the task ID suffix
- **Task ID** — `userDefined:ID` property
- **Board** — from ancestor-path (e.g. "Pagamentos → Kanban")
- **Status** — `Status` property
- **Assigned to** — `Assign` property, resolve user name if possible
- **Started at / Deadline** — date properties, if present
- **Description / Goal** — first paragraph of page content
- **Checklist** — all checklist items with their checked state (`[x]` / `[ ]`)
- **Code snippets** — if any, rendered as fenced code blocks
- **Linked stories** — `👤 Stories` property URLs, if present

---

## Notes

- Do not display raw formula results (`formulaResult://...`) — skip those properties.
- Keep the output compact and readable.
- Board: "Pagamentos" (ancestor-4-page)
- Tasks data-source: `collection://0feaad0f-7eab-4c32-a3eb-c8e321dda1e7`
- Task IDs follow the pattern `FICA-NNNN`

# /pr-comment [PR] [message]

Add a comment to a pull request. Auto-detects PR from current branch if not specified.

---

## Step 1 — Resolve PR

If PR number provided: use it.
Otherwise: `gh pr view --json number` from current branch.

---

## Step 2 — Determine comment type

If no message provided, ask via `AskUserQuestion`:
> "What type of comment?"
> Options:
> - General comment
> - Review comment (formal review)
> - Architecture diagram explanation
> - Status update

---

## Step 3 — Compose and post

For architecture diagrams: generate a Mermaid diagram based on the diff (`gh pr diff [N]`).

Post via:
- General: `gh pr comment [N] --body "..."`
- Review: `gh pr review [N] --comment --body "..."`

Report the comment URL.

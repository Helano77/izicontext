# Skill: Git Platform Detection

How to detect the git platform and use the right CLI commands.

---

## Auto-detect platform

```bash
remote_url=$(git remote get-url origin 2>/dev/null || echo "")

if echo "$remote_url" | grep -q "github.com"; then
    platform="github"
elif echo "$remote_url" | grep -q "gitlab.com\|gitlab\."; then
    platform="gitlab"
elif echo "$remote_url" | grep -q "dev.azure.com\|visualstudio.com"; then
    platform="azure"
elif echo "$remote_url" | grep -q "bitbucket.org"; then
    platform="bitbucket"
else
    platform="unknown"
fi
```

---

## GitHub (`gh` CLI)

```bash
# Create PR
gh pr create --title "..." --body "..."

# View PR
gh pr view [number]

# Comment on PR
gh pr comment [number] --body "..."

# View issue
gh issue view [number]
```

---

## GitLab (`glab` CLI)

```bash
# Create MR
glab mr create --title "..." --description "..."

# View MR
glab mr view [number]

# Comment
glab mr note [number] --message "..."
```

---

## Fallback

If no CLI available, use `git` commands and provide the web URL for manual action:

```bash
git push -u origin HEAD
echo "Open PR at: $(git remote get-url origin | sed 's/.git$//')/compare/$(git branch --show-current)"
```

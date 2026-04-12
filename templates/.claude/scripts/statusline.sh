#!/bin/bash
# izicontext StatusLine for Claude Code
# Shows: model | context% | git branch | context health

# Git branch + changes
git_info() {
  if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    local branch
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    local changes
    changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$changes" -gt 0 ]; then
      echo "${branch} +${changes}"
    else
      echo "${branch}"
    fi
  fi
}

# Context health
context_health() {
  local parts=()

  # ADRs
  if [ -d ".context/decisions" ]; then
    local adr_count
    adr_count=$(find .context/decisions -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    [ "$adr_count" -gt 0 ] && parts+=("${adr_count}adr")
  fi

  # Services
  if [ -d ".context/services" ]; then
    local svc_count
    svc_count=$(find .context/services -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    [ "$svc_count" -gt 0 ] && parts+=("${svc_count}svc")
  fi

  # PRDs in progress
  if [ -d ".context/prds/generated" ]; then
    local prd_count
    prd_count=$(find .context/prds/generated -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    [ "$prd_count" -gt 0 ] && parts+=("${prd_count}prd")
  fi

  # Bugs
  if [ -d ".context/bugs" ]; then
    local bug_count
    bug_count=$(find .context/bugs -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    [ "$bug_count" -gt 0 ] && parts+=("${bug_count}bug")
  fi

  if [ ${#parts[@]} -gt 0 ]; then
    echo ".ctx:$(IFS=/ ; echo "${parts[*]}")"
  fi
}

# Build statusline
parts=()

git_part=$(git_info)
[ -n "$git_part" ] && parts+=("$git_part")

ctx_part=$(context_health)
[ -n "$ctx_part" ] && parts+=("$ctx_part")

if [ ${#parts[@]} -gt 0 ]; then
  (IFS=' | '; echo "${parts[*]}")
fi

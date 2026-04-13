# ── Command: doctor ───────────────────────────────────────────────────────────

cmd_doctor() {
  print_block_header "izicontext doctor"
  echo ""

  local pass=0
  local fail=0
  local warn=0

  check_pass() { printf "  ${GREEN}${ICON_SUCCESS}${NC} %s\n" "$1"; pass=$((pass + 1)); }
  check_fail() { printf "  ${RED}${ICON_ERROR}${NC} %s\n" "$1";  fail=$((fail + 1)); }
  check_warn() { printf "  ${YELLOW}${ICON_WARNING}${NC} %s\n" "$1"; warn=$((warn + 1)); }

  # Git repository
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    check_pass "Git repository"
  else
    check_fail "Git repository — not a git repo"
  fi

  # Claude CLI
  if command -v claude &>/dev/null; then
    local claude_ver
    claude_ver=$(claude --version 2>/dev/null || echo "unknown")
    check_pass "Claude CLI installed ($claude_ver)"
  else
    check_fail "Claude CLI — not installed"
  fi

  # Go toolchain
  if command -v go &>/dev/null; then
    local go_ver
    go_ver=$(go version 2>/dev/null | awk '{print $3}')
    check_pass "Go toolchain ($go_ver)"
    if [ -f "go.mod" ]; then
      local module
      module=$(head -1 go.mod | awk '{print $2}')
      check_pass "go.mod found (module: $module)"
    else
      check_warn "go.mod — not found (is this a Go service?)"
    fi
  else
    check_warn "Go toolchain — not installed (expected for Go microservices)"
  fi

  # .context/ directory
  if [ -d ".context" ]; then
    check_pass ".context/ directory exists"
  else
    check_fail ".context/ directory — missing (run izicontext init)"
  fi

  # CLAUDE.md
  if [ -s "CLAUDE.md" ]; then
    if grep -q "{{projectName}}" "CLAUDE.md" 2>/dev/null; then
      check_warn "CLAUDE.md — exists but has unfilled placeholders"
    else
      check_pass "CLAUDE.md populated"
    fi
  elif [ -f "CLAUDE.md" ]; then
    check_warn "CLAUDE.md — exists but empty"
  else
    check_fail "CLAUDE.md — missing"
  fi

  # CONTEXT.md
  if [ -s ".context/CONTEXT.md" ]; then
    check_pass ".context/CONTEXT.md populated"
  elif [ -f ".context/CONTEXT.md" ]; then
    check_warn ".context/CONTEXT.md — exists but empty"
  else
    check_fail ".context/CONTEXT.md — missing"
  fi

  # services directory
  if [ -d ".context/services" ]; then
    local svc_count
    svc_count=$(find .context/services -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$svc_count" -gt 0 ]; then
      check_pass ".context/services/ — $svc_count service doc(s)"
    else
      check_warn ".context/services/ — no service docs (run /map-services)"
    fi
  else
    check_warn ".context/services/ — missing (run izicontext init)"
  fi

  # decisions
  local adr_count=0
  if [ -d ".context/decisions" ]; then
    adr_count=$(find .context/decisions -name "*.md" ! -name "README.md" 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$adr_count" -gt 0 ]; then
    check_pass ".context/decisions/ — $adr_count ADR(s)"
  else
    check_warn ".context/decisions/ — no ADRs found"
  fi

  # commands
  local cmd_count=0
  if [ -d ".claude/commands" ]; then
    cmd_count=$(find .claude/commands -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$cmd_count" -gt 0 ]; then
    check_pass ".claude/commands/ — $cmd_count command(s)"
  else
    check_fail ".claude/commands/ — no commands found"
  fi

  # agents
  local agent_count=0
  if [ -d ".claude/agents" ]; then
    agent_count=$(find .claude/agents -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
  fi
  if [ "$agent_count" -gt 0 ]; then
    check_pass ".claude/agents/ — $agent_count agent(s)"
  else
    check_warn ".claude/agents/ — no agents found (run izicontext update)"
  fi

  # skills
  if [ -d ".claude/skills" ]; then
    local skill_count
    skill_count=$(find .claude/skills -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$skill_count" -gt 0 ]; then
      check_pass ".claude/skills/ — $skill_count skill(s)"
    else
      check_warn ".claude/skills/ — directory exists but no skills"
    fi
  else
    check_warn ".claude/skills/ — missing"
  fi

  # .mcp.json
  if [ -f ".mcp.json" ]; then
    if command -v jq &>/dev/null; then
      local server_count
      server_count=$(jq '.mcpServers | length' .mcp.json 2>/dev/null || echo "0")
      check_pass ".mcp.json — $server_count MCP server(s)"
      if jq -e '.mcpServers.notion' .mcp.json &>/dev/null; then
        check_pass "Notion MCP — configured (authenticate via browser on first use)"
      else
        check_warn "Notion MCP — not configured (tasks + docs integration missing)"
      fi
    else
      check_pass ".mcp.json exists"
    fi
  else
    check_warn ".mcp.json — missing (no MCP servers configured)"
  fi

  # hooks
  if [ -f ".claude/settings.json" ]; then
    if grep -q "notify.sh" ".claude/settings.json" 2>/dev/null; then
      check_pass "Notification hooks configured (project-local)"
    else
      check_warn "Notification hooks — not configured in .claude/settings.json"
    fi
    if grep -q "tool-failure-guard" ".claude/settings.json" 2>/dev/null; then
      check_pass "Tool failure guard hook configured"
    else
      check_warn "Tool failure guard — not configured"
    fi
  else
    check_warn ".claude/settings.json — missing (no hooks configured)"
  fi

  print_block_footer
  printf "  ${GREEN}%d passed${NC}  ${RED}%d failed${NC}  ${YELLOW}%d warnings${NC}\n" "$pass" "$fail" "$warn"

  if [ "$fail" -gt 0 ]; then
    echo ""
    print_gray "  Fix failures with: izicontext init"
    return 1
  fi
}

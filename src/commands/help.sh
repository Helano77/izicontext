# ── Command: help ─────────────────────────────────────────────────────────────

cmd_help() {
  local width
  width=$(get_term_width)

  local cmd_col=22
  local opt_col=24
  if [ "$width" -ge 100 ]; then
    cmd_col=26
    opt_col=28
  fi

  echo ""
  printf "  ${BOLD}izicontext${NC} ${GRAY}— AI context toolkit for microservices (Go-first)${NC}\n"
  echo ""

  printf "  ${BLUE}${BOLD}Usage${NC}\n"
  printf "    izicontext <command> [options]\n"
  echo ""

  printf "  ${BLUE}${BOLD}Commands${NC}\n"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "init"       "Initialize .context structure + open Claude Code"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "update"     "Update CLI and/or templates"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "doctor"     "Check project setup health"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "completion" "Generate shell tab completions"
  echo ""

  printf "  ${BLUE}${BOLD}Init Options${NC}\n"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--name, -n <name>" "Service name"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--yes, -y"         "Skip prompts, use defaults"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--no-setup"        "Skip automatic /setup-context"
  echo ""

  printf "  ${BLUE}${BOLD}Update Options${NC}\n"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--cli"       "Only update CLI"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--templates" "Only update templates"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--yes, -y"   "Update without asking"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--dry-run"   "Show what would change"
  echo ""

  printf "  ${BLUE}${BOLD}Global Options${NC}\n"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--help, -h"    "Show this help"
  printf "    ${YELLOW}%-${opt_col}s${NC}%s\n" "--version, -v" "Show version"
  echo ""

  printf "  ${BLUE}${BOLD}Claude Code Commands${NC} ${GRAY}(after init)${NC}\n"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/setup-context"  "Analyze service and populate context"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/generate-prd"   "Plan a new feature (PRD)"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/execute-prd"    "Implement a planned feature"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/map-services"   "Map inter-service dependencies"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/code-review"    "Multi-agent code review (Go-aware)"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/commit"         "Smart commit messages"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/create-pr"      "Create PR with description"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/deep-context"   "Structured service exploration"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/fix-bug"        "Test-driven bug fixing"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/add-decision"   "Add architectural decision"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/add-skill"      "Add skill guide"
  printf "    ${CYAN}%-${cmd_col}s${NC}%s\n" "/add-command"    "Create custom command"
  echo ""

  printf "  ${BLUE}${BOLD}Examples${NC}\n"
  printf "    ${GRAY}\$${NC} izicontext init\n"
  printf "    ${GRAY}\$${NC} izicontext init --name \"payment-service\"\n"
  printf "    ${GRAY}\$${NC} izicontext update --dry-run\n"
  printf "    ${GRAY}\$${NC} izicontext doctor\n"
  printf "    ${GRAY}\$${NC} eval \"\$(izicontext completion bash)\"\n"
  echo ""
}

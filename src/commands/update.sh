# ── Command: update ───────────────────────────────────────────────────────────

cmd_update() {
  local templates_only=false
  local cli_only=false
  local auto_yes=false
  local dry_run=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --templates) templates_only=true; shift ;;
      --cli) cli_only=true; shift ;;
      --yes|-y) auto_yes=true; shift ;;
      --dry-run) dry_run=true; shift ;;
      *) shift ;;
    esac
  done

  if [ "$templates_only" = true ]; then
    cmd_update_templates "$auto_yes" "$dry_run"
  elif [ "$cli_only" = true ]; then
    cmd_update_cli
  else
    cmd_update_cli
    if [ -d ".context" ]; then
      echo ""
      local new_bin
      new_bin=$(command -v izicontext 2>/dev/null || echo "")
      if [ -n "$new_bin" ] && [ -x "$new_bin" ]; then
        local new_ver
        new_ver=$("$new_bin" --version 2>/dev/null | sed 's/izicontext //')
        if [ "$new_ver" != "$VERSION" ]; then
          local args="update --templates"
          [ "$auto_yes" = "true" ] && args="$args --yes"
          [ "$dry_run" = "true" ] && args="$args --dry-run"
          exec "$new_bin" $args
        fi
      fi
      cmd_update_templates "$auto_yes" "$dry_run"
    fi
  fi
}

cmd_update_cli() {
  start_spinner "Checking for CLI updates..."

  local latest_version latest_tag api_response

  if command -v curl &> /dev/null; then
    api_response=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null)
    latest_tag=$(echo "$api_response" | grep '"tag_name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
    latest_version=$(echo "$latest_tag" | sed 's/^v//')
    if [ -z "$latest_version" ]; then
      api_response=$(curl -fsSL "https://api.github.com/repos/${REPO}/tags" 2>/dev/null)
      latest_tag=$(echo "$api_response" | grep '"name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
      latest_version=$(echo "$latest_tag" | sed 's/^v//')
    fi
  else
    api_response=$(wget -qO- "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null)
    latest_tag=$(echo "$api_response" | grep '"tag_name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
    latest_version=$(echo "$latest_tag" | sed 's/^v//')
    if [ -z "$latest_version" ]; then
      api_response=$(wget -qO- "https://api.github.com/repos/${REPO}/tags" 2>/dev/null)
      latest_tag=$(echo "$api_response" | grep '"name"' | head -1 | sed -E 's/.*"([^"]+)".*/\1/')
      latest_version=$(echo "$latest_tag" | sed 's/^v//')
    fi
  fi

  if [ -z "$latest_version" ]; then
    stop_spinner
    print_red "Could not check latest version."
    return 1
  fi

  if [ "$VERSION" = "$latest_version" ]; then
    stop_spinner "$(printf "${GREEN}${ICON_SUCCESS} CLI already at latest version ($VERSION)${NC}")"
    return 0
  fi

  stop_spinner "$(printf "${GRAY}Current: $VERSION → Latest: $latest_version${NC}")"

  local install_path=$(command -v izicontext)
  [ -z "$install_path" ] && install_path="/usr/local/bin/izicontext"

  local release_url="https://raw.githubusercontent.com/${REPO}/${latest_tag}/izicontext"
  start_spinner "Downloading from release ${latest_tag}..."

  local tmp_file=$(mktemp)
  download "$release_url" "$tmp_file"
  stop_spinner

  if [ ! -s "$tmp_file" ] || ! head -1 "$tmp_file" | grep -q "^#!/bin/bash"; then
    print_red "Error: Download failed"
    rm -f "$tmp_file"
    return 1
  fi

  chmod +x "$tmp_file"

  if [ -w "$(dirname "$install_path")" ]; then
    mv "$tmp_file" "$install_path"
  else
    print_yellow "Need sudo to update $install_path"
    sudo mv "$tmp_file" "$install_path"
    sudo chmod +x "$install_path"
  fi

  print_green "${ICON_SUCCESS} CLI updated to $latest_version"
}

cmd_update_templates() {
  local auto_yes="$1"
  local dry_run="$2"

  if [ ! -d ".context" ]; then
    print_red "No .context directory. Run \`izicontext init\` first."
    return 1
  fi

  start_spinner "Checking templates..."

  # MANAGED: always offered for update
  declare -a managed_templates=(
    "templates/.claude/commands/setup-context.md:.claude/commands/setup-context.md"
    "templates/.claude/commands/generate-prd.md:.claude/commands/generate-prd.md"
    "templates/.claude/commands/execute-prd.md:.claude/commands/execute-prd.md"
    "templates/.claude/commands/map-services.md:.claude/commands/map-services.md"
    "templates/.claude/commands/code-review.md:.claude/commands/code-review.md"
    "templates/.claude/commands/commit.md:.claude/commands/commit.md"
    "templates/.claude/commands/create-pr.md:.claude/commands/create-pr.md"
    "templates/.claude/commands/pr-comment.md:.claude/commands/pr-comment.md"
    "templates/.claude/commands/deep-context.md:.claude/commands/deep-context.md"
    "templates/.claude/commands/fix-bug.md:.claude/commands/fix-bug.md"
    "templates/.claude/commands/add-decision.md:.claude/commands/add-decision.md"
    "templates/.claude/commands/add-skill.md:.claude/commands/add-skill.md"
    "templates/.claude/commands/add-command.md:.claude/commands/add-command.md"
    "templates/.claude/scripts/statusline.sh:.claude/scripts/statusline.sh"
    "templates/.claude/agents/code-review/compliance-checker.md:.claude/agents/code-review/compliance-checker.md"
    "templates/.claude/agents/code-review/bug-detector.md:.claude/agents/code-review/bug-detector.md"
    "templates/.claude/agents/code-review/security-analyst.md:.claude/agents/code-review/security-analyst.md"
    "templates/.claude/agents/deep-context/step1-overview.md:.claude/agents/deep-context/step1-overview.md"
    "templates/.claude/agents/deep-context/step2-services.md:.claude/agents/deep-context/step2-services.md"
    "templates/.claude/agents/deep-context/step3-drill.md:.claude/agents/deep-context/step3-drill.md"
    "templates/.claude/agents/deep-context/step4-dataflow.md:.claude/agents/deep-context/step4-dataflow.md"
    "templates/.claude/agents/fix-bug/investigator.md:.claude/agents/fix-bug/investigator.md"
    "templates/.claude/agents/fix-bug/fix-conservative.md:.claude/agents/fix-bug/fix-conservative.md"
    "templates/.claude/agents/fix-bug/fix-minimal.md:.claude/agents/fix-bug/fix-minimal.md"
    "templates/.claude/agents/fix-bug/fix-refactor.md:.claude/agents/fix-bug/fix-refactor.md"
    "templates/.claude/agents/fix-bug/reviewer.md:.claude/agents/fix-bug/reviewer.md"
  )

  # SEED: create-only, never overwrite
  declare -a seed_templates=(
    "templates/.context/prds/templates/feature.md:.context/prds/templates/feature.md"
    "templates/.context/decisions/README.md:.context/decisions/README.md"
    "templates/.context/services/README.md:.context/services/README.md"
    "templates/.claude/skills/README.md:.claude/skills/README.md"
    "templates/.claude/skills/bug-reproduction/SKILL.md:.claude/skills/bug-reproduction/SKILL.md"
    "templates/.claude/skills/go-patterns/SKILL.md:.claude/skills/go-patterns/SKILL.md"
    "templates/.claude/skills/service-communication/SKILL.md:.claude/skills/service-communication/SKILL.md"
  )

  local tmp_dir=$(mktemp -d)
  trap "rm -rf $tmp_dir" EXIT

  declare -a new_files=()
  declare -a modified_files=()
  declare -a unchanged_files=()
  declare -a seed_new_files=()
  declare -a seed_skipped_files=()

  for mapping in "${managed_templates[@]}"; do
    local remote_path="${mapping%%:*}"
    local local_path="${mapping##*:}"
    local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"

    if ! download "${BASE_URL}/${remote_path}" "$tmp_file" 2>/dev/null; then
      print_red "  failed to download: $remote_path"
      continue
    fi

    if [ ! -f "$local_path" ]; then
      new_files+=("$mapping")
    elif ! diff -q "$local_path" "$tmp_file" >/dev/null 2>&1; then
      modified_files+=("$mapping")
    else
      unchanged_files+=("$mapping")
    fi
  done

  for mapping in "${seed_templates[@]}"; do
    local remote_path="${mapping%%:*}"
    local local_path="${mapping##*:}"
    local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"

    if ! download "${BASE_URL}/${remote_path}" "$tmp_file" 2>/dev/null; then
      print_red "  failed to download: $remote_path"
      continue
    fi

    if [ ! -f "$local_path" ]; then
      seed_new_files+=("$mapping")
    else
      seed_skipped_files+=("$mapping")
    fi
  done

  stop_spinner
  echo ""

  local has_changes=false

  if [ ${#new_files[@]} -gt 0 ] || [ ${#seed_new_files[@]} -gt 0 ]; then
    has_changes=true
    for mapping in "${new_files[@]}"; do
      printf "  ${GREEN}${ICON_ADD}${NC} %s ${GRAY}(new)${NC}\n" "${mapping##*:}"
    done
    for mapping in "${seed_new_files[@]}"; do
      printf "  ${GREEN}${ICON_ADD}${NC} %s ${GRAY}(new — seed template)${NC}\n" "${mapping##*:}"
    done
  fi

  if [ ${#modified_files[@]} -gt 0 ]; then
    has_changes=true
    for mapping in "${modified_files[@]}"; do
      printf "  ${YELLOW}${ICON_MODIFY}${NC} %s ${GRAY}(modified)${NC}\n" "${mapping##*:}"
    done
  fi

  for mapping in "${unchanged_files[@]}"; do
    printf "  ${GRAY}${ICON_UNCHANGED}${NC} %s ${GRAY}(unchanged)${NC}\n" "${mapping##*:}"
  done

  for mapping in "${seed_skipped_files[@]}"; do
    printf "  ${CYAN}${ICON_MANAGED}${NC} %s ${GRAY}(user-managed — skipped)${NC}\n" "${mapping##*:}"
  done

  local total_new=$((${#new_files[@]} + ${#seed_new_files[@]}))
  echo ""
  printf "Summary: ${GREEN}%d to add${NC}, ${YELLOW}%d to update${NC}, ${GRAY}%d unchanged${NC}, ${CYAN}%d user-managed${NC}\n" \
    "$total_new" "${#modified_files[@]}" "${#unchanged_files[@]}" "${#seed_skipped_files[@]}"

  if [ "$has_changes" = false ]; then
    echo ""
    print_green "${ICON_SUCCESS} All templates up to date"
    return 0
  fi

  if [ "$dry_run" = "true" ]; then
    echo ""
    print_gray "Dry run - no changes made"
    return 0
  fi

  local action="n"
  if [ "$auto_yes" = "true" ]; then
    action="y"
  elif [ ${#modified_files[@]} -gt 0 ]; then
    echo ""
    printf "Update %d existing file(s)? [y/N/d] " "${#modified_files[@]}"
    printf "${GRAY}(y=yes, N=no, d=show diffs)${NC} "
    read -r action
    action="${action:-n}"

    if [[ "$action" =~ ^[Dd] ]]; then
      echo ""
      for mapping in "${modified_files[@]}"; do
        local local_path="${mapping##*:}"
        local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"
        print_cyan "=== $local_path ==="
        diff --color=auto -u "$local_path" "$tmp_file" 2>/dev/null
        if [ $? -eq 2 ]; then diff -u "$local_path" "$tmp_file"; fi
        echo ""
      done
      printf "Update %d existing file(s)? [y/N] " "${#modified_files[@]}"
      read -r action
      action="${action:-n}"
    fi
  else
    action="y"
  fi

  local added=0 updated=0

  for mapping in "${new_files[@]}"; do
    local local_path="${mapping##*:}"
    local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"
    mkdir -p "$(dirname "$local_path")"
    cp "$tmp_file" "$local_path"
    ((added++))
  done

  for mapping in "${seed_new_files[@]}"; do
    local local_path="${mapping##*:}"
    local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"
    mkdir -p "$(dirname "$local_path")"
    cp "$tmp_file" "$local_path"
    ((added++))
  done

  if [[ "$action" =~ ^[Yy] ]]; then
    for mapping in "${modified_files[@]}"; do
      local local_path="${mapping##*:}"
      local tmp_file="$tmp_dir/$(echo "$local_path" | sed 's|/|__|g')"
      cp "$tmp_file" "$local_path"
      ((updated++))
    done
  fi

  cleanup_managed_dir ".claude/agents/code-review" \
    compliance-checker.md bug-detector.md security-analyst.md
  cleanup_managed_dir ".claude/agents/deep-context" \
    step1-overview.md step2-services.md step3-drill.md step4-dataflow.md
  cleanup_managed_dir ".claude/agents/fix-bug" \
    investigator.md fix-conservative.md fix-minimal.md fix-refactor.md reviewer.md
  cleanup_managed_dir ".claude/scripts" \
    statusline.sh

  echo ""
  [ $added -gt 0 ] && print_green "${ICON_SUCCESS} Added $added new file(s)"
  [ $updated -gt 0 ] && print_green "${ICON_SUCCESS} Updated $updated file(s)"
  [ $added -eq 0 ] && [ $updated -eq 0 ] && print_gray "No changes made"
}

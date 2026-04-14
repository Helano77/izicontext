# ── MCP Server Setup ──────────────────────────────────────────────────────────

# Setup MCP servers in .mcp.json
# izicontext uses Context7 (library docs) and Notion (tasks + docs)
setup_mcp() {
  local add_context7="$1"
  local add_notion="$2"
  local mcp_file=".mcp.json"

  if [ -f "$mcp_file" ]; then
    return 0
  fi

  local servers=""
  local comma=""

  if [ "$add_context7" = true ]; then
    servers="${servers}${comma}
    \"context7\": {
      \"command\": \"npx\",
      \"args\": [\"-y\", \"@upstash/context7-mcp\"]
    }"
    comma=","
  fi

  if [ "$add_notion" = true ]; then
    servers="${servers}${comma}
    \"notion\": {
      \"type\": \"http\",
      \"url\": \"https://mcp.notion.com/mcp\"
    }"
  fi

  if [ -n "$servers" ]; then
    cat > "$mcp_file" << EOF
{
  "mcpServers": {${servers}
  }
}
EOF
    print_gray "MCP servers configured in .mcp.json"
    if [ "$add_notion" = true ]; then
      print_yellow "Notion MCP: authenticate via browser on first use (OAuth login)"
    fi
  fi
}

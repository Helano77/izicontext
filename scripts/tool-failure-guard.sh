#!/bin/bash
# Tool Failure Guard for Claude Code
# Tracks consecutive failures and injects guidance after 4+ failures.
#
# Hook event: PostToolUseFailure
# Input: JSON via stdin
# Output: JSON with additionalContext when threshold exceeded

THRESHOLD=4

INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
ERROR=$(echo "$INPUT" | jq -r '.error // "unknown error"')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "default"')

TRACKER_FILE="/tmp/.izicontext-tool-failure-tracker-${SESSION_ID}"

if [ -f "$TRACKER_FILE" ]; then
  LAST_TOOL=$(head -1 "$TRACKER_FILE" 2>/dev/null)
  COUNT=$(tail -1 "$TRACKER_FILE" 2>/dev/null)
  if ! echo "$COUNT" | grep -qE '^[0-9]+$'; then
    COUNT=0
  fi
else
  LAST_TOOL=""
  COUNT=0
fi

if [ "$TOOL_NAME" = "$LAST_TOOL" ]; then
  COUNT=$((COUNT + 1))
else
  COUNT=1
fi

printf '%s\n%s\n' "$TOOL_NAME" "$COUNT" > "$TRACKER_FILE"

if [ "$COUNT" -ge "$THRESHOLD" ]; then
  printf '%s\n%s\n' "$TOOL_NAME" "0" > "$TRACKER_FILE"

  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  "$SCRIPT_DIR/notify.sh" "izicontext" "${TOOL_NAME} failed ${COUNT} times — needs your help" error &

  MSG="HOOK ALERT: The tool \"${TOOL_NAME}\" has failed ${COUNT} times consecutively. Last error: ${ERROR}. STOP retrying the same approach. You MUST use the AskUserQuestion tool to present the user with options to unblock this situation. Suggest 2-3 concrete alternatives based on the errors you have seen."

  jq -n --arg msg "$MSG" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUseFailure",
      additionalContext: $msg
    }
  }'
fi

exit 0

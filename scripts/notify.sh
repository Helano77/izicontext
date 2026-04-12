#!/bin/bash
# Cross-platform notification script for Claude Code

TITLE="${1:-izicontext}"
MESSAGE="${2:-Task completed}"
SOUND="${3:-default}"

detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)

get_macos_sound() {
  case "$SOUND" in
    success) echo "Funk" ;;
    error) echo "Basso" ;;
    question) echo "Purr" ;;
    *) echo "Glass" ;;
  esac
}

show_notification() {
  case "$OS" in
    macos)
      local sound_name=$(get_macos_sound)
      osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$sound_name\"" 2>/dev/null
      ;;
    linux)
      local sound_file="/usr/share/sounds/freedesktop/stereo/complete.oga"
      if [ "$SOUND" = "error" ]; then
        sound_file="/usr/share/sounds/freedesktop/stereo/dialog-error.oga"
      elif [ "$SOUND" = "question" ]; then
        sound_file="/usr/share/sounds/freedesktop/stereo/dialog-question.oga"
      fi
      if command -v paplay &>/dev/null; then
        paplay "$sound_file" 2>/dev/null &
      elif command -v aplay &>/dev/null; then
        aplay "$sound_file" 2>/dev/null &
      fi
      if command -v notify-send &>/dev/null; then
        local icon="dialog-information"
        [ "$SOUND" = "error" ] && icon="dialog-error"
        [ "$SOUND" = "question" ] && icon="dialog-question"
        notify-send -i "$icon" "$TITLE" "$MESSAGE" 2>/dev/null
      fi
      ;;
    wsl|windows)
      powershell.exe -Command "[System.Media.SystemSounds]::Asterisk.Play()" 2>/dev/null &
      powershell.exe -Command "
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
        \$template = @\"
        <toast>
          <visual>
            <binding template=\"ToastText02\">
              <text id=\"1\">$TITLE</text>
              <text id=\"2\">$MESSAGE</text>
            </binding>
          </visual>
        </toast>
\"@
        \$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        \$xml.LoadXml(\$template)
        \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('izicontext').Show(\$toast)
      " 2>/dev/null &
      ;;
  esac
}

show_notification

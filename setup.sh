#!/bin/bash
# Installs or uninstalls a self-contained launchd daemon that removes
# Microsoft AutoUpdate. No external scripts needed after install.
# Must be run as root (sudo).

set -euo pipefail

PLIST_PATH="/Library/LaunchDaemons/com.local.remove-mau.plist"
LOG_PATH="/var/log/remove-mau.log"

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root (use sudo)." >&2
  exit 1
fi

uninstall() {
  echo "Uninstalling remove-mau LaunchDaemon..."
  if launchctl list com.local.remove-mau &>/dev/null; then
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    launchctl bootout system/com.local.remove-mau 2>/dev/null || true
  fi
  rm -f "$PLIST_PATH"
  echo "Uninstalled."
}

install() {
  cat > "$PLIST_PATH" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.local.remove-mau</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-c</string>
    <string>
for f in \
  "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app" \
  "/Library/Application Support/Microsoft/MAU/Microsoft AutoUpdate.app" \
  "/Library/LaunchAgents/com.microsoft.update.agent.plist" \
  "/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist" \
  "/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper"; do
  [ -e "$f" ] &amp;&amp; rm -rf "$f" &amp;&amp; echo "Deleted: $f"
done
    </string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>/var/log/remove-mau.log</string>
  <key>StandardErrorPath</key>
  <string>/var/log/remove-mau.log</string>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF

  launchctl load "$PLIST_PATH"
  echo "Installed. Runs daily at 9:00 AM and on boot. No external scripts needed."
  echo "Logs: $LOG_PATH"
}

case "${1:-install}" in
  install)  install ;;
  uninstall) uninstall ;;
  *)
    echo "Usage: sudo $0 [install|uninstall]" >&2
    exit 1
    ;;
esac

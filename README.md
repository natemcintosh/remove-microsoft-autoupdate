# Remove Microsoft AutoUpdate

Microsoft AutoUpdate (MAU) on macOS has a habit of reinstalling itself like a self-resurrecting STD. This tool sets up a macOS LaunchDaemon that automatically removes MAU files daily and on every boot.

## What it removes

- `/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app`
- `/Library/Application Support/Microsoft/MAU/Microsoft AutoUpdate.app`
- `/Library/LaunchAgents/com.microsoft.update.agent.plist`
- `/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist`
- `/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper`

Files that don't exist are silently skipped.

The list of files comes from [this OSXDaily article](https://osxdaily.com/2019/07/20/how-delete-microsoft-autoupdate-mac/).

## Install

```sh
git clone https://github.com/natemcintosh/remove-microsoft-autoupdate.git
cd remove-microsoft-autoupdate
sudo bash setup.sh install
```

After installing, the repo folder can be safely deleted — the daemon is self-contained.

## Uninstall

```sh
sudo bash setup.sh uninstall
```

## How it works

`setup.sh` creates a LaunchDaemon at `/Library/LaunchDaemons/com.local.remove-mau.plist` with the deletion commands embedded directly in the plist. It runs daily at 9:00 AM and once on boot.

Logs are written to `/var/log/remove-mau.log`.

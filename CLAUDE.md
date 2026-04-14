# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Removes Microsoft AutoUpdate (MAU) from macOS. MAU tends to reinstall itself, so a launchd daemon runs the deletion script daily.

## Usage

- **Install scheduled job:** `sudo bash setup.sh install`
- **Uninstall scheduled job:** `sudo bash setup.sh uninstall`
- **Logs:** `/var/log/remove-mau.log`

## Architecture

- `setup.sh` — Creates a self-contained LaunchDaemon (`com.local.remove-mau`) with deletion commands embedded in the plist. Runs daily at 9 AM and on boot. Requires root. The repo can be deleted after install.
- `files_to_delete.txt` — Reference list of target paths.

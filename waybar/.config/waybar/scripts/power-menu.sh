#!/usr/bin/env bash
# Wofi power menu.

set -euo pipefail

WOFI=(wofi --dmenu --insensitive --width 240 --height 260 --prompt "power")

options="  lock
󰍃  logout
󰒲  suspend
  reboot
⏻  shutdown"

choice="$(printf '%s\n' "$options" | "${WOFI[@]}" || true)"
[[ -z "$choice" ]] && exit 0

case "$choice" in
    *lock*)     exec swaylock -f -c 000000 ;;
    *logout*)   exec swaymsg exit ;;
    *suspend*)  exec systemctl suspend ;;
    *reboot*)   exec systemctl reboot ;;
    *shutdown*) exec systemctl poweroff ;;
esac

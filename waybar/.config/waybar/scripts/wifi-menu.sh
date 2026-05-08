#!/usr/bin/env bash
# Wofi-driven NetworkManager wifi picker.
# Single click on the network module triggers this.

set -euo pipefail

WOFI_DMENU=(wofi --dmenu --insensitive --width 400 --height 400 --prompt "wifi")
WOFI_PASSWORD=(wofi --dmenu --password --width 320 --height 80 --prompt "password")

wifi_state() {
    nmcli -t -f WIFI radio | head -n1
}

toggle_label() {
    if [[ "$(wifi_state)" == "enabled" ]]; then
        echo "󰖪  disable wifi"
    else
        echo "󰖩  enable wifi"
    fi
}

list_networks() {
    nmcli --color no -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list \
        | awk -F: '
            $2 == "" { next }
            {
                mark = ($1 == "*") ? "●" : " "
                sec = ($4 == "") ? "open" : $4
                printf "%s  %-32s  %3s%%  %s\n", mark, $2, $3, sec
            }'
}

ssid_from_choice() {
    # The SSID is the second whitespace-delimited field after the mark.
    awk '{
        $1=$1
        # Reconstruct: first token is mark, then SSID may contain spaces — but
        # nmcli escapes those for us with -t. So token 2 onwards minus last 2
        # tokens (signal + security) is the SSID. Easier: trim the final two
        # columns.
        n = NF
        out = ""
        for (i = 2; i <= n - 2; i++) out = (out == "") ? $i : out " " $i
        print out
    }'
}

main() {
    if [[ "$(wifi_state)" != "enabled" ]]; then
        choice="$(toggle_label | "${WOFI_DMENU[@]}" || true)"
        [[ -z "$choice" ]] && exit 0
        nmcli radio wifi on
        # Give the radio a beat to come up, then re-launch.
        sleep 1
        exec "$0"
    fi

    nmcli device wifi rescan >/dev/null 2>&1 || true

    menu="$(toggle_label)
$(list_networks)"

    choice="$(printf '%s\n' "$menu" | "${WOFI_DMENU[@]}" || true)"
    [[ -z "$choice" ]] && exit 0

    case "$choice" in
        *"disable wifi"*)
            nmcli radio wifi off
            exit 0
            ;;
        *"enable wifi"*)
            nmcli radio wifi on
            exit 0
            ;;
    esac

    ssid="$(printf '%s' "$choice" | ssid_from_choice)"
    [[ -z "$ssid" ]] && exit 0

    # Already-known connection? Just bring it up.
    if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
        nmcli connection up "$ssid" >/dev/null 2>&1 \
            || notify-send "wifi" "failed to connect to $ssid"
        exit 0
    fi

    # Open network — no password.
    if [[ "$choice" == *"open"* ]]; then
        nmcli device wifi connect "$ssid" >/dev/null 2>&1 \
            || notify-send "wifi" "failed to connect to $ssid"
        exit 0
    fi

    password="$("${WOFI_PASSWORD[@]}" </dev/null || true)"
    [[ -z "$password" ]] && exit 0

    if nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1; then
        notify-send "wifi" "connected to $ssid"
    else
        notify-send "wifi" "failed to connect to $ssid"
    fi
}

main "$@"

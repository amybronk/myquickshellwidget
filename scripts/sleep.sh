#!/bin/bash

INIT=$(cat "$HOME/.config/quickshell/init-system" 2>/dev/null || echo "sysvinit")

case "$INIT" in
    loginctl)
        loginctl suspend
        ;;
    *)
        if command -v zzz &>/dev/null; then
            zzz
        elif command -v pm-suspend &>/dev/null; then
            pm-suspend
        else
            sudo sh -c "echo mem > /sys/power/state"
        fi
        ;;
esac
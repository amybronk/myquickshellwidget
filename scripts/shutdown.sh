#!/bin/bash

TIJD="${1:-now}"
INIT=$(cat "$HOME/.config/quickshell/init-system" 2>/dev/null || echo "sysvinit")

bash "$HOME/.config/quickshell/scripts/shutdown-notification.sh" "$TIJD"

case "$INIT" in
    loginctl)
        if [ "$TIJD" = "now" ]; then
            loginctl poweroff
        else
            sleep $(( TIJD * 60 )) && loginctl poweroff &
        fi
        ;;
    *)
        if [ "$TIJD" = "now" ]; then
            sudo shutdown now
        else
            sudo shutdown "+$TIJD"
        fi
        ;;
esac
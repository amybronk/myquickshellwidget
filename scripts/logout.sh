#!/bin/bash
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
elif command -v hyprctl &>/dev/null; then
    hyprctl dispatch exit
elif command -v swaymsg &>/dev/null; then
    swaymsg exit
elif command -v loginctl &>/dev/null; then
    loginctl terminate-session "$XDG_SESSION_ID"
else
    pkill -SIGTERM -u "$USER" Xorg 2>/dev/null \
    || pkill -SIGTERM -u "$USER" wayland
fi
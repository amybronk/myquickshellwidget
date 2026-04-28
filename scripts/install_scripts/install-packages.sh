#!/bin/bash

# detecteer package manager
if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm \
        hyprland \
        quickshell \
        qt5-graphicaleffects \
        qt6-declarative \
        git \
        libnotify
    echo "✓ Packages geïnstalleerd via pacman"
else
    echo "✗ Geen ondersteunde package manager gevonden (alleen pacman ondersteund)"
    exit 1
fi
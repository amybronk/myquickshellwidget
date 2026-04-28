#!/bin/bash

SAVE_STATE_DIR="$HOME/.config/quickshell/SaveStates_txt"
FILE="$SAVE_STATE_DIR/sesion_$(date +%d-%m).txt"

hyprctl clients | grep "title:" | sudo tee "$FILE"
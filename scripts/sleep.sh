#!/bin/bash
if command -v loginctl &>/dev/null; then
    loginctl suspend
elif command -v zzz &>/dev/null; then
    zzz
elif command -v pm-suspend &>/dev/null; then
    pm-suspend
else
    echo mem | sudo tee /sys/power/state
fi
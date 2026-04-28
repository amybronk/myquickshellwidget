#!/bin/bash

TIJD="${1:-now}"

if [ "$TIJD" = "now" ]; then
    notify-send -u critical "Afsluiten..."
else
    notify-send -u critical "Afsluiten over $TIJD minuten"
fi
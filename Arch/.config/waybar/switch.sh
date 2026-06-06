#!/bin/bash

STATE_FILE="$HOME/.config/waybar/.state"

if [ ! -f "$STATE_FILE" ]; then
echo "0" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

pkill waybar


if [[ "$STATE" == "1" ]]; then
waybar -c  "/home/duck/.config/waybar/horiz.jsonc" &
echo "0" > "$STATE_FILE"

elif [[ "$STATE" == "0" ]]; then
waybar -c  "/home/duck/.config/waybar/vert.jsonc" &
echo "1" > "$STATE_FILE"

else

echo "0" > "$STATE_FILE"
waybar -c  "/home/duck/.config/waybar/vert.jsonc" &
fi

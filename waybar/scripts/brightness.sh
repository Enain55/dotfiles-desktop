#!/bin/bash
# ── brightness.sh ─────────────────────────────────────────
# Description: Shows current brightness with ASCII bar + tooltip
# Usage: Waybar `custom/brightness` every 2s
# Dependencies: brightnessctl, seq, printf, awk
#  ─────────────────────────────────────────────────────────

# Get brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$((brightness * 100 / max_brightness))

if [ "$percent" -eq 0 ]; then
  filled=0
  empty=10
elif [ "$percent" -eq 100 ]; then
  filled=10
  empty=0
else
  filled=$(( (percent + 5) / 10 ))   # Rounded calculation for 10-level bar
  empty=$((10 - filled))
fi

bar=""
pad=""

if [ "$filled" -gt 0 ]; then
  bar=$(printf '█%.0s' $(seq 1 $filled))
fi

if [ "$empty" -gt 0 ]; then
  pad=$(printf '░%.0s' $(seq 1 $empty))
fi

ascii_bar="[$bar$pad]"

# Icon
icon="󰛨 "

# Color thresholds
if [ "$percent" -lt 20 ]; then
    fg="#bf616a"  # red
elif [ "$percent" -lt 55 ]; then
    fg="#fab387"  # orange
else
    fg="#56b6c2"  # cyan
fi

# Device name (first column from brightnessctl --machine-readable)
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')

# Tooltip text
tooltip="Brightness: $percent%\nDevice: $device"

# JSON output
echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar $percent%</span>\",\"tooltip\":\"$tooltip\"}"
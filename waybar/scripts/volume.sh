# ── volume.sh ─────────────────────────────────────────────
# Description: Shows current audio volume with ASCII bar + tooltip
# Usage: Waybar `custom/volume` every 1s
# Dependencies: wpctl, awk, bc, seq, printf
# ───────────────────────────────────────────────────────────

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')

# Check mute status
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Get default sink description (human-readable)
sink=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep '\*' | cut -d'.' -f2- | sed 's/^\s*//; s/\[.*//')

# Icon logic
if [ "$is_muted" = true ]; then
  icon=""
  vol_int=0
elif [ "$vol_int" -lt 50 ]; then
  icon=""
else
  icon=""
fi

# Fix the ASCII bar logic to handle 0% and 100% correctly
if [ "$vol_int" -eq 0 ]; then
  filled=0
  empty=10
elif [ "$vol_int" -eq 100 ]; then
  filled=10
  empty=0
else
  filled=$(( (vol_int + 5) / 10 ))
  empty=$((10 - filled))
fi

# ASCII bar (safe version)
bar=""
pad=""

if [ "$filled" -gt 0 ]; then
  bar=$(printf '█%.0s' $(seq 1 $filled))
fi

if [ "$empty" -gt 0 ]; then
  pad=$(printf '░%.0s' $(seq 1 $empty))
fi

ascii_bar="[$bar$pad]"

# Color logic
# Make sure fg is set properly, fallback to a default color if not
if [ "$is_muted" = true ] || [ "$vol_int" -lt 10 ]; then
  fg="#bf616a"  # red
elif [ "$vol_int" -lt 50 ]; then
  fg="#fab387"  # orange
else
  fg="#56b6c2"  # cyan
fi

# Tooltip text
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: $vol_int%\nOutput: $sink"
fi

# Final JSON output for Waybar
echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar $vol_int%</span>\",\"tooltip\":\"$tooltip\"}"
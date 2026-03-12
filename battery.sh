#!/bin/bash

BAT="/sys/class/power_supply/BAT0"

capacity=$(cat "$BAT/capacity")
status=$(cat "$BAT/status")

icon=""

if [ "$status" = "Charging" ]; then
  icon=""
elif [ "$capacity" -ge 90 ]; then
  icon=""
elif [ "$capacity" -ge 70 ]; then
  icon=""
elif [ "$capacity" -ge 40 ]; then
  icon=""
elif [ "$capacity" -ge 20 ]; then
  icon=""
else
  icon=""
fi

printf '{"text":"%s %s%%","tooltip":"%s %s%%"}\n' "$icon" "$capacity" "$status" "$capacity"

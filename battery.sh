#!/bin/bash

BAT=""

for d in /sys/class/power_supply/*; do
  [ -d "$d" ] || continue
  [ -f "$d/type" ] || continue

  if [ "$(cat "$d/type" 2>/dev/null)" = "Battery" ]; then
    BAT="$d"
    break
  fi
done

if [ -z "$BAT" ]; then
  printf '{"text":" AC","class":"no-battery","tooltip":"Aucune batterie détectée"}\n'
  exit 0
fi

capacity="$(cat "$BAT/capacity" 2>/dev/null)"
status="$(cat "$BAT/status" 2>/dev/null)"

if ! [[ "$capacity" =~ ^[0-9]+$ ]]; then
  printf '{"text":" N/A","class":"critical","tooltip":"Capacité batterie introuvable"}\n'
  exit 0
fi

icon=""
class="normal"

if [ "$status" = "Charging" ]; then
  icon=""
  class="charging"
elif [ "$capacity" -ge 90 ]; then
  icon=""
elif [ "$capacity" -ge 70 ]; then
  icon=""
elif [ "$capacity" -ge 40 ]; then
  icon=""
elif [ "$capacity" -ge 20 ]; then
  icon=""
  class="warning"
else
  icon=""
  class="critical"
fi

printf '{"text":"%s %s%%","class":"%s","tooltip":"%s - %s%%"}\n' \
  "$icon" "$capacity" "$class" "${status:-Unknown}" "$capacity"

#!/usr/bin/env bash
# waybar-media.sh — выводит одну JSON-строку для waybar
# Зависимость: playerctl

# пытаемся получить статус
status=$(playerctl status 2>/dev/null || echo "Stopped")

if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
  text="⏹ No player"
  cls="stopped"
else
  title=$(playerctl metadata xesam:title 2>/dev/null)
  artist=$(playerctl metadata xesam:artist 2>/dev/null)

  # иногда artist приходит как массив
  if echo "$artist" | grep -q "\["; then
    artist=$(echo "$artist" | sed 's/[][]//g' | awk -F, '{print $1}')
  fi

  # fallbackы
  [ -z "$artist" ] && artist="Unknown"
  [ -z "$title" ] && title="Unknown"

  if [ "$status" = "Playing" ]; then
    icon="⏵"
    cls="playing"
  else
    icon="⏸"
    cls="paused"
  fi

  text="$icon $artist — $title"
fi



# обрезаем и экранируем кавычки
text=$(printf "%s" "$text" | sed 's/^\(.\{0,100\}\).*/\1/; s/"/\\"/g')
text=$(echo "$text" | iconv -f utf-8 -t utf-8 -c)
text="${text//&/&amp;}"
# вывод JSON (одно поле text + class + alt для tooltip/status)
printf '{"text":"%s","class":"%s","alt":"%s"}\n' "$text" "$cls" "$status"

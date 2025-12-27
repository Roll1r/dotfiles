#!/usr/bin/env bash
# waybar-media-action.sh <action>
# actions: play-pause, next, previous, stop

ACTION="$1"
case "$ACTION" in
  play-pause) playerctl play-pause ;;
  next)       playerctl next ;;
  previous)   playerctl previous ;;
  stop)       playerctl stop ;;
  *)          echo "Unknown action" ;;
esac
#!/usr/bin/env bash

choice=$(printf "Logout\nReboot\nShutdown" | wofi --dmenu --prompt "Действие:")

case "$choice" in
    "Logout")
        pkill -KILL -u "$USER"
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
esac
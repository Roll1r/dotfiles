#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

# Запуск команды с проверкой результата
run() {
    echo "➤ $*"
    if "$@"; then
        echo "✅ Успешно: $*"
    else
        local status=$?
        echo "❌ Ошибка при выполнении: $* (код $status)" >&2
        exit $status
    fi
}

read -rp "⚠️  Этот скрипт установит пакеты и скопирует конфиги. Продолжить? (y/N): " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "❌ Отменено пользователем."
    exit 1
fi

copy_config() {
    local src="$1"
    local dest="$2"
    echo "📂 Копирование $src → $dest"
    if [[ "$dest" == /etc/* || "$dest" == /usr/* ]]; then
        run sudo mkdir -p "$(dirname "$dest")"
        run sudo cp -r "$src" "$dest"
    else
        run mkdir -p "$(dirname "$dest")"
        run cp -r "$src" "$dest"
    fi
}

echo "🚀 Установка пакетов через pacman..."
run sudo pacman -S --noconfirm --needed \
    neovim wofi waybar nwg-dock-hyprland slurp grim wl-clipboard \
    dunst fastfetch hyprpaper zsh \
    bashtop cava ttf-jetbrains-mono-nerd \
    sddm nautilus gnome-calculator gnome-clocks gnome-calendar baobab dconf

echo "💻 Установка zsh как shell по умолчанию для $USER..."
run chsh -s "$(which zsh)" "$USER"

echo "🗂 Копирование конфигов в ~/.config..."
copy_config "$CONFIG_DIR/dunst" "$HOME/.config/dunst"
copy_config "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
copy_config "$CONFIG_DIR/hypr" "$HOME/.config/hypr"
copy_config "$CONFIG_DIR/kitty" "$HOME/.config/kitty"
copy_config "$CONFIG_DIR/nvim" "$HOME/.config/nvim"
copy_config "$CONFIG_DIR/nwg-dock-hyprland" "$HOME/.config/nwg-dock-hyprland"
copy_config "$CONFIG_DIR/waybar" "$HOME/.config/waybar"
copy_config "$CONFIG_DIR/waybar_scripts" "$HOME/.config/waybar_scripts"
copy_config "$CONFIG_DIR/wofi" "$HOME/.config/wofi"
copy_config "$CONFIG_DIR/.p10k.zsh" "$HOME/.config/.p10k.zsh"

echo "🏠 Копирование файлов в \$HOME..."
copy_config "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
copy_config "$CONFIG_DIR/.oh-my-zsh" "$HOME/.oh-my-zsh"

echo "🎨 Настройка SDDM..."
copy_config "$CONFIG_DIR/sddm.conf" "/etc/sddm.conf"
copy_config "$CONFIG_DIR/sddm-theme" "/usr/share/sddm/themes/"

echo "🌈 Установка темы Dracula..."
copy_config "$CONFIG_DIR/Dracula" "/usr/share/themes/Dracula"

echo "🖌 Применение темы через gsettings..."
run gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
run gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "⚡ Включение SDDM..."
run sudo systemctl enable sddm

echo "✅ Всё готово. Перезагрузите устройство."



#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/configs"

run() {
    echo "➤ $*"
    if "$@"; then
        echo "✅ Success: $*"
    else
        local status=$?
        echo "❌ Error executing: $* (code $status)" >&2
        exit $status
    fi
}

read -rp "⚠️  This script will install packages and copy configuration files. Continue? (y/N): " answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled by user."
    exit 1
fi

copy_config() {
    local src="$1"
    local dest="$2"
    echo "📂 Copying $src → $dest"
    if [[ "$dest" == /etc/* || "$dest" == /usr/* ]]; then
        run sudo mkdir -p "$dest"
        run sudo cp -r "$src/." "$dest/"
    else
        run mkdir -p "$dest"
        run cp -r "$src/." "$dest/"
    fi
}

echo "🚀 Installing packages via pacman..."
run sudo pacman -S --noconfirm --needed \
    neovim wofi waybar hyprland kitty slurp grim wl-clipboard \
    dunst fastfetch hyprpaper hyprpolkitagent zsh btop ttf-jetbrains-mono-nerd \
    sddm nautilus gnome-calculator gnome-clocks gnome-calendar baobab dconf which \
    qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt5-wayland qt6-wayland xdg-desktop-portal-hyprland \
    pulseaudio pavucontrol

echo "💻 Setting zsh as the default shell for $USER..."
run chsh -s "$(which zsh)" "$USER"

echo "🗂️ Copying configs to ~/.config..."
copy_config "$CONFIG_DIR/dunst" "$HOME/.config/dunst"
copy_config "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
copy_config "$CONFIG_DIR/hypr" "$HOME/.config/hypr"
copy_config "$CONFIG_DIR/kitty" "$HOME/.config/kitty"
copy_config "$CONFIG_DIR/nvim" "$HOME/.config/nvim"
copy_config "$CONFIG_DIR/waybar" "$HOME/.config/waybar"
copy_config "$CONFIG_DIR/waybar_scripts" "$HOME/.config/waybar_scripts"
copy_config "$CONFIG_DIR/wofi" "$HOME/.config/wofi"
run cp "$CONFIG_DIR/.p10k.zsh" "$HOME/.config/.p10k.zsh"

echo "🏠 Copying files to \$HOME..."
run cp "$CONFIG_DIR/.zshrc" "$HOME/.zshrc"
copy_config "$CONFIG_DIR/OMZSH" "$HOME/.oh-my-zsh"

echo "🎨 Configuring SDDM..."
run sudo cp "$CONFIG_DIR/sddm.conf" "/etc/sddm.conf"
copy_config "$CONFIG_DIR/sddm-astronaut-theme" "/usr/share/sddm/themes/"

echo "🌈 Installing Dracula theme..."
copy_config "$CONFIG_DIR/Dracula" "/usr/share/themes/Dracula"

echo "🖌️ Applying theme via gsettings..."
run gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
run gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "📁 Setting Nautilus as the default file manager"
run xdg-mime default org.gnome.Nautilus.desktop inode/directory

echo "⚡ Enabling SDDM..."
run sudo systemctl enable sddm

echo "✅ All done! Please reboot your device. 🎉"

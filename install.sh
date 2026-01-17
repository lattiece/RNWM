#!/usr/bin/env bash
set -e

echo "Starting RNWM (Dot-Smooth) Installation..."

# -----------------------------
# Helpers
# -----------------------------
require_cmd() {
    command -v "$1" >/dev/null 2>&1
}

SUDO=""
if [ "$EUID" -ne 0 ]; then
    if require_cmd sudo; then
        SUDO="sudo"
    else
        echo "ERROR: sudo not found and not running as root"
        exit 1
    fi
fi

# -----------------------------
# Detect Distro
# -----------------------------
if [ -r /etc/os-release ]; then
    . /etc/os-release
else
    echo "ERROR: Cannot detect distro"
    exit 1
fi

echo "Detected distro: $ID"

# -----------------------------
# Package Install
# -----------------------------
install_packages() {
    case "$ID" in
        arch|cachyos)
            $SUDO pacman -S --needed --noconfirm \
                i3-wm picom rofi dunst feh maim xclip \
                xorg-server xorg-xinit xsetroot
            ;;
        ubuntu|debian)
            $SUDO apt update
            $SUDO apt install -y \
                i3 picom rofi dunst feh maim xclip \
                xorg xinit x11-xserver-utils fonts-font-awesome
            ;;
        fedora)
            $SUDO dnf install -y \
                i3 picom rofi dunst feh maim xclip \
                xorg-x11-server-Xorg xorg-x11-xinit fontawesome-fonts
            ;;
        opensuse*|suse)
            $SUDO zypper install -y \
                i3 picom rofi dunst feh maim xclip \
                xorg-x11-server xinit fontawesome-fonts
            ;;
        *)
            echo "Unsupported distro: $ID"
            exit 1
            ;;
    esac
}

# -----------------------------
# Fonts (Cross-Distro Safe)
# -----------------------------
install_fonts() {
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    if [ ! -f "$FONT_DIR/HasklugNerdFont-Regular.ttf" ]; then
        echo "Installing Nerd Font (Hasklug)..."
        tmpdir=$(mktemp -d)
        curl -fsSL \
            https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hasklig.zip \
            -o "$tmpdir/font.zip"
        unzip -q "$tmpdir/font.zip" -d "$FONT_DIR"
        rm -rf "$tmpdir"
        fc-cache -f
    else
        echo "Nerd Font already installed"
    fi
}

# -----------------------------
# Deploy Configs
# -----------------------------
deploy_configs() {
    echo "Deploying configs..."

    mkdir -p ~/.config/i3
    if [ -f ~/.config/i3/config ]; then
        mv ~/.config/i3/config ~/.config/i3/config.bak.$(date +%s)
    fi
    cp ./config ~/.config/i3/config

    if [ -f ~/.config/picom.conf ]; then
        mv ~/.config/picom.conf ~/.config/picom.conf.bak.$(date +%s)
    fi
    cp ./picom.conf ~/.config/picom.conf
}

# -----------------------------
# Run
# -----------------------------
install_packages
install_fonts
deploy_configs

echo "--------------------------------------------------------"
echo "RNWM Setup Complete!"
echo
echo "Next steps:"
echo "• Ubuntu Server: install a display manager (lightdm/gdm)"
echo "• Start X with: startx"
echo "• Or select i3 from your login manager"
echo "--------------------------------------------------------"

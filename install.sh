#!/bin/bash
set -e

echo "Starting RNWM (Dot-Smooth) Installation..."

# 1. Install Packages (Arch/CachyOS)
echo "Installing i3wm and tools..."
sudo pacman -S --needed --noconfirm \
    i3-wm \
    picom \
    rofi \
    dunst \
    xorg-xsetroot \
    feh \
    maim \
    xclip

# 2. Install Fonts
echo "Installing fonts..."
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm ttf-hasklug-nerd
elif command -v yay &> /dev/null; then
    yay -S --needed --noconfirm ttf-hasklug-nerd
else
    echo "Warning: No AUR helper found. Installing 'ttf-jetbrains-mono-nerd' as fallback."
    sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
fi

# 3. Deploy Configs
echo "Deploying configurations..."

# i3
mkdir -p ~/.config/i3
backup_i3=~/.config/i3/config.bak.$(date +%s)
if [ -f ~/.config/i3/config ]; then
    echo "Backing up existing i3 config to $backup_i3"
    mv ~/.config/i3/config "$backup_i3"
fi
cp config ~/.config/i3/config

# Picom
mkdir -p ~/.config
backup_picom=~/.config/picom.conf.bak.$(date +%s)
if [ -f ~/.config/picom.conf ]; then
    echo "Backing up existing picom config to $backup_picom"
    mv ~/.config/picom.conf "$backup_picom"
fi
cp picom.conf ~/.config/picom.conf

echo "--------------------------------------------------------"
echo "RNWM Setup Complete!"
echo "1. If you are in a desktop session, log out."
echo "2. Select 'i3' from your login manager."
echo "3. Enjoy your smooth setup!"
echo "--------------------------------------------------------"

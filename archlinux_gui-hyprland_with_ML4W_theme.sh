#!/bin/bash

# https://github.com/mylinuxforwork/dotfiles/wiki
# https://github.com/mylinuxforwork/dotfiles?tab=readme-ov-file
# https://github.com/mylinuxforwork/dotfiles/wiki/Installation
# https://github.com/mylinuxforwork/dotfiles/wiki/Troubleshooting
# https://github.com/mylinuxforwork/dotfiles/wiki/Monitor-Configuration


# if pacman -Qqs hyprland ; then
    # Pacotes essenciais para desenvolvimento
    sudo pacman --needed --noconfirm -S git base-devel
    # The ML4W Dotfiles for Hyprland
    git clone https://aur.archlinux.org/ml4w-hyprland.git /tmp/ml4w-hyprland
    cd /tmp/ml4w-hyprland || exit 1
    makepkg --needed --noconfirm -Cris && \
    ml4w-hyprland-setup
    sudo pacman --needed --noconfirm -S hyprutils nwg-displays
# else
# 	echo "Deve instalar a base Hyprland primeiro!"
# 	exit 1
# fi

# Se não quiser usar o Dock, crie este arquivo:
# touch $HOME/.config/ml4w/settings/dock-disabled
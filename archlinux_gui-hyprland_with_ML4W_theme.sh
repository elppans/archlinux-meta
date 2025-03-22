#!/bin/bash

# https://github.com/mylinuxforwork/dotfiles?tab=readme-ov-file
# https://github.com/mylinuxforwork/dotfiles/wiki/Installation

# if pacman -Qqs hyprland ; then
    # Pacotes essenciais para desenvolvimento
    sudo pacman --needed --noconfirm -S git base-devel
    # The ML4W Dotfiles for Hyprland
    git clone https://aur.archlinux.org/ml4w-hyprland.git /tmp/ml4w-hyprland
    cd /tmp/ml4w-hyprland || exit 1
    makepkg --needed --noconfirm -Cris && \
    ml4w-hyprland-setup
# else
# 	echo "Deve instalar a base Hyprland primeiro!"
# 	exit 1
# fi


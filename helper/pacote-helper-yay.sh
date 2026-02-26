#!/bin/bash

sudo pacman --needed -Sy base-devel debugedit fakeroot

# Wrappers do pacman (AUR Helper)
mkdir -p "$HOME/build" && echo 'build' >> "$HOME/.hidden"
git clone https://aur.archlinux.org/yay.git "$HOME/.hidden/yay"
cd "$HOME/.hidden/yay" || exit 1
makepkg -Cris -L --needed --noconfirm
cd - || exit 1



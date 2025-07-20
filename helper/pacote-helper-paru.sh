#!/bin/bash

# Wrappers do pacman (AUR Helper)
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin || exit
makepkg --needed --noconfirm -Cris

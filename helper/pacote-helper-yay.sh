#!/bin/bash

# Wrappers do pacman (AUR Helper)
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay || exit 1
makepkg -Cris -L --needed --noconfirm


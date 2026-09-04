#!/usr/bin/env bash

if [ "$(command -v dolphin)" ]; then
	sudo pacman -S dolphin kdialog imagemagick jhead libwebp-utils
	git clone https://aur.archlinux.org/kde-service-menu-reimage-mod.git
	makepkg --needed --noconfirm -Cris
fi

#!/bin/bash

sudo pacman --needed -Sy base-devel debugedit fakeroot

# Wrappers do pacman (AUR Helper)
if pacman -Sqs | grep ^paru$ ;then
	sudo pacman --needed -Sy paru
else
	mkdir -p "$HOME/build" && echo 'build' >>"$HOME/.hidden"
	git clone https://aur.archlinux.org/paru.git "$HOME"/build/paru
	cd "$HOME"/build/paru || exit
	makepkg --needed --noconfirm -Cris
	cd - || exit 1
fi

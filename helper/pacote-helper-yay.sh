#!/bin/bash

sudo pacman --needed -Sy base-devel debugedit fakeroot

# Wrappers do pacman (AUR Helper)
if pacman -Sqs | grep ^yay$ ;then
	sudo pacman --needed -Sy yay
else
	mkdir -p "$HOME/build" && echo 'build' >>"$HOME/.hidden"
	git clone https://aur.archlinux.org/yay.git "$HOME/build/yay"
	cd "$HOME/build/yay" || exit 1
	makepkg -Cris -L --needed --noconfirm
	cd - || exit 1
fi

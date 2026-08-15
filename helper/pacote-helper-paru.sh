#!/bin/bash

sudo pacman --needed --noconfirm -Sy base-devel debugedit fakeroot

# Dependências opcionais para o paru:
sudo pacman --needed --noconfirm -Sy bat devtools

# Wrappers do pacman (AUR Helper)
if pacman -Sqs | grep ^paru$ ;then
	sudo pacman --needed --noconfirm -Sy paru
else
	mkdir -p "$HOME/build" && echo 'build' >>"$HOME/.hidden"
	git clone https://aur.archlinux.org/paru-bin.git "$HOME"/build/paru-bin
	cd "$HOME"/build/paru-bin || exit
	makepkg --needed --noconfirm -Cris
	cd - || exit 1
fi

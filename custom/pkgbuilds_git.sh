#!/bin/bash

# Remover pacotes virt*
# sudo pacman -Rsunc $(pacman -Qqs | grep ^virt) ; sudo paclean ; sudo pacman -Syyu

mkdir -p "$HOME"/build
grep -q 'build' "$HOME"/.hidden 2>/dev/null || echo -e 'build\nBuild' | tee -a "$HOME"/.hidden &>>/dev/null
cd "$HOME/build" || exit 1

PACOTES_PKGBUILD=(
	# bridge-nm
	# virt-qmod
	# virt-gmod
	# vscodeum # Pacote está na sessão flatpak.ini
	faceconv
	nautilus-baobab
)

for pacote in "${PACOTES_PKGBUILD[@]}"; do
	mkdir -p "$HOME/build/$pacote"
	cd "$HOME/build/$pacote" || exit 1
	wget -O PKGBUILD "https://raw.githubusercontent.com/elppans/$pacote/refs/heads/main/pkgbuild/PKGBUILD" || { echo "Falha ao baixar PKGBUILD de $pacote"; continue; }
	makepkg -Cris
done
#!/usr/bin/env bash

if ! pacman -Qq vscodeum &>>/dev/null ;then
	mkdir -p "$HOME/build/vscodeum"
	cd "$HOME/build/vscodeum" || exit 1
	wget -O PKGBUILD "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/pkgbuild/PKGBUILD" || { echo "Falha ao baixar PKGBUILD de vscodeum"; }
	makepkg -Cris
fi

if pacman -Qq vscodeum; then
	/usr/local/bin/vscodeum-extensions import vscodium "$HOME/.vscode-oss/vscodium_extensions.txt"
else
	echo -e "O pacote \"VSCodeum\" não está instalado!"
	sleep 5
fi

if command -v flatpak &>/dev/null && flatpak info com.vscodium.codium &>/dev/null; then
	flatpak override --user \
		--filesystem=~/.bin:ro \
		--filesystem=~/.local/bin:ro \
		--env=PATH="/app/bin:/usr/bin:$HOME/.bin:$HOME/.local/bin" \
		com.vscodium.codium
fi

if command -v flatpak &>/dev/null && flatpak info com.visualstudio.code &>/dev/null; then
	flatpak override --user \
		--filesystem=~/.bin:ro \
		--filesystem=~/.local/bin:ro \
		--env=PATH="/app/bin:/usr/bin:$HOME/.bin:$HOME/.local/bin" \
		com.visualstudio.code
fi

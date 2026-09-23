#!/usr/bin/env bash

make_timestamp(){
if grep -q '^pkgrel=.*date' PKGBUILD; then
    sed -i "s/^pkgrel=.*date.*/pkgrel=1/" PKGBUILD
    echo "pkgrel baseado em timestamp detectado — fixado em 1"
fi
}
makebuild() {
# -C, --cleanbuild Remove o diret\C3\B3rio $srcdir/ antes de compilar o pacote
# -r, --rmdeps     Remove depend\C3\AAncias instaladas ap\C3\B3s uma compila\C3\A7\C3\A3o bem-sucedida
# -i, --install    Instala pacote ap\C3\B3s empacotamento bem-sucedido
# -s, --syncdeps   Instala depend\C3\AAncias em falta com pacman
    git pull 2>/dev/null
    make_timestamp
    makepkg --needed --noconfirm -Cris
}

if [ "$(command -v nautilus)" ]; then
	sudo pacman --needed --noconfirm -S nautilus-python
fi

if ! pacman -Qq vscodeum &>>/dev/null ;then
	mkdir -p "$HOME/build/vscodeum"
	cd "$HOME/build/vscodeum" || exit 1
	wget -O PKGBUILD "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/pkgbuild/PKGBUILD" || { echo "Falha ao baixar PKGBUILD de vscodeum"; }
	makebuild
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

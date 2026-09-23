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

if [ "$(command -v dolphin)" ]; then
	sudo pacman -S dolphin kdialog imagemagick jhead libwebp-utils
	git clone https://aur.archlinux.org/kde-service-menu-reimage-mod.git
	cd kde-service-menu-reimage-mod || exit 1
	makebuild
fi


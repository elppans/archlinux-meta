#!/usr/bin/env bash

makebuild() {
# --[no]removemake       Remove dependências de compilação após instalação
# --[no]sudoloop         Repete chamadas sudo em segundo plano para evitar esgotar o tempo
# --[no]keepsrc          Mantém diretórios src/ e pkg/ após compilar pacotes
# yay/paru {-B --build}       [diretório(s)]

# -C, --cleanbuild Remove o diretório $srcdir/ antes de compilar o pacote
# -r, --rmdeps     Remove dependências instaladas após uma compilação bem-sucedida
# -i, --install    Instala pacote após empacotamento bem-sucedido
# -s, --syncdeps   Instala dependências em falta com pacman

if [ "$(command -v yay)" ]; then
	yay --needed --noconfirm --removemake --sudoloop --build "$(pwd)"
elif [ "$(command -v paru)" ]; then
	paru --needed --noconfirm --removemake --sudoloop --nokeepsrc --build "$(pwd)"
else
	makepkg --needed --noconfirm -Cris
fi
}

if [ "$(command -v dolphin)" ]; then
	sudo pacman -S dolphin kdialog imagemagick jhead libwebp-utils
	git clone https://aur.archlinux.org/kde-service-menu-reimage-mod.git
	cd kde-service-menu-reimage-mod || exit 1
	makebuild
fi


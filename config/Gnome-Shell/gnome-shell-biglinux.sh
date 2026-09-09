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

mkdir -p "$HOME/build"
cd "$HOME/build" || exit 1
git clone https://github.com/biglinux/big-hardware-info
cd big-hardware-info/pkgbuild || exit 1
makebuild
git clone https://github.com/big-comm/gnome-shell-big-shot
cd gnome-shell-big-shot/pkgbuild || exit 1
makebuild
git clone https://github.com/big-comm/big-gnome-center
cd big-gnome-center/pkgbuild || exit 1
makebuild
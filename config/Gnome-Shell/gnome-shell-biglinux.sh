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

# Dependências

sudo pacman --needed --noconfirm -S pnpm
# echo '^4' | yay --needed --noconfirm --removemake --sudoloop gnome-shell-extension-copyous-bin

mkdir -p "$HOME/build"

cd "$HOME/build" || exit 1
git clone https://aur.archlinux.org/gnome-shell-extension-copyous-bin.git
cd gnome-shell-extension-copyous-bin || exit 1
echo '^4' | makebuild

cd "$HOME/build" || exit 1
git clone https://github.com/biglinux/big-hardware-info
cd big-hardware-info/pkgbuild || exit 1
makebuild

cd "$HOME/build" || exit 1
git clone https://github.com/big-comm/gnome-shell-big-shot
cd gnome-shell-big-shot/pkgbuild || exit 1
makebuild

cd "$HOME/build" || exit 1
git clone -b main https://github.com/elppans/big-gnome-center
# grep -iE '(fill|stroke)=' distributor-logo-blackarch.svg
# sed -i 's/fill="rgb(30.196078%, 30.196078%, 30.196078%)"/fill="#808080"/g' distributor-logo-blackarch.svg
cd big-gnome-center/pkgbuild || exit 1
makebuild

cd "$HOME/build" || exit 1
git clone https://github.com/big-comm/comm-wallpapers-gnome.git
cd comm-wallpapers-gnome/pkgbuild || exit 1
makebuild

cd "$HOME/build" || exit 1
git clone https://github.com/biglinux/bigicons-papient.git
cd bigicons-papient/pkgbuild || exit 1
makebuild
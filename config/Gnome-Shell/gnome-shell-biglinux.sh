#!/usr/bin/env bash

makebuild() {
# --[no]removemake       Remove depend\C3\AAncias de compila\C3\A7\C3\A3o ap\C3\B3s instala\C3\A7\C3\A3o
# --[no]sudoloop         Repete chamadas sudo em segundo plano para evitar esgotar o tempo
# --[no]keepsrc          Mant\C3\A9m diret\C3\B3rios src/ e pkg/ ap\C3\B3s compilar pacotes
# yay/paru {-B --build}       [diret\C3\B3rio(s)]

# -C, --cleanbuild Remove o diret\C3\B3rio $srcdir/ antes de compilar o pacote
# -r, --rmdeps     Remove depend\C3\AAncias instaladas ap\C3\B3s uma compila\C3\A7\C3\A3o bem-sucedida
# -i, --install    Instala pacote ap\C3\B3s empacotamento bem-sucedido
# -s, --syncdeps   Instala depend\C3\AAncias em falta com pacman

if [ "$(command -v yay)" ]; then
	yay --needed --noconfirm --removemake --sudoloop --build "$(pwd)"
elif [ "$(command -v paru)" ]; then
	paru --needed --noconfirm --removemake --sudoloop --nokeepsrc --build "$(pwd)"
else
	makepkg --needed --noconfirm -Cris
fi
}

# Depend\C3\AAncias

sudo pacman --needed --noconfirm -S pnpm
# echo '^4' | yay --needed --noconfirm --removemake --sudoloop gnome-shell-extension-copyous-bin

mkdir -p "$HOME/build"

# Copyous BIG Community - Esta vers\C3\A3o d\C3\A1 erro ao instalar (Muito trabalho, n\C3\A3o vou resolver)
# cd "$HOME/build" || exit 1
# git clone https://github.com/big-comm/gnome-shell-extension-copyous.git
# cd gnome-shell-extension-copyous/pkgbuild || exit 1
# echo '^4' | makebuild

# Copyous AUR - Esta vers\C3\A3o funciona perfeitamente - Necess\C3\A1rio para BIG Gnome Center
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

# O aplicativo funciona, mas para fazer algumas altera\C3\A7\C3\B5es, \C3\A9 necess\C3\A1rio a instala\C3\A7\C3\A3o de outros pacotes do BIGLinux
# cd "$HOME/build" || exit 1
# git clone https://github.com/big-comm/biglinux-settings.git
# cd biglinux-settings/pkgbuild || exit 1
# makebuild

# big-bibata-cursor-theme - Dependência para "big-gnome-center"
cd "$HOME/build" || exit 1
git clone -b dev-talesam https://github.com/big-comm/Bibata_Cursor.git
cd Bibata_Cursor/pkgbuild || exit 1
makebuild

# Aplicativo de temas, ele \C3\A9 muito bom
cd "$HOME/build" || exit 1
git clone -b dev-talesam https://github.com/big-comm/big-gnome-center.git
#grep -iE '(fill|stroke)=' distributor-logo-blackarch.svg
#sed -i 's/fill="rgb(30.196078%, 30.196078%, 30.196078%)"/fill="#808080"/g' distributor-logo-blackarch.svg
cd big-gnome-center/pkgbuild || exit 1
makebuild

# Wallpapers para acompanhar o Big Gnome Center
cd "$HOME/build" || exit 1
git clone https://github.com/big-comm/comm-wallpapers-gnome.git
cd comm-wallpapers-gnome/pkgbuild || exit 1
makebuild

# Icones necessario para  o Big Gnome Center
cd "$HOME/build" || exit 1
git clone https://github.com/biglinux/bigicons-papient.git
cd bigicons-papient/pkgbuild || exit 1
makebuild

# O aplicativo funciona, mas para fazer algumas altera\C3\A7\C3\B5es, \C3\A9 necess\C3\A1rio a instala\C3\A7\C3\A3o de outros pacotes do BIGLinux/Manjaro
# cd "$HOME/build" || exit 1
# git clone https://github.com/biglinux/biglinux-driver-manager.git
# cd biglinux-driver-manager/pkgbuild || exit 1
# makebuild

# cd "$HOME/build" || exit 1
# git clone https://github.com/biglinux/big-kernel-manager.git
# cd big-kernel-manager/pkgbuild || exit 1
# makebuild

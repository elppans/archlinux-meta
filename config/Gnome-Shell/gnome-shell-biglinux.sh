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
    sudo -v
    git pull 2>/dev/null
    make_timestamp
    makepkg --needed --noconfirm -Cris
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
git clone -b dev-talesam https://github.com/elppans/Bibata_Cursor.git
cd Bibata_Cursor/pkgbuild || exit 1
makebuild

# Aplicativo de temas, ele \C3\A9 muito bom
cd "$HOME/build" || exit 1
git clone -b dev-talesam https://github.com/elppans/big-gnome-center.git
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

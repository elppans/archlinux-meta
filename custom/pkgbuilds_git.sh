#!/bin/bash

mkdir -p "$HOME"/build
echo -e 'build\nBuild' | tee -a "$HOME"/.hidden &>>/dev/null
cd "$HOME/build" || exit 1

# Remover pacotes virt*
# sudo pacman -Rsunc $(pacman -Qqs | grep ^virt) ; sudo paclean ; sudo pacman -Syyu

# mkdir -p "$HOME/build/bridge-nm" && cd "$HOME/build/bridge-nm" || exit 1
# wget -O "$HOME/build/bridge-nm/PKGBUILD" "https://raw.githubusercontent.com/elppans/bridge-nm/refs/heads/main/pkgbuild/PKGBUILD"
# makepkg -Cris

# mkdir -p "$HOME/build/virt-qmod" && cd "$HOME/build/virt-qmod" || exit 1
# wget -O "$HOME/build/virt-qmod/PKGBUILD" "https://raw.githubusercontent.com/elppans/virt-qmod/refs/heads/main/pkgbuild/PKGBUILD"
# makepkg -Cris

# mkdir -p "$HOME/build/virt-gmod" && cd "$HOME/build/virt-gmod" || exit 1
# wget -O "$HOME/build/virt-gmod/PKGBUILD" "https://raw.githubusercontent.com/elppans/virt-gmod/refs/heads/main/pkgbuild/PKGBUILD"
# makepkg -Cris

# mkdir -p "$HOME/build/vscodeum" && cd "$HOME/build/vscodeum" || exit 1
# wget -O "$HOME/build/vscodeum/PKGBUILD" "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/PKGBUILD"
# makepkg -Cris

mkdir -p "$HOME/build/faceconv" && cd "$HOME/build/faceconv" || exit 1
wget -c https://raw.githubusercontent.com/elppans/faceconv/refs/heads/main/pkgbuild/PKGBUILD
makepkg -Cris

if pacman -Qqs sddm-silent-theme ; then
	mkdir -p "$HOME/build/sddm-silent-customizer"
	wget -O "$HOME/build/sddm-silent-customizer/PKGBUILD" "https://raw.githubusercontent.com/elppans/sddm-silent-customizer/refs/heads/main/PKGBUILD"
	cd "$HOME/build/sddm-silent-customizer" || exit 1
	makepkg -Cris
fi

#!/bin/bash

mkdir -p "$HOME"/build/{bridge-nm,paclean,virt-qmod,virt-gmod,vscodeum}
wget -O "$HOME/build/bridge-nm/PKGBUILD" "https://raw.githubusercontent.com/elppans/bridge-nm/refs/heads/main/pkgbuild/PKGBUILD"
wget -O "$HOME/build/paclean/PKGBUILD" "https://raw.githubusercontent.com/elppans/paclean/refs/heads/main/PKGBUILD"
wget -O "$HOME/build/virt-qmod/PKGBUILD" "https://raw.githubusercontent.com/elppans/virt-qmod/refs/heads/main/pkgbuild/PKGBUILD"
wget -O "$HOME/build/virt-gmod/PKGBUILD" "https://raw.githubusercontent.com/elppans/virt-gmod/refs/heads/main/pkgbuild/PKGBUILD"
wget -O "$HOME/build/vscodeum/PKGBUILD" "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/PKGBUILD"
cd "$HOME/build" || exit 1
git clone https://aur.archlinux.org/aurm.git && cd aurm || exit 1
makepkg -Cris
cd "$HOME/build" || exit 1
git clone https://aur.archlinux.org/pacod.git && cd pacod || exit 1
makepkg -Cris
cd "$HOME/build/bridge-nm" || exit 1
makepkg -Cris
cd "$HOME/build/paclean" || exit 1
makepkg -Cris
cd "$HOME/build/virt-qmod" || exit 1
makepkg -Cris
cd "$HOME/build/virt-gmod" || exit 1
makepkg -Cris
cd "$HOME/build/vscodeum" || exit 1
makepkg -Cris


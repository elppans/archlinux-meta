#!/bin/bash

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

# Remover pacotes virt*
# sudo pacman -Rsunc $(pacman -Qqs | grep ^virt) ; sudo paclean ; sudo pacman -Syyu

mkdir -p "$HOME"/build
grep -q 'build' "$HOME"/.hidden 2>/dev/null || echo -e 'build\nBuild' | tee -a "$HOME"/.hidden &>>/dev/null
cd "$HOME/build" || exit 1

if [ "$(command -v nautilus)" ]; then
PACOTES_PKGBUILD=(
	# bridge-nm
	# virt-qmod
	# virt-gmod
	vscodeum # Pacote está na sessão flatpak.ini
	faceconv
	nautilus-baobab
)
else
PACOTES_PKGBUILD=(
	# bridge-nm
	# virt-qmod
	# virt-gmod
	vscodeum # Pacote está na sessão flatpak.ini
	faceconv
)
fi

for pacote in "${PACOTES_PKGBUILD[@]}"; do
if ! pacman -Qq "$pacote" &>>/dev/null ;then
	mkdir -p "$HOME/build/$pacote"
	cd "$HOME/build/$pacote" || exit 1
	wget -O PKGBUILD "https://raw.githubusercontent.com/elppans/$pacote/refs/heads/main/pkgbuild/PKGBUILD" || { echo "Falha ao baixar PKGBUILD de $pacote"; continue; }
	makebuild
fi
done

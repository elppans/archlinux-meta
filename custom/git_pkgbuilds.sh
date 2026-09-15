#!/bin/bash

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

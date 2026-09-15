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

if [ "$(command -v nautilus)" ]; then
	sudo pacman --needed --noconfirm -S nautilus-python
fi

if ! pacman -Qq vscodeum &>>/dev/null ;then
	mkdir -p "$HOME/build/vscodeum"
	cd "$HOME/build/vscodeum" || exit 1
	wget -O PKGBUILD "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/pkgbuild/PKGBUILD" || { echo "Falha ao baixar PKGBUILD de vscodeum"; }
	makebuild
fi

if pacman -Qq vscodeum; then
	/usr/local/bin/vscodeum-extensions import vscodium "$HOME/.vscode-oss/vscodium_extensions.txt"
else
	echo -e "O pacote \"VSCodeum\" não está instalado!"
	sleep 5
fi

if command -v flatpak &>/dev/null && flatpak info com.vscodium.codium &>/dev/null; then
	flatpak override --user \
		--filesystem=~/.bin:ro \
		--filesystem=~/.local/bin:ro \
		--env=PATH="/app/bin:/usr/bin:$HOME/.bin:$HOME/.local/bin" \
		com.vscodium.codium
fi

if command -v flatpak &>/dev/null && flatpak info com.visualstudio.code &>/dev/null; then
	flatpak override --user \
		--filesystem=~/.bin:ro \
		--filesystem=~/.local/bin:ro \
		--env=PATH="/app/bin:/usr/bin:$HOME/.bin:$HOME/.local/bin" \
		com.visualstudio.code
fi

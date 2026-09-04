#!/bin/bash

nautilus-scripts() {
## Action Script, Ferramentas Nautilus
mkdir -p "$HOME"/build/nautilus-scripts
git clone https://github.com/elppans/nautilus-scripts.git "$HOME"/build/nautilus-scripts
cd "$HOME"/build/nautilus-scripts || exit 1
bash ./install.sh -D -f -K -n
}
el-images(){
## Action Script, Ferramentas de Imagens
mkdir -p "$HOME"/build/el-images
git clone https://github.com/elppans/el-images.git "$HOME"/build/el-images
cd "$HOME"/build/el-images || exit 1
bash ./install.sh
}
factions-shell(){
## Action Script, Ferramentas de Diversas
# Este Script cria o diretório "Acoes", no Action Script do Nautilus
mkdir -p "$HOME"/build/factions-shell
git clone https://github.com/elppans/factions-shell.git "$HOME"/build/factions-shell
cd "$HOME"/build/factions-shell || exit 1
bash ./install.sh
}

###
if [ "$(command -v nautilus)" ]; then
	mkdir -p "$HOME"/.local/share/nautilus/scripts
	nautilus-scripts
	el-images
else
	echo "command \"nautilus\" does not exists on system..."
fi

factions-shell

#!/bin/bash

mkdir -p "$HOME"/.local/share/nautilus/scripts

nautilus-scripts() {
## Action Script, Ferramentas Nautilus
git clone https://github.com/elppans/nautilus-scripts.git /tmp/nautilus-scripts
cd /tmp/nautilus-scripts || exit 1
bash ./install.sh -D -f -K -n
}
el-images(){
## Action Script, Ferramentas de Imagens
git clone https://github.com/elppans/el-images.git /tmp/el-images
cd /tmp/el-images || exit 1
bash ./install.sh
}
factions-shell(){
## Action Script, Ferramentas de Diversas
# Este Script cria o diretório "Acoes", no Action Script do Nautilus
git clone https://github.com/elppans/factions-shell.git /tmp/factions-shell
cd /tmp/factions-shell || exit 1
bash ./install.sh
}

###

nautilus-scripts
el-images
factions-shell

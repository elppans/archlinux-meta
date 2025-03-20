#!/bin/bash
# shellcheck disable=SC2015,SC2002,SC1072,SC1073

# Instala os seguintes pacotes para análise e formatação de código:  
# jq          Processador de JSON no terminal  
# prettier    Formatador de código para várias linguagens  
## shellcheck  Analisador estático para scripts shell  
# shfmt       Formatador para scripts shell  
# stylelint   Linter para arquivos CSS e preprocessadores como SCSS  
sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint

sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint 

# VSCodium: Versão de código aberto do Visual Studio Code (sem o rastreamento de dados)
sudo flatpak install -y flathub com.vscodium.codium && export VSCODIUM="1" || export VSCODIUM="0" 

## Configuração do VSCodium
if [ "$VSCODIUM" -eq 1 ]; then
    echo "VSCodium selecionado! Executando configuração..."
    cd || exit
    echo -e 'alias codium="flatpak run com.vscodium.codium "' | tee -a "$HOME"/.bashrc
    alias codium="flatpak run com.vscodium.codium "
    mkdir -p "$HOME/.config/VSCodium/User"
    curl -JLk -o /tmp/vscodium_backup.tar.gz "https://github.com/elppans/vscodeum/raw/refs/heads/main/vscodium_backup/vscodium_backup_20250226_170128.tar.gz"
    tar -xzf /tmp/vscodium_backup.tar.gz -C "$HOME"/.config/VSCodium/User/
    # cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 codium --install-extension
    cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 flatpak run com.vscodium.codium --install-extension
fi

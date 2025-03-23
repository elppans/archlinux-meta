#!/bin/bash

    echo "VSCodium! Executando configuração..."
    sudo chmod +x ../bin/*
    sudo cp -a ../bin/* /usr/local/bin
    mkdir -p "$HOME/.config/VSCodium/User"
    curl -JLk -o /tmp/vscodium_backup.tar.gz "https://github.com/elppans/vscodeum/raw/refs/heads/main/vscodium_backup/vscodium_backup_20250226_170128.tar.gz"
    tar -xzf /tmp/vscodium_backup.tar.gz -C "$HOME"/.config/VSCodium/User/
    cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 /usr/local/bin/codium --install-extension

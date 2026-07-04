#!/bin/bash

    echo "VSCodium! Executando configuração..."
    #sudo chmod +x ../bin/*
    #sudo cp -a ../bin/* /usr/local/bin
    #mkdir -p "$HOME/.config/VSCodium/User"
    #curl -JLk -o /tmp/vscodium_backup.tar.gz "https://github.com/elppans/vscodeum/raw/refs/heads/main/vscodium_backup/vscodium_backup_20250226_170128.tar.gz"
    #tar -xzf /tmp/vscodium_backup.tar.gz -C "$HOME"/.config/VSCodium/User/
    #cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 /usr/local/bin/codium --install-extension

	sudo rm -rf /usr/local/bin/vscodeum-extensions
	sudo curl -JLk -o /tmp/vscodium_extensions.txt "https://raw.githubusercontent.com/elppans/vscodeum-ext/refs/heads/main/vscodium_extensions.txt"
	sudo curl -JLk -o /usr/local/bin/vscodeum-extensions "https://raw.githubusercontent.com/elppans/vscodeum/refs/heads/main/usr/local/bin/vscodeum-extensions"
	sudo chmod +x /usr/local/bin/vscodeum-extensions
	sudo chmod 766 /tmp/vscodium_extensions.txt
	/usr/local/bin/vscodeum-extensions import vscodium /tmp/vscodium_extensions.txt
#!/bin/bash

# Se ao logar em um tty, ocorrer este erro:
# Failed to connect to GNOME Shell
# Failed to connect to GNOME Shell
# Failed to connect to GNOME Shell
# Deve mover para desativar a execução do mesmo:
# sudo mv /etc/profile.d/gnome-shell-extensions_manager.sh .

## Gnome Shell Extensions Manager
sudo curl -JLk -o /etc/profile.d/gnome-shell-extensions_manager.sh "https://raw.githubusercontent.com/elppans/gnome-shell-extensions_manager/refs/heads/main/gnome-shell-extensions_manager.sh"
sudo chmod +x /etc/profile.d/gnome-shell-extensions_manager.sh
mkdir -p "$HOME"/.local/share/gnome-shell
touch "$HOME"/.local/share/gnome-shell/extensions.list
echo -e 'caffeine@patapon.info
appindicatorsupport@rgcjonas.gmail.com' | tee "$HOME"/.local/share/gnome-shell/extensions.list
cat "$HOME"/.local/share/gnome-shell/extensions.list

#!/bin/bash

## Gnome Shell Extensions Manager
sudo curl -JLk -o /etc/profile.d/gnome-shell-extensions_manager.sh "https://raw.githubusercontent.com/elppans/gnome-shell-extensions_manager/refs/heads/main/gnome-shell-extensions_manager.sh"
sudo chmod +x /etc/profile.d/gnome-shell-extensions_manager.sh
mkdir -p "$HOME"/.local/share/gnome-shell
touch "$HOME"/.local/share/gnome-shell/extensions.list
echo -e 'caffeine@patapon.info
appindicatorsupport@rgcjonas.gmail.com
user-theme@gnome-shell-extensions.gcampax.github.com' | tee "$HOME"/.local/share/gnome-shell/extensions.list
cat "$HOME"/.local/share/gnome-shell/extensions.list

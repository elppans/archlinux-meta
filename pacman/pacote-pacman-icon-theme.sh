#!/bin/bash

# Tema de ícones
# obsidian-icon-theme -> Tema de ícones Obsidian baseado no Papirus  
# cutefish-icons      -> Conjunto de ícones do ambiente Cutefish  
sudo pacman --needed --noconfirm -S obsidian-icon-theme
# sudo pacman --needed --noconfirm -S cutefish-icons

gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"

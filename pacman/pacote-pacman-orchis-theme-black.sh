#!/bin/bash

# Tema Orchis
# orchis-theme                    -> Tema moderno para GTK e GNOME Shell  
# tela-circle-icon-theme-black    -> Variante preta do conjunto de ícones Tela Circle  
# vimix-cursors                   -> Tema de cursores Vimix  
sudo pacman --needed --noconfirm -S orchis-theme
sudo pacman --needed --noconfirm -S tela-circle-icon-theme-black
sudo pacman --needed --noconfirm -S vimix-cursors

# Temas do usuário
gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"

## Temas e Configurações GDM
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
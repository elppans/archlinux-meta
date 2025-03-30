#!/bin/bash

# Instala temas e ícones para personalização do GNOME:  
# gnome-themes-extra          -> Conjunto de temas adicionais para GTK  
# orchis-theme                -> Tema moderno para GTK e GNOME Shell  
# tela-circle-icon-theme-all  -> Conjunto de ícones Tela Circle  
# vimix-cursors               -> Tema de cursores Vimix  
sudo pacman --needed --noconfirm -S gnome-themes-extra orchis-theme tela-circle-icon-theme-all vimix-cursors

## Temas e Configurações GDM
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"

#!/bin/bash

# Configurações gerais do Gnome
gsettings set org.gnome.Console transparency true
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface show-battery-percentage true
# gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.shell.weather automatic-location true
gsettings set org.gnome.shell.extensions.window-list grouping-mode 'auto'
gsettings set org.gnome.shell always-show-log-out true

# Configurações gerais do Mutter
gsettings set org.gnome.mutter center-new-windows true # Centralizar janelas novas
# gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer', 'variable-refresh-rate']" # Ativar escala fracionada e VRR no Wayland


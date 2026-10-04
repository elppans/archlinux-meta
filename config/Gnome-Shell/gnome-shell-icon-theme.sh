#!/bin/bash

# Gravação via gsettings com fallback direto no dconf para tema de ícone
gtk-update-icon-cache -f -t /usr/share/icons/kora 2>/dev/null || true # Atualizar o cache do diretório exato
gsettings set org.gnome.desktop.interface icon-theme 'kora'
dconf write /org/gnome/desktop/interface/icon-theme "'kora'"
# Ps.: Adicionado parâmetros na Sessão  "pacotes/pacman.ini"
# Ps.2: Criação de regra de lock no dconf para icon-theme
# Ps.3: Deve verificar o nome do diretório do ícone e adicionar o nome exato no comando gsettings: ls -d /usr/share/icons/

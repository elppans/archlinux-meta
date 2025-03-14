#!/bin/bash

# Instalação do Gnome Shell e Ferramentas
# Atualização do sistema e instalação dos pacotes

# Gnome Meta Install
# sudo pacman --needed --noconfirm -Syyu gnome gnome-tweaks htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant xdg-utils

# Gnome Minimal install:

# Para completar o Gnome, deve usar o Script versão "pós install"

# GDM: gerenciador de login,
# gnome-console: terminal do GNOME,
# gnome-control-center: configurações do sistema,
# gnome-shell: interface gráfica,
# gnome-system-monitor: monitor de processos,
# xdg-utils: ferramentas de integração de apps

sudo pacman --needed -Syu gdm gnome-console gnome-control-center gnome-shell gnome-system-monitor xdg-utils \
htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant
sudo systemctl enable gdm
xdg-user-dirs-update


# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Configurações da Barra Superior
# Para mostrar a data e os segundos na barra superior
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Display manager, gerenciador de login
# ./display-manager-gdm_instalar.sh
sudo pacman --needed --noconfirm -Syyu gdm
sudo systemctl disable "$(systemctl status display-manager.service | head -n1 | awk '{print $2}')" &>>/dev/null
sudo systemctl enable gdm.service

# Pós install


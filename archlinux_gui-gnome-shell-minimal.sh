#!/bin/bash

# Gnome Minimal install:

# Atualiza a lista de pacotes e executa uma atualização completa do sistema
# Instala os seguintes pacotes:
# gdm                  -> Gerenciador de exibição do GNOME
# gnome-console        -> Terminal moderno do GNOME
# gnome-control-center -> Configurações do sistema do GNOME
# gnome-shell          -> Interface gráfica principal do GNOME
# gnome-system-monitor -> Monitor de recursos do sistema
# xdg-utils            -> Ferramentas para integração de aplicativos com o ambiente gráfico
# htop                 -> Monitor de processos interativo
# iwd                  -> Gerenciador de conexões Wi-Fi da Intel
# nano                 -> Editor de texto simples para terminal
# openssh              -> Implementação do protocolo SSH para acesso remoto seguro
# smartmontools        -> Ferramentas para diagnóstico e monitoramento de discos
# vim                  -> Editor de texto avançado no terminal
# wget                 -> Ferramenta para download via HTTP, HTTPS e FTP
# wireless_tools       -> Conjunto de ferramentas para gerenciar conexões Wi-Fi
# wpa_supplicant       -> Gerenciador de autenticação Wi-Fi

# Para completar o Gnome, deve usar o Script versão "MINIMAL Pós Install"

sudo pacman --needed --noconfirm -Syyu gdm gnome-console gnome-control-center gnome-shell gnome-system-monitor xdg-utils \
htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant


# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Configurações da Barra Superior
# Para mostrar a data e os segundos na barra superior
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Ativação do Display manager (Gerenciador de Login)
sudo systemctl disable "$(systemctl status display-manager.service | head -n1 | awk '{print $2}')" &>>/dev/null
sudo systemctl enable gdm.service

# Seguir para "MINIMAL Pós Install"


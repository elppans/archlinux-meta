#!/bin/bash

# Gnome Meta Install

# Instalação do Gnome Shell e Ferramentas

# Atualiza a lista de pacotes e executa uma atualização completa do sistema  
# Instalando os seguintes pacotes:  
# - gnome: Ambiente gráfico GNOME completo  
# - gnome-tweaks: Ferramenta para ajustes adicionais no GNOME  
# - htop: Monitor de processos interativo no terminal  
# - iwd: Gerenciador de conexões Wi-Fi da Intel  
# - nano: Editor de texto simples para terminal  
# - openssh: Implementação do protocolo SSH para acesso remoto seguro  
# - smartmontools: Ferramentas para monitoramento e diagnóstico de discos rígidos  
# - vim: Editor de texto avançado no terminal  
# - wget: Ferramenta para download de arquivos via HTTP, HTTPS e FTP  
# - wireless_tools: Conjunto de ferramentas para gerenciar conexões Wi-Fi  
# - wpa_supplicant: Gerenciador de autenticação Wi-Fi  
# - xdg-utils: Ferramentas para integração de aplicativos com o ambiente gráfico  

# Para completar o Gnome, deve usar o Script versão "META Pós Install"

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

# Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland
sudo pacman --needed --noconfirm -Syyu xorg-xwayland xorg-xlsclients glfw-wayland
sudo pacman --needed --noconfirm -Syyu libinput wayland wayland-protocols

# Instalando Gnome Shell (Meta)
sudo pacman --needed --noconfirm -Syyu gnome gnome-tweaks htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant xdg-utils

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Configurações da Barra Superior
# Para mostrar a data e os segundos na barra superior
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Ativação do Display manager (Gerenciador de Login)
sudo systemctl disable "$(systemctl status display-manager.service | head -n1 | awk '{print $2}')" &>>/dev/null
sudo systemctl enable gdm.service

# Seguir para "META Pós Install"


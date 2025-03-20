#!/bin/bash

# Instala o pacote game-devices-udev, que fornece regras udev para dispositivos de jogo (como controle, joystick, etc.)  
# Dependẽncia para Steam versão Flatpak
paru --needed --noconfirm -S game-devices-udev

# Instala o Steam (plataforma de jogos) via Flatpak a partir do repositório Flathub  
sudo flatpak install -y flathub com.valvesoftware.Steam

# Instala o Protontricks (ferramenta para configurar jogos Steam com Proton) via Flatpak a partir do repositório Flathub  
sudo flatpak install -y flathub com.github.Matoking.protontricks


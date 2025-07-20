#!/bin/bash

# Instalação do Display manager (Gerenciador de Login)
sudo pacman --needed --noconfirm -Syu gdm

# Ativação do Display manager (Gerenciador de Login)
systemctl is-enabled display-manager.service && sudo systemctl disable display-manager.service
systemctl is-enabled gdm.service || sudo systemctl enable gdm.service

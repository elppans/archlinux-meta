#!/bin/bash

# Demais aplicações

# Instala o Wine Staging, versão de teste do Wine com patches extras.
# Instala o Winetricks, ferramenta para gerenciar bibliotecas e configurações no Wine.
sudo pacman --needed --noconfirm -S \
wine-staging \
winetricks

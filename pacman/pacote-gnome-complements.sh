#!/bin/bash
# shellcheck disable=SC2027,SC2046

## Complementos para o GNOME

# Instala o daemon para gerenciar perfis de energia.
# Instala o File Roller, gerenciador de arquivos compactados.
# Instala as dependências opcionais do File Roller.
# Suporte a indicadores de aplicativos no GNOME Shell.
# Impede que a tela desligue ou entre em suspensão.
# Redimensionar e girar imagens pelo Nautilus.
# Compartilha pastas via Samba pelo Nautilus.

sudo pacman --needed --noconfirm -S \
power-profiles-daemon \
file-roller \
""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')"" \
gnome-shell-extension-appindicator \
gnome-shell-extension-caffeine \
nautilus-image-converter \
nautilus-share

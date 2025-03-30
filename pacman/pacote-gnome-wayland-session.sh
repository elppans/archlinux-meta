#!/bin/bash

# Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland:

# Instala o XWayland, ferramenta xlsclients e biblioteca glfw com suporte ao Wayland.
# Instala a biblioteca libinput, o protocolo Wayland e os protocolos adicionais para comunicação no Wayland.
# Instala os portais do XDG para compatibilidade com Wayland e GNOME, incluindo suporte específico para o GNOME.

sudo pacman --needed --noconfirm -S  \
xorg-xwayland xorg-xlsclients glfw-wayland \
libinput wayland wayland-protocols \
xdg-desktop-portal xdg-desktop-portal-gnome

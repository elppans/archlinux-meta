#!/bin/bash

# Tema Yaru

# Atualiza a lista de pacotes e instala os seguintes pacotes via Paru:  
# inkscape                 -> Editor de gráficos vetoriais  
# xorg-server-xvfb         -> Servidor X virtual framebuffer (Xvfb)  
# yaru-gnome-shell-theme   -> Tema Yaru para o GNOME Shell  
# yaru-gtk-theme           -> Tema Yaru para aplicativos GTK  
# yaru-icon-theme          -> Tema de ícones Yaru  
# yaru-metacity-theme      -> Tema Yaru para Metacity (gerenciador de janelas)  
# yaru-session             -> Sessão do GNOME com o tema Yaru  
# yaru-sound-theme         -> Tema de sons Yaru  
# yaru-unity-theme         -> Tema Yaru inspirado no Unity  
# yaru-xfwm4-theme         -> Tema Yaru para o XFWM4 (gerenciador de janelas do Xfce)  
paru --needed --noconfirm -Syyu --batchinstall --skipreview --removemake --mflags -Cris inkscape xorg-server-xvfb \
yaru-gnome-shell-theme yaru-gtk-theme yaru-icon-theme yaru-metacity-theme yaru-session yaru-sound-theme yaru-unity-theme yaru-xfwm4-theme

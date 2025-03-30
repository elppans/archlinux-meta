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
# yaru-unity-theme         -> Tema Yaru inspirado no Unity  # REMOVIDO
# yaru-xfwm4-theme         -> Tema Yaru para o XFWM4 (gerenciador de janelas do Xfce)  # REMOVIDO
paru --needed --noconfirm -Syyu --batchinstall --skipreview --removemake --mflags -Cris inkscape xorg-server-xvfb \
yaru-gnome-shell-theme yaru-gtk-theme yaru-icon-theme yaru-metacity-theme yaru-session yaru-sound-theme

gsettings set org.gnome.shell.extensions.user-theme name "Yaru-dark"
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue-dark"
gsettings set org.gnome.desktop.sound theme-name "Yaru"

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue-dark"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Yaru"

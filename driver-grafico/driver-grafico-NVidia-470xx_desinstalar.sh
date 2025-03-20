#!/bin/bash

# Instalação do pacote NVidia

yay -Rsunc nvidia-470xx-utils lib32-nvidia-470xx-utils

# Configuração do Módulo para HOOK

sudo cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bkp_"$(date +%d%m%H%M)"
sudo sed -i 's/nvidia nvidia_modeset nvidia_uvm nvidia_drm//' /etc/mkinitcpio.conf

sudo /usr/bin/mkinitcpio -P



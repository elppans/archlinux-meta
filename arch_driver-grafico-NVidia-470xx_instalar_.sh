#!/bin/bash

# Instalação do pacote NVidia

yay -S --needed nvidia-470xx-dkms nvidia-470xx-utils lib32-nvidia-470xx-utils

# Configuração do Módulo para HOOK

sudo cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bkp_"$(date +%d%m%H%M)"
grep 'nvidia nvidia_modeset nvidia_uvm nvidia_drm' /etc/mkinitcpio.conf && echo "Modulos para NVidia Hook OK!" || sudo sed -i '/MODULES=/s/(/(nvidia nvidia_modeset nvidia_uvm nvidia_drm/' /etc/mkinitcpio.conf

sudo /usr/bin/mkinitcpio -P

# Solução para Flickering

echo -e 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/tmp' | sudo tee /etc/modprobe.d/nvidia-power-management.conf
sudo systemctl enable nvidia-suspend.service nvidia-hibernate.service


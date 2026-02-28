#!/bin/bash

# Lightdm com tema todo preto no login, este não tem pacote "-settings"
# sudo pacman -S lightdm-slick-greeter

# lightdm-gtk-greeter é um tema ainda mais simples, mas editável, usando o apcote "-settings"
sudo pacman --needed -S lightdm-gtk-greeter-settings
# shellcheck disable=SC2046
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable lightdm.service


#!/bin/bash

sudo pacman -S --needed steam
sudo sed -i '/en_US.UTF-8 UTF-8/s/#//' /etc/locale.gen
echo 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' >> ~/.pam_environment
grep 'STEAM_FRAME_FORCE_CLOSE' /etc/environment && echo "Steam force close OK!" || echo 'STEAM_FRAME_FORCE_CLOSE=1' | sudo tee -a /etc/environment

mkdir -p ~/.config/autostart
cp -a /usr/share/applications/steam.desktop ~/.config/autostart
chmod +x ~/.config/autostart/steam.desktop


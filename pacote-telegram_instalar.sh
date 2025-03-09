#!/bin/bash

sudo pacman -S --needed telegram-desktop

mkdir -p ~/.local/share/applications
cp -rf /usr/share/applications/org.telegram.desktop.desktop ~/.local/share/applications/org.telegram.desktop.desktop
sed -i '/Exec/s/\%u/\%u --hideStart/' ~/.local/share/applications/org.telegram.desktop.desktop
cp -rf ~/.local/share/applications/org.telegram.desktop.desktop ~/.config/autostart/org.telegram.desktop.desktop
chmod +x ~/.config/autostart/org.telegram.desktop.desktop


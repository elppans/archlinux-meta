#!/bin/bash

yay -S zapzap

cp -rf /usr/share/applications/com.rtosta.zapzap.desktop ~/.local/share/applications/com.rtosta.zapzap.desktop
sed -i '/Exec/s/\%u/\%u --hideStart/' ~/.local/share/applications/com.rtosta.zapzap.desktop
cp -rf ~/.local/share/applications/com.rtosta.zapzap.desktop ~/.config/autostart/com.rtosta.zapzap.desktop
chmod +x ~/.config/autostart/com.rtosta.zapzap.desktop

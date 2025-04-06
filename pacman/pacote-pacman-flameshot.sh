#!/bin/bash
# shellcheck disable=SC2016,SC2027,SC2046

sudo pacman --noconfirm -R xf86-video-intel 
sudo pacman --needed --noconfirm -S flameshot
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" flameshot | tr ' ' '\n')""  

# Flameshot em Wayland (Movido para o diretório bin)
# echo -e '#!/bin/bash

# options=("$@")
# export QT_QPA_PLATFORM=wayland
# export QT_SCREEN_SCALE_FACTORS="1;1"

# /usr/bin/flameshot "${options[@]}"
# ' | sudo tee /usr/local/bin/flameshot

sudo cp -a /usr/share/applications/org.flameshot.Flameshot.desktop /etc/skel/.local/share/applications
sudo sed -i 's|/usr/bin/flameshot|/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
sudo sed -i 's|Exec=flameshot|Exec=/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
cp -a /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop "$HOME/.local/share/applications"

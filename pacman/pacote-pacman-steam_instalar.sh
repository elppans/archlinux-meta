#!/bin/bash
# shellcheck disable=SC2015

sudo pacman -S --needed \
steam-native-runtime \
xf86-video-amdgpu xf86-video-ati xf86-video-intel \
lib32-fontconfig ttf-liberation wqy-zenhei \
lib32-systemd

mkdir -p "$HOME/.config/autostart/"
cp -av /usr/share/applications/steam-native.desktop "$HOME/.config/autostart/"
sed -i 's|Exec=/usr/bin/steam-native %U|Exec=/usr/bin/steam-native %U -silent|' "$HOME/.config/autostart/steam-native.desktop"

sudo sed -i '/en_US.UTF-8 UTF-8/s///' /etc/locale.gen
grep 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' "$HOME/.pam_environment" && echo "Steam pam_environment OK!" || echo 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' >> "$HOME/.pam_environment"
grep 'STEAM_FRAME_FORCE_CLOSE' "/etc/environment" && echo "Steam force close OK!" || echo 'STEAM_FRAME_FORCE_CLOSE=1' | sudo tee -a "/etc/environment"




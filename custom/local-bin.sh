#!/bin/bash

# Scripts/Comandos customizados em bin local
# shellcheck disable=SC2154,SC2016
chmod +x "$install"/bin/*
sudo cp -a "$install"/bin/* /usr/local/bin

#
if [ ! -f /usr/local/bin/faceconv.sh ]; then
	sudo curl -JLk -o "/usr/local/bin/faceconv.sh" "https://raw.githubusercontent.com/elppans/sddm-silent-customizer/refs/heads/main/usr/local/bin/faceconv"
	sudo chmod +x "/usr/local/bin/faceconv.sh"
fi

# Prompt minimalista, incrivelmente rápido e infinitamente personalizável para qualquer Shell!
# https://starship.rs/guide/
if pacman -Qqs starship; then
	if [ -f "$HOME"/.bashrc ]; then
		grep -q "starship init bash" "$HOME"/.bashrc || echo -e 'eval "$(starship init bash)"' | tee -a "$HOME"/.bashrc
	else
		cp -a /etc/.bashrc "$HOME"/.bashrc
		grep -q "starship init bash" "$HOME"/.bashrc || echo -e 'eval "$(starship init bash)"' | tee -a "$HOME"/.bashrc
	fi
fi

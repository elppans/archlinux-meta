#!/bin/bash

# Scripts/Comandos customizados em bin local
# shellcheck disable=SC2154,SC2016

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

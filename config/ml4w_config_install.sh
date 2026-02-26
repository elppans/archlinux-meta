#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo
mkdir -p "$HOME"/.backup_dotfiles
cp -rf "$HOME"/.config "$HOME"/.backup_dotfiles
rsync -ah "$mk4wlo/ML4W/.config/"  "$HOME/.config/" && \
echo "Copiado .config para $HOME/.config!" || \
echo "Não foi possível copiar .config para $HOME/.config!" && exit 1


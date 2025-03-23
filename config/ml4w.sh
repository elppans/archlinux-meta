#!/bin/bash

mkdir -p "$HOME"/.backup_dotfiles
cp -rf "$HOME"/.config "$HOME"/.backup_dotfiles
cp -rf ML4W/.config/hypr/*  "$HOME"/.config/hypr/

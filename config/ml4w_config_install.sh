#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo
mkdir -p "$HOME"/.backup_dotfiles
cp -rf "$HOME"/.config "$HOME"/.backup_dotfiles
cp -rf "$mk4wlo/ML4W/.config/*"  "$HOME/.config/"


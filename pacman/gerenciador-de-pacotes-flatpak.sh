#!/bin/bash

# Gerenciador de pacotes Flatpak

sudo pacman --needed --noconfirm -S flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

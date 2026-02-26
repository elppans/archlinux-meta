#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo

sudo pacman -Sy --needed xdg-user-dirs swappy satty
tar -zxf "$mk4wlo/hyde_bin/hyde_bin.tar.gz" -C "$HOME/.config" && \
echo "Instalação do pacote hyde_bin finalizado!" || \
echo "Não foi possível instalar o pacote hyde_bin!" && exit 1

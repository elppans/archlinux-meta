#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo

sudo pacman -Sy --needed xdg-user-dirs swappy satty
tar -zxvf "$mk4wlo/hyde_bin.tar.gz" -C "$HOME/.config"

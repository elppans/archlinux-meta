#!/bin/bash

cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -Cris -L --needed --noconfirm


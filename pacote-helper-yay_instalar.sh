#!/bin/bash

git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -Cris -L --needed --noconfirm


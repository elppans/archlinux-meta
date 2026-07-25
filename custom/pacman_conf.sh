#!/usr/bin/env bash

sudo bash -c '
if grep -q "^ILoveCandy" /etc/pacman.conf; then
    echo "Opção ILoveCandy está ativo."
elif grep -q "^#\s*ILoveCandy" /etc/pacman.conf; then
    sed -i "s/^#\s*ILoveCandy/ILoveCandy/" /etc/pacman.conf
    echo "Opção ILoveCandy descomentada."
else
    sed -i "/^\[options\]/a ILoveCandy" /etc/pacman.conf
    echo "Opção ILoveCandy adicionada sob [options]."
fi
'
sudo bash -c '
if grep -q "^Color" /etc/pacman.conf; then
    echo "Opção Color está ativo."
elif grep -q "^#\s*Color" /etc/pacman.conf; then
    sed -i "s/^#\s*Color/Color/" /etc/pacman.conf
    echo "Opção Color descomentada."
else
    sed -i "/^\[options\]/a Color" /etc/pacman.conf
    echo "Opção Color adicionada sob [options]."
fi
'
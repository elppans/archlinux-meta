#!/bin/bash

CONFIG_FILE="/etc/pacman.conf"
export CONFIG_FILE

# Verifica se o repositório multilib já está habilitado (sem comentário)
if ! grep -q "^\[multilib\]" "$CONFIG_FILE"; then
    echo "Habilitando o repositório [multilib]..."
    # Usa o sed para descomentar a seção [multilib] e a linha Include imediatamente abaixo
    # A lógica procura pela linha #[multilib] e remove o # dela e da linha seguinte
    sudo sed -i '/#\[multilib\]/,+1 s/^#//' "$CONFIG_FILE"
fi

# Atualizaçao de repositório
sudo pacman -Sy
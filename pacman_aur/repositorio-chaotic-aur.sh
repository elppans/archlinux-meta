#!/bin/bash

# Cores
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AZUL="\033[0;34m"
AMARELO="\033[0;33m"
PADRAO="\033[0m"

echo -e "${AZUL}Deseja ativar o repositório chaotic-aur? (y/n) [n padrão]${PADRAO}"
read -r resposta

# Define 'n' como padrão se ENTER for pressionado sem entrada
resposta=${resposta:-n}

if [[ $resposta == "y" || $resposta == "Y" ]]; then
    echo -e "${VERDE}Ativando o repositório chaotic-aur...${PADRAO}"
    sudo curl -JLk -o /usr/local/bin/chaotic-aur https://raw.githubusercontent.com/HyDE-Project/HyDE/refs/heads/master/Scripts/chaotic_aur.sh
    sudo chmod +x /usr/local/bin/chaotic-aur
    sudo /usr/local/bin/chaotic-aur --install
    echo -e "${VERDE}Repositório instalado com sucesso!${PADRAO}"
elif [[ $resposta == "n" || $resposta == "N" ]]; then
    echo -e "${AMARELO}O repositório chaotic-aur não foi ativado.${PADRAO}"
else
    # echo -e "${VERMELHO}Opção inválida. Por favor, responda com 'y' ou 'n'.${PADRAO}"
    echo -e "${VERMELHO}O repositório chaotic-aur não será ativado.${PADRAO}"
fi

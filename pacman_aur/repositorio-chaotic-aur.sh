#!/bin/bash

echo "Deseja ativar o repositório chaotic-aur? (y/N) [N padrão]"
read -r resposta

# Define 'n' como padrão se ENTER for pressionado sem entrada
resposta=${resposta:-n}

if [[ $resposta == "y" || $resposta == "Y" ]]; then
    echo "Ativando o repositório chaotic-aur..."
    curl -JLk -o /usr/local/bin/chaotic-aur https://raw.githubusercontent.com/HyDE-Project/HyDE/refs/heads/master/Scripts/chaotic_aur.sh
    sudo chmod +x /usr/local/bin/chaotic-aur
    sudo chaotic-aur --install
    echo "Repositório instalado com sucesso!"
elif [[ $resposta == "n" || $resposta == "N" ]]; then
    echo "O repositório chaotic-aur não foi ativado."
else
    echo "Opção inválida. Por favor, responda com 'y' ou 'n'."
fi

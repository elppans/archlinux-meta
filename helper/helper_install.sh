#!/bin/bash

# Função para verificar se o programa está instalado
verificar_helper() {
    if command -v yay &> /dev/null; then
        export HELPER="yay"
    elif command -v paru &> /dev/null; then
        export HELPER="paru"
    else
        escolher_helper
    fi
}

# Função para escolher e instalar o gerenciador de pacotes
escolher_helper() {
    echo "Qual gerenciador de pacotes você deseja instalar?"
    echo "1) yay"
    echo "2) paru"
    read -r -p "Digite o número correspondente: " escolha

    case $escolha in
        1)
            echo "Instalando yay..."
            bash pacote-helper-yay.sh
            export HELPER="yay"
            ;;
        2)
            echo "Instalando paru..."
            bash pacote-helper-paru.sh
            export HELPER="paru"
            ;;
        *)
            echo "Escolha inválida. Por favor, tente novamente."
            escolher_helper
            ;;
    esac
}
    # Verificando Helper e instalando, caso necessário
    verificar_helper
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
    echo "y) yay (RECOMENDADO)"
    echo "p) paru"
    read -r -p "Digite a opção correspondente (Padrão: \"Y\"): " escolha

    case $escolha in
        y|Y)
            echo "Instalando yay..."
            bash pacote-helper-yay.sh
            export HELPER="yay"
            ;;
        p|P)
            echo "Instalando paru..."
            bash pacote-helper-paru.sh
            export HELPER="paru"
            ;;
        *)
            echo "Escolha inválida. Por favor, tente novamente."
            # escolher_helper
			export HELPER="yay"
            ;;
    esac
}
    # Verificando Helper e instalando, caso necessário
    verificar_helper
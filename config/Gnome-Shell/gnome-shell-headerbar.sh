#!/bin/bash

# Define o estilo CSS para reduzir o tamanho da barra
CSS_CONTENT="headerbar, headerbar.titlebar {
    padding-top: 0px;
    padding-bottom: 0px;
    min-height: 24px;
}

headerbar entry,
headerbar button {
    padding-top: 0px;
    padding-bottom: 0px;
    min-height: 20px;
}"

# Loop para aplicar no GTK 3 e GTK 4
for versao in "3.0" "4.0"
do
    DIR="$HOME/.config/gtk-$versao"
    FILE="$DIR/gtk.css"

    # Cria o diretório se não existir
    mkdir -p "$DIR"

    # Adiciona o conteúdo ao arquivo (sem apagar o que já existe)
    echo -e "\n/* Ajuste de barra de titulo */\n$CSS_CONTENT" >> "$FILE"
    
    echo "Configuração aplicada para GTK $versao em: $FILE"
done

echo "Ajuste finalizado! Para as mudanças fazerem efeito, encerre a sessão (Log out) e entre novamente."

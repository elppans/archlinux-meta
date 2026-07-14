#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/Kvantum/kvantum.kvconfig"
DESIRED_THEME="KvLibadwaitaDark" # "KvLibadwaita"

# Garante a existência do arquivo de configuração
mkdir -p "$(dirname "$CONFIG_FILE")"
touch "$CONFIG_FILE"

# Obtém o tema atual de forma segura
CURRENT_THEME=$(sed -n 's/^theme=\(.*\)/\1/p' "$CONFIG_FILE")

if [ "$CURRENT_THEME" != "$DESIRED_THEME" ]; then
    echo "Configurando o tema do Kvantum para $DESIRED_THEME..."
    
    # Remove qualquer linha de tema duplicada e redefine sob [General]
    sed -i '/^theme=/d' "$CONFIG_FILE"
    if ! grep -q "^\[General\]" "$CONFIG_FILE"; then
        echo -e "[General]\ntheme=$DESIRED_THEME" >> "$CONFIG_FILE"
    else
        sed -i "/^\[General\]/a theme=$DESIRED_THEME" "$CONFIG_FILE"
    fi
else
    echo "Kvantum já está configurado com o tema $DESIRED_THEME."
fi
#!/bin/bash

## Action Script, conversão de imagens
git clone https://github.com/elppans/nautilus-scripts.git /tmp/nautilus-scripts
cd /tmp/nautilus-scripts || exit 1

SCRIPT_PATH="install.sh"
BACKUP_PATH="${SCRIPT_PATH}.bak"

# Faz backup
cp "$SCRIPT_PATH" "$BACKUP_PATH"

# Usa awk para editar apenas o bloco do menu_defaults
awk '
BEGIN { in_block = 0; count = 0 }
{
    if ($0 ~ /menu_defaults=\(/) {
        in_block = 1
        count = 0
    }
    if (in_block && $0 ~ /"false"/) {
        count++
        if (count == 2) {  # Altere para 1 se quiser mudar o primeiro false
            sub(/"false"/, "\"true\"")
        }
    }
    if (in_block && $0 ~ /\)/) {
        in_block = 0
    }
    print
}' "$BACKUP_PATH" > "$SCRIPT_PATH"

# echo "Feito! A última opção do menu_defaults foi alterada para true."


# Fazendo instalação do Action Scripts
bash ./install.sh
# cd || exit 1

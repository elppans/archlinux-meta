#!/bin/bash

## Action Script, conversão de imagens
git clone https://github.com/elppans/nautilus-scripts.git /tmp/nautilus-scripts
cd /tmp/nautilus-scripts || exit 1

# Caminho para o script original
SCRIPT_PATH="install.sh"

# Faz backup antes de modificar
cp "$SCRIPT_PATH" "${SCRIPT_PATH}.bak"

# Usa sed para modificar a quinta linha dentro do bloco menu_defaults
# Encontra o bloco e substitui apenas a última linha "false" por "true"
sed -i '/menu_defaults=(/,/)/s/"false"/"true"/5' "$SCRIPT_PATH"

echo "Modificação concluída! O arquivo original foi salvo como ${SCRIPT_PATH}.bak"

# Fazendo instalação do Action Scripts
bash ./install.sh
# cd || exit 1

#!/bin/bash

# Caminho do arquivo
CONFIG_FILE="/etc/pacman.conf"

# Verifica root
if [[ $EUID -ne 0 ]]; then
   echo "Erro: Execute como root (sudo)."
   exit 1
fi

echo "Iniciando a remoção do Chaotic-AUR..."

# 1. Remove as linhas do repositório no pacman.conf
# O sed vai buscar o bloco que começa com [chaotic-aur] e apagar 2 linhas (o nome e o Include)
if grep -q "\[chaotic-aur\]" "$CONFIG_FILE"; then
    sed -i '/\[chaotic-aur\]/,+1d' "$CONFIG_FILE"
    echo "✓ Entrada do Chaotic-AUR removida do pacman.conf."
else
    echo "! Repositório [chaotic-aur] não encontrado no pacman.conf."
fi

# 2. Remove os pacotes de chaves e mirrorlist do Chaotic
# Isso evita erros de chaves órfãs no futuro
echo "Removendo pacotes de suporte (keyring e mirrorlist)..."
pacman -Rs chaotic-keyring chaotic-mirrorlist --noconfirm 2>/dev/null

# 3. Atualiza a base de dados para refletir as mudanças
echo "Sincronizando base de dados do pacman..."
pacman -Syy

echo "---"
echo "Concluído! O Chaotic-AUR foi removido e a lista de pacotes atualizada."
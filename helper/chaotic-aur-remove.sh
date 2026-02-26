#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
	echo "Quando necessário, será pedido a senha administrativa!"
    exit 1
fi

# Caminho do arquivo
CONFIG_FILE="/etc/pacman.conf"

echo "Iniciando a remoção do Chaotic-AUR..."

# 1. Remove as linhas do repositório no pacman.conf
# O sed vai buscar o bloco que começa com [chaotic-aur] e apagar 2 linhas (o nome e o Include)
if grep -q "\[chaotic-aur\]" "$CONFIG_FILE"; then
	sudo sed -i '/\[chaotic-aur\]/,+1d' "$CONFIG_FILE"
	echo "✓ Entrada do Chaotic-AUR removida do pacman.conf."
else
	echo "! Repositório [chaotic-aur] não encontrado no pacman.conf."
fi

# 2. Remove os pacotes de chaves e mirrorlist do Chaotic
# Isso evita erros de chaves órfãs no futuro
echo "Removendo pacotes de suporte (keyring e mirrorlist)..."
sudo pacman -Rs chaotic-keyring chaotic-mirrorlist --noconfirm 2>/dev/null

# 3. Atualiza a base de dados para refletir as mudanças
echo "Sincronizando base de dados do pacman..."
sudo pacman -Syy

echo "---"
echo "Concluído! O Chaotic-AUR foi removido e a lista de pacotes atualizada."

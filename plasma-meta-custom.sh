#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
	echo "Erro: Este script não deve ser executado como superusuário (root)."
	echo "Por favor, execute como um usuário normal."
	exit 1
fi

# Plasma Meta Packages

if ! pacman -Qs plasma-desktop >/dev/null; then
	echo -e "O pacote plasma-desktop não está instalado...\n\
Utilize o script \"plasma-meta.sh\" e reinicie o sistema.\n\
Após logar, abra o terminal e execute novamente a instalação!" >&2
	exit 1
fi

# ------------------------------------------------------------------------------
# Ativar o Chaotic AUR
# ------------------------------------------------------------------------------
# Baixa o script diretamente do GitHub, executa a instalação e remove o arquivo
# temporário utilizado durante o processo.
#
# OBSERVAÇÃO:
# A execução do Script pergunta por padrão se quer ativar o repositório ou não.
# Então não há necessidade de ativar a linha deste Script
#
# tmp=$(mktemp) && wget -qO "$tmp" 'https://elppans.github.io/archlinux-meta/helper/chaotic-aur_hyde.sh' && sudo bash "$tmp" --install; rm -f "$tmp"

bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/helper/pacote-helper-yay.sh')
bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-pacman')
bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-flatpak')
bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-custom')


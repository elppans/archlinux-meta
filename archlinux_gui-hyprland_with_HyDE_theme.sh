#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

main() {
    echo "Escolha uma opção:"
    echo "1 - Apenas instalar o tema HyprDE"
    echo "2 - Instalar o tema HyprDE com aplicativos preferenciais"
    read -r -p "Digite o número da opção desejada: " choice

    case $choice in
        1)
            # Instalar o tema HyprDE
			./install.sh
            ;;
        2)
            # Instalar o tema HyprDE com aplicativos preferenciais
			./install.sh pkg_user.lst
            ;;
        *)
            echo "Escolha uma das opções!"
            sleep 3
            main
            ;;
    esac
}

# Função para verificar se o programa está instalado
verificar_helper() {
    if command -v yay &> /dev/null; then
        echo "O 'yay' está instalado!"
    elif command -v paru &> /dev/null; then
        echo "O 'paru' está instalado!"
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
            git clone https://aur.archlinux.org/yay.git /tmp/yay
            cd  /tmp/yay || exit 1
            makepkg --needed --noconfirm -Cris
            ;;
        2)
            echo "Instalando paru..."
            git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
            cd /tmp/paru-bin || exit 1
            makepkg --needed --noconfirm -Cris
            ;;
        *)
            echo "Escolha inválida. Por favor, tente novamente."
            escolher_helper
            ;;
    esac
}

if pacman -Qqs hyprland ; then
    # Pacotes essenciais para desenvolvimento (Garantindo que estejam instalados)
    sudo pacman --needed --noconfirm -S git base-devel
    # Verificando Helper e instalando, caso necessário
    verificar_helper
    # Utilitários Recomendados (Garantindo que estejam instalados)
    sudo pacman --needed --noconfirm -S hyprutils nwg-displays
	# The HyDE Dotfiles for Hyprland
	git clone --depth 1 https://github.com/HyDE-Project/HyDE "$HOME"/HyDE
	touch "$HOME"/.hidden
	grep 'HyDE' "$HOME"/.hidden || echo 'HyDE' >> "$HOME"/.hidden
	cd "$HOME"/HyDE/Scripts || exit 1
	cp -f "$HOME"/HyDE/Scripts/pkg_extra.lst "$HOME"/HyDE/Scripts/pkg_user.lst

	# Ativar instalação do VSCodium. Se usa, DEScomente a linha
	# sed -i '/^# vscodium$/s/^# //' "$HOME"/HyDE/Scripts/pkg_user.lst

	# Desativar instalação do VSCode. Se usa, comente a linha
	# VSCode ativado, baixa 93,55 MB de pacotes e após instalado ocupa 348,95 MB a mais de espaço
	sed -i '/code/ s/^/# /' "$HOME"/HyDE/Scripts/pkg_core.lst

	# Ferramenta de linha de comando que permite exibir sprites de Pokémon em cores diretamente no seu terminal
	# Desativar Pokémon no ZSH
	sed -i '/pokego/ s/^/# /' "$HOME"/HyDE/Configs/.hyde.zshrc
	
	# Escolher uma opçao, Instalar o tema HyprDE apenas ou com aplicativos preferenciais
	main
else
	echo "Deve instalar a base Hyprland primeiro!"
	exit 1
fi

# Se algum tema falhar ao ser importado, execute este Script posteriormente: ./restore_thm.sh
# Se escolher não instalar os app flatpak, execute em extra: ./install_fpk.sh

#Como atualizar:
# cd "$HOME"/HyDE/Scripts && git pull origin master && ./install.sh -r

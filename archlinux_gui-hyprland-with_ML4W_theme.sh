#!/bin/bash

# https://github.com/mylinuxforwork/dotfiles/wiki
# https://github.com/mylinuxforwork/dotfiles?tab=readme-ov-file
# https://github.com/mylinuxforwork/dotfiles/wiki/Installation
# https://github.com/mylinuxforwork/dotfiles/wiki/Troubleshooting
# https://github.com/mylinuxforwork/dotfiles/wiki/Monitor-Configuration

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

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
            makepkg -Cris
            ;;
        2)
            echo "Instalando paru..."
            git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
            cd /tmp/paru-bin || exit 1
            makepkg -Cris
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
    sudo pacman --needed --noconfirm -S hyprutils nwg-displays xdg-user-dir swappy satty
    # The ML4W Dotfiles for Hyprland
    git clone https://aur.archlinux.org/ml4w-hyprland.git /tmp/ml4w-hyprland
    cd /tmp/ml4w-hyprland || exit 1
    makepkg --needed --noconfirm -Cris && \
    ml4w-hyprland-setup
else
	echo "Deve instalar a base Hyprland primeiro!"
	exit 1
fi

# Se não quiser usar o Dock, crie este arquivo:
# touch $HOME/.config/ml4w/settings/dock-disabled

# Utilitários Recomendados:
# hyprutils: Ferramentas adicionais para configuração e uso do Hyprland, um gerenciador de janelas Wayland.
# nwg-displays: Interface gráfica para gerenciar monitores no Wayland, facilitando ajustes em setups com múltiplas telas.

# Teclado BR ABNT2
# Hyprland

# grep -i brazil /usr/share/X11/xkb/rules/base.lst
#   abnt2           Brazilian ABNT2
#   br              Portuguese (Brazil)
#   nodeadkeys      br: Portuguese (Brazil, no dead keys)
#   dvorak          br: Portuguese (Brazil, Dvorak)
#   nativo          br: Portuguese (Brazil, Nativo)
#   nativo-us       br: Portuguese (Brazil, Nativo for US keyboards)
#   thinkpad        br: Portuguese (Brazil, IBM/Lenovo ThinkPad)
#   nativo-epo      br: Esperanto (Brazil, Nativo)
#   rus             br: Russian (Brazil, phonetic)


# cat "$HOME"/dotfiles/.config/hypr/conf/keyboard.conf
#     ...
#     kb_layout = br
#     kb_variant = abnt2
#     kb_model = pc104
#     kb_options =
#     numlock_by_default = true
#     mouse_refocus = false
#     ...

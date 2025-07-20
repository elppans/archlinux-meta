#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

locdir="$(pwd)"
install="$locdir"
export install

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
            cd "$install"/helper/ || exit 1
            bash pacote-helper-yay.sh
            ;;
        2)
            echo "Instalando paru..."
            cd "$install"/helper/ || exit 1
            bash pacote-helper-paru.sh
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
    # Utilitários Recomendados (Garantindo que estejam instalados)
    sudo pacman --needed --noconfirm -S hyprutils nwg-displays xdg-user-dirs swappy satty uwsm
    chmod +x bin/*
    sudo cp -a bin/* /usr/local/bin
    # Verificando Helper e instalando, caso necessário
    verificar_helper
	# The HyDE Dotfiles for Hyprland
	git clone --depth 1 https://github.com/HyDE-Project/HyDE "$HOME"/HyDE
	touch "$HOME"/.hidden
	grep 'HyDE' "$HOME"/.hidden || echo 'HyDE' >> "$HOME"/.hidden
	cd "$HOME"/HyDE/Scripts || exit 1
	cp -f "$HOME"/HyDE/Scripts/pkg_extra.lst "$HOME"/HyDE/Scripts/pkg_user.lst

    # Ativar instalação do Lutris
    sed -i '/^# lutris$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

	# Ativar instalação do VSCodium. Se usa, DEScomente a linha
	sed -i '/^# vscodium$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

	# Desativar instalação do VSCode. Se usa, comente a linha
	# VSCode ativado, baixa 93,55 MB de pacotes e após instalado ocupa 348,95 MB a mais de espaço
	sed -i '/code/ s/^/# /' "$HOME"/HyDE/Scripts/pkg_core.lst

    # Desativar instalação de aplicativos específicos em Flatpak
    sed -i '/org.gnome.Boxes/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst
    sed -i '/io.github.spacingbat3.webcord/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst
    sed -i '/io.gitlab.theevilskeleton.Upscaler/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst
    sed -i '/org.gnome.eog/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst

    # Ativar instalação de aplicativos específicos em Flatpak
    sed -i '/^# com.discordapp.Discord$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

    # Ferramenta de linha de comando que permite exibir sprites de Pokémon em cores diretamente no seu terminal
	# Desativar Pokémon no ZSH
	sed -i '/pokego/ s/^/# /' "$HOME"/HyDE/Configs/.hyde.zshrc

    # Habilitar Boost do volume
    sed -i '/VOLUME_BOOST:/ s/false/true/' "$HOME"/HyDE/Configs/.local/lib/hyde/volumecontrol.sh

    # Variável para Screenshot
    # shellcheck disable=SC2016
    sed -i 's|XDG_PICTURES_DIR="$HOME/Pictures"|XDG_PICTURES_DIR="$(xdg-user-dir PICTURES)"|' "$HOME"/HyDE/Configs/.local/lib/hyde/screenshot.sh

    # Preferências de usuário
    # echo -e 'parametros' | tee -a "$HOME"/HyDE/Configs/.config/hypr/userprefs.conf >>/dev/null

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

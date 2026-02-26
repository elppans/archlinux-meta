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

# Verificação do repositório MULTILIB
cd "$install"/helper/ || exit 1
./multilib-check.sh
./helper_install.sh
./chaotic-aur.sh
cd "$install" || exit 1
cd "$install"/pacotes/ || exit 1
./detect-vm.sh
cd "$install" || exit 1

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
	pwd
	cp -fv "$HOME"/HyDE/Scripts/pkg_extra.lst "$HOME"/HyDE/Scripts/pkg_user.lst

    # Ativar instalação do Lutris
    sed -i '/^# lutris$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

	# Ativar instalação do VSCodium. Se usa, DEScomente a linha
	sed -i '/^# vscodium$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

	# Desativar instalação do VSCode. Se usa, comente a linha
	# VSCode ativado, baixa 93,55 MB de pacotes e após instalado ocupa 348,95 MB a mais de espaço
	sed -i '/code/ s/^/# /' "$HOME"/HyDE/Scripts/pkg_core.lst

    # Desativar instalação de aplicativos específicos em Flatpak
    sed -i '/org.gnome.Boxes/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst						# Boxes - Virtualização simplificada
    sed -i '/io.github.spacingbat3.webcord/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst			# WebCord - Web-based Discord client
    # sed -i '/io.gitlab.theevilskeleton.Upscaler/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst	# Ampliar - Melhore e aprimore imagens
    # sed -i '/org.gnome.eog/ s/^/# /' "$HOME"/HyDE/Scripts/extra/custom_flat.lst							# Olho do GNOME - Navegue e gire imagens

    # Ativar instalação de aplicativos específicos em Flatpak
    sed -i '/^# com.discordapp.Discord$/s/^ //' "$HOME"/HyDE/Scripts/pkg_user.lst

# Outros aplicativos Arch
pacman -Qqs anyrun || echo -e '\nanyrun\n' | tee -a "$HOME"/HyDE/Scripts/pkg_user.lst
# shellcheck disable=SC2154,SC2016
sed -i 's/\$menu =.*/$menu = anyrun/' "$HOME/.config/hypr/hyprland.conf"
# O Anyrun procura os plugins em /usr/lib/anyrun/ ou ~/.config/anyrun/plugins
mkdir -p "$HOME/.config/anyrun/plugins"

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
# No HyDE, para configurar o teclado, deve configurar em outro o arquivo:
# Local de configuração: "~/.config/hypr/hyprland.conf"
# Sessão: "INPUT"
# Linhas 206 a 216
#     ...
#     kb_layout = br
#     kb_variant = abnt2
#     kb_model = pc104
#     kb_options =
#     numlock_by_default = true
#     # mouse_refocus = false
#     ...

# **Menu**
# O Script não está instalando o hyprlauncher
# Ao instalar, se depara com erro de "Segmentation fault"
# Uma alternativa e que combina MUITO com o HyDE é o "Anyrun", um Launcher moderno e bonito.
# O nome do pacote é "anyrun"
# Local de configuração: "~/.config/hypr/hyprland.conf", seção "MY PROGRAMS", variável "menu":
# Sessão: "MY PROGRAMS", variável "menu" (Não remova o "$" da frente):
# $menu = anyrun
# configurado para instalar via "pkg_user.lst"

# **Configuração do monitor**
# Comando para verificar, equivalente ao xrandr:
# hyprctl monitors all
# Local de configuração: "~/.config/hypr/hyprland.conf"
# Sessão: "MONITORS"
# Deve configurar a variável monitor como este modelo. Exatamente como aparece na resposta do comando anterior:
# monitor = Virtual-1, 1920x1080@60.00Hz, auto, auto
# Mais informações: https://wiki.hypr.land/Configuring/Monitors/

# **Arquivos configurados até o momento**
# Ficara anotado, para poder criar um "dotfiles" depois.
# "~/.config/hypr/hyprland.conf"

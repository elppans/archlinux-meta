#!/bin/bash

# https://www.ml4w.com/
# https://ml4w.com/os/
# https://github.com/mylinuxforwork/dotfiles/wiki
# https://github.com/mylinuxforwork/dotfiles?tab=readme-ov-file
# https://github.com/mylinuxforwork/dotfiles/wiki/Installation
# https://github.com/mylinuxforwork/dotfiles/wiki/Troubleshooting
# https://github.com/mylinuxforwork/dotfiles/wiki/Monitor-Configuration
# https://wiki.hypr.land/Configuring/Monitors/
# https://wiki.hypr.land/Configuring/Keywords/

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
	echo "Quando necessário, será pedido a senha administrativa!"
    exit 1
fi

locdir="$(pwd)"
install="$locdir"
export install

detectar_vm() {
cd "$install"/pacotes/ || exit 1
./detect-vm.sh
cd "$install" || exit 1
}

verificar_repositorios() {
# Verificação do repositório MULTILIB
cd "$install"/helper/ || exit 1
./multilib-check.sh
# Verificação do repositório CHAOTIC-AUR
pacman -Qqs chaotic-mirrorlist || ./chaotic-aur.sh
cd "$install" || exit 1

}

# Função para verificar se o programa está instalado
verificar_helper() {
    if command -v yay &> /dev/null; then
        echo "O 'yay' está instalado!"
		HELPER="yay"
		export HELPER
    elif command -v paru &> /dev/null; then
        echo "O 'paru' está instalado!"
		HELPER="paru"
		export HELPER
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
			HELPER="yay"
			export HELPER
            ;;
        2)
            echo "Instalando paru..."
            cd "$install"/helper/ || exit 1
            bash pacote-helper-paru.sh
			HELPER="paru"
			export HELPER
            ;;
        *)
            echo "Escolha inválida. Por favor, tente novamente."
            escolher_helper
            ;;
    esac
}

if pacman -Qqs hyprland ; then
	# **PACOTES**

    # Pacotes essenciais para desenvolvimento (Garantindo que estejam instalados)
    sudo pacman --needed --noconfirm -S git base-devel
    # Utilitários Recomendados (Garantindo que estejam instalados)
    sudo pacman --needed --noconfirm -S hyprutils nwg-displays xdg-user-dirs swappy satty
	# Verificar se a máquina é virtual e instalar pacotes se necessário
	detectar_vm
	# Verificar repositórios
	verificar_repositorios
    # Verificando Helper e instalando, caso necessário
    verificar_helper

	# SDDM Customizado, "sddm-silent-theme" (Lembrar de sempre usar "Hyprland UWSM")
	# Ativação do Display manager (Gerenciador de Login)
	"$HELPER" -Sy --needed --noconfirm -S sddm-silent-theme
	# shellcheck disable=SC2046
	sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
	systemctl is-enabled display-manager.service && sudo systemctl disable display-manager.service
	systemctl is-enabled gdm.service || sudo systemctl enable gdm.service

	# Script para usar com "SDDM-Silent-Theme"
	if pacman -Qqs sddm-silent-theme ; then
		mkdir -p "$HOME/build/silent-sddm-customizer"
		wget -O "$HOME/build/silent-sddm-customizer/PKGBUILD" "https://raw.githubusercontent.com/elppans/silent-sddm-customizer/refs/heads/main/PKGBUILD"
		cd "$HOME/build/silent-sddm-customizer" || exit 1
		makepkg -Cris || exit 1
	fi

    # **The ML4W Dotfiles for Hyprland**

    # git clone https://aur.archlinux.org/ml4w-hyprland.git "$HOME"/ml4w-hyprland
    # touch "$HOME"/.hidden
	# grep 'ml4w-hyprland' "$HOME"/.hidden || echo 'ml4w-hyprland' >> "$HOME"/.hidden
    # cd "$HOME"/ml4w-hyprland || exit 1
    # makepkg --needed --noconfirm -Cris
    
	# Garantindo que o instalador finalize sem reiniciar, para adicionar as customizações
    # sudo chmod -x /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh
    # sudo mv /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh.old
    # ml4w-hyprland-setup

	# Baixa a lista de dependências oficiais e armazena em uma variável
	mapfile -t PACKAGES < <(curl -fsSL https://raw.githubusercontent.com/mylinuxforwork/dotfiles/refs/heads/main/setup/dependencies/packages-arch | sed '/^#/d')

	# Executa o instalador Helper usando o array de forma segura
	"$HELPER" -Sy --needed "${PACKAGES[@]}"

	# Instalar o ML4W versão Stable pelo link oficial
    bash <(curl -s https://ml4w.com/os/stable)

	# **CUSTOMIZAÇÃO**

	# Adicionando configurações customzadas
    # tar -zxf "$install"/config/hyde_bin/hyde_bin.tar.gz -C "$HOME/.config"
    # cp -a "$install"/config/ML4W/.config/hypr/* "$HOME/.config/hypr/"
    # chmod +x "$install"/bin/*
    # sudo cp -a "$install"/bin/* /usr/local/bin
	cd "$install/config" || exit 1
	./ml4w_config_install.sh
	./ml4w_hyde_bin_install.sh
	cd "$install" || exit 1

	# Reativando as permissoes do script do ML4W
    # sudo mv /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh.old /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh
    # sudo chmod +x /usr/lib/ml4w-hyprland/install/dotfiles/reboot.sh


	echo "Finalizado a Instalação..."
    echo "Reinicie o computador para que as configurações surtam efeito!"
	exit 0
else
	echo "Deve instalar a base Hyprland primeiro!"
	exit 1
fi

# **Dock INFERIOR**
# Se não quiser usar o Dock (Da parte inferior da tela), crie este arquivo:
# touch $HOME/.config/ml4w/settings/dock-disabled
# Se quiser que ele fique no modo auto-ocultar, crie este arquivo:
# touch $HOME/.config/ml4w/settings/dock-autohide

# **Utilitários Recomendados**
# hyprutils: Ferramentas adicionais para configuração e uso do Hyprland, um gerenciador de janelas Wayland.
# nwg-displays: Interface gráfica para gerenciar monitores no Wayland, facilitando ajustes em setups com múltiplas telas.
# pinta: Editor de imagens simples escrito em Gtk# para desenho e pintura. Necessário para edição do ScreenShot

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


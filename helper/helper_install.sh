#!/bin/bash

# Função para verificar se o programa está instalado
verificar_helper() {
    if command -v yay &> /dev/null; then
        export HELPER="yay"
    elif command -v paru &> /dev/null; then
        export HELPER="paru"
    else
        escolher_helper
    fi
}
helper_yay(){
sudo pacman --needed --noconfirm -Sy base-devel debugedit fakeroot

# Wrappers do pacman (AUR Helper)
if pacman -Sqs | grep ^yay$ ;then
	sudo pacman --needed --noconfirm -Sy yay
else
	mkdir -p "$HOME/build" && echo 'build' >>"$HOME/.hidden"
	git clone https://aur.archlinux.org/yay.git "$HOME/build/yay"
	cd "$HOME/build/yay" || exit 1
	makepkg -Cris -L --needed --noconfirm
	cd - || exit 1
fi
}
helper_paru(){
sudo pacman --needed --noconfirm -Sy base-devel debugedit fakeroot

# Dependências opcionais para o paru:
sudo pacman --needed --noconfirm -Sy bat devtools

# Wrappers do pacman (AUR Helper)
if pacman -Sqs | grep ^paru$ ;then
	sudo pacman --needed --noconfirm -Sy paru
else
	mkdir -p "$HOME/build" && echo 'build' >>"$HOME/.hidden"
	git clone https://aur.archlinux.org/paru-bin.git "$HOME"/build/paru-bin
	cd "$HOME"/build/paru-bin || exit
	makepkg --needed --noconfirm -Cris
	cd - || exit 1
fi
}
# Função para escolher e instalar o gerenciador de pacotes
escolher_helper() {
    echo "Qual gerenciador de pacotes você deseja instalar?"
    echo "y) yay (Recomendado para a maioria)"
    echo "p) paru (Tem mais funções)"
    read -r -p "Digite a opção correspondente: " escolha

    case $escolha in
        y|Y)
            echo "Instalando yay..."
            helper_yay
            export HELPER="yay"
            ;;
        p|P)
            echo "Instalando paru..."
            helper_paru
            export HELPER="paru"
            ;;
        *)
            echo "Escolha inválida. Por favor, tente novamente."
			sleep 3
            escolher_helper
            # echo "Instalando yay..."
            # helper_yay
			# export HELPER="yay"
            ;;
    esac
}
    # Verificando Helper e instalando, caso necessário
    verificar_helper
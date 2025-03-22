#!/bin/bash

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
    read -p "Digite o número da opção desejada: " choice

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

# Wrappers do pacman (AUR Helper)
# git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin && cd /tmp/paru-bin && makepkg -Cris -L --needed --noconfirm

# Manage user directories like ~/Desktop and ~/Music
# sudo pacman --needed --noconfirm -S xdg-user-dirs && xdg-user-dirs-update

# Pacotes essenciais para desenvolvimento
sudo pacman --needed --noconfirm -S git base-devel

git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
echo 'HyDE' >> ~/.hidden
cd ~/HyDE/Scripts
cp "$HOME"/HyDE/Scripts/pkg_extra.lst "$HOME"/HyDE/Scripts/pkg_user.lst

# Ativar instalação do VSCodium. Se usa, DEScomente a linha
# sed -i '/^# vscodium$/s/^# //' "$HOME"/HyDE/Scripts/pkg_user.lst

# Desativar instalação do VSCode. Se usa, comente a linha
# VSCode ativado, baixa 93,55 MB de pacotes e após instalado ocupa 348,95 MB a mais de espaço
sed -i '/code/ s/^/# /' "$HOME"/HyDE/Scripts/pkg_core.lst

# Ferramenta de linha de comando que permite exibir sprites de Pokémon em cores diretamente no seu terminal
# Desativar Pokémon no ZSH
sed -i '/pokego/ s/^/# /' "$HOME"/HyDE/Configs/.hyde.zshrc

main

# Se algum tema falhar ao ser importado, execute este Script posteriormente: ./restore_thm.sh
# Se escolher não instalar os app flatpak, execute em extra: ./install_fpk.sh

#Como atualizar:
# cd "$HOME"/HyDE/Scripts && git pull origin master && ./install.sh -r

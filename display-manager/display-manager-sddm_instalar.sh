#!/bin/bash
# shellcheck disable=SC2046

# Verifica se existe um display manager ativo/instalado
CURRENT_DM=$(systemctl status display-manager.service 2>/dev/null | head -n1 | awk '{print $2}')

install_and_enable_sddm() {
    sudo pacman -S --needed sddm sddm-kcm
    
    if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "sddm.service" ]; then
        sudo systemctl disable "$CURRENT_DM"
    fi
    
    sudo systemctl enable sddm.service
    echo "[+] SDDM instalado e habilitado com sucesso."
}

if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "sddm.service" ]; then
    echo "[-] Gerenciador de login detectado: $CURRENT_DM"
    read -rp "Deseja substituir pelo SDDM? [y/N]: " CONFIRM
    case "$CONFIRM" in
        [yY][eE][sS]|[yY])
            install_and_enable_sddm
            ;;
        *)
            echo "[!] Operação cancelada pelo usuário."
            exit 0
            ;;
    esac
else
    # Nenhum Display Manager ativo ou o SDDM já é o atual
    install_and_enable_sddm
fi
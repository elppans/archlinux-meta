#!/bin/bash
# shellcheck disable=SC2046

# Captura o Display Manager atualmente configurado
CURRENT_DM=$(systemctl status display-manager.service 2>/dev/null | head -n1 | awk '{print $2}')

install_and_enable_gdm() {
    sudo pacman -S --needed --noconfirm gdm
    
    if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "gdm.service" ]; then
        sudo systemctl disable "$CURRENT_DM"
    fi
    
    systemctl is-enabled gdm.service &>/dev/null || sudo systemctl enable gdm.service
    echo "[+] GDM instalado e habilitado com sucesso."
}

if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "gdm.service" ]; then
    echo "[-] Gerenciador de login detectado: $CURRENT_DM"
    read -rp "Deseja substituir pelo GDM? [y/N]: " CONFIRM
    case "$CONFIRM" in
        [yY][eE][sS]|[yY])
            install_and_enable_gdm
            ;;
        *)
            echo "[!] Operação cancelada pelo usuário."
            exit 0
            ;;
    esac
else
    # Nenhum Display Manager ativo ou o GDM já é o atual
    install_and_enable_gdm
fi
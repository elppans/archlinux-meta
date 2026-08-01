#!/bin/bash
# shellcheck disable=SC2046

# Captura o Display Manager atualmente configurado
CURRENT_DM=$(systemctl status display-manager.service 2>/dev/null | head -n1 | awk '{print $2}')

install_and_enable_lightdm() {
    # O pacote lightdm-gtk-greeter-settings puxa lightdm e lightdm-gtk-greeter como dependências no Arch Linux
    sudo pacman -S --needed lightdm-gtk-greeter-settings
    
    if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "lightdm.service" ]; then
        sudo systemctl disable "$CURRENT_DM"
    fi
    
    sudo systemctl enable lightdm.service
    echo "[+] LightDM instalado e habilitado com sucesso."
}

if [ -n "$CURRENT_DM" ] && [ "$CURRENT_DM" != "lightdm.service" ]; then
    echo "[-] Gerenciador de login detectado: $CURRENT_DM"
    read -rp "Deseja substituir pelo LightDM? [y/N]: " CONFIRM
    case "$CONFIRM" in
        [yY][eE][sS]|[yY])
            install_and_enable_lightdm
            ;;
        *)
            echo "[!] Operação cancelada pelo usuário."
            exit 0
            ;;
    esac
else
    # Nenhum Display Manager ativo ou o LightDM já é o atual
    install_and_enable_lightdm
fi
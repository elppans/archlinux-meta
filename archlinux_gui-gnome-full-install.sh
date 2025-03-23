#!/bin/bash
# shellcheck disable=SC2027,SC2046,SC2002,SC2016

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

locdir="$(pwd)"
install="$locdir"

"$install"/archlinux_gui-gnome-shell-meta.sh
"$install"/archlinux_gui-gnome-shell-meta-pos-install.sh

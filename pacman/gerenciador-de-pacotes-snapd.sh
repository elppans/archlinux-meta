#!/bin/bash
# shellcheck disable=SC2129

# AppArmor (Recomendado usar, para manter a segurança dos pacotes Snap)
# https://wiki.archlinux.org/title/AppArmor
# Movido para Sessão de Scripts

# Instalação de pacotes via AUR

# Gerenciador de pacotes Snapd
# https://wiki.archlinux.org/title/Snap

paru --needed --noconfirm -S snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable --now snapd snapd.socket snapd.apparmor

# ocultar a pasta. snap
echo "snap" | tee -a /etc/skel/.hidden >>/dev/null
echo "Snap" | tee -a /etc/skel/.hidden >>/dev/null
echo "snapd" | tee -a /etc/skel/.hidden >>/dev/null
echo "Snapd" | tee -a /etc/skel/.hidden >>/dev/null

cat /etc/skel/.hidden >> "$HOME"/.hidden

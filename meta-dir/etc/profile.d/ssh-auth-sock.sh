#!/bin/bash
#
# Propaga SSH_AUTH_SOCK (socket do gcr-ssh-agent/gnome-keyring) para o
# ambiente do systemd --user e do dbus, evitando o aviso no desligamento:
# "Environment variable $SSH_AUTH_SOCK not set, ignoring."
#
# Causa raiz: SSH_AUTH_SOCK é uma variável de sessão, mas o systemd --user
# manager não a conhece automaticamente. Algum serviço com
# PassEnvironment=SSH_AUTH_SOCK tenta repassá-la e não encontra, gerando
# o aviso (inofensivo, mas chato de ver toda hora).
#
# Sourced pelo /etc/profile via greetd (source_profile=true), antes da
# sessão COSMIC iniciar — por isso fica em /etc/profile.d/ e não em
# ~/.config/autostart/.
#
# https://wiki.archlinux.org/title/COSMIC
# https://wiki.archlinux.org/title/GNOME/Keyring#Setup_gcr

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
systemctl --user import-environment SSH_AUTH_SOCK 2>/dev/null
dbus-update-activation-environment --systemd SSH_AUTH_SOCK 2>/dev/null
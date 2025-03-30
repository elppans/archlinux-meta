#!/bin/bash

# Kernel
sudo pacman --needed --noconfirm -S kernel-modules-hook    # Instala o pacote para gerenciar corretamente os módulos do kernel após atualizações.
sudo systemctl enable --now linux-modules-cleanup.service  # Ativa e inicia o serviço para limpar módulos antigos do kernel.
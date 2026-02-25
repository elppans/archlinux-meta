#!/bin/bash

# **Hyprland Meta Install**

### **Configurações de Ambiente**

# Tipo de ambiente: Desktop Environment / Perfil Hyprland
# Áudio: pipewire
# Acesso ao seat: polkit

# **Categoria, Pacotes**

# Interface (Core):				"hyprland, uwsm, wofi, dunst"
# Utilitários de Sistema:		"dolphin (arquivos), kitty (terminal), xdg-utils"
# Gráficos/Wayland:				"grim, slurp, qt5-wayland, qt6-wayland, xdg-desktop-portal-hyprland"
# Áudio (Pipewire):				"pipewire, pipewire-pulse, wireplumber"
# Rede e Ferramentas:			"iwd, wireless_tools, openssh, wget, htop, smartmontools"
# Editores & Permissão:			"vim, nano, polkit-kde-agent"

### **Pacotes por categoria e suas descrições**

# --- Interface e Compositor (Core) ---
# hyprland:						Compositor dinâmico e altamente personalizável para Wayland.
# hyprutils:					Ferramentas adicionais para configuração do Hyprland.
# uwsm:							(Novo) Universal Wayland Session Manager para gerenciar a sessão corretamente.
# wofi:							Iniciador de aplicativos leve projetado para Wayland.
# dunst:						Daemon de notificações leve e configurável.
# nwg-displays:					Interface gráfica para gerenciar múltiplos monitores.

# --- Terminal e Gráficos ---
# kitty:						Emulador de terminal rápido e rico em recursos.
# grim:							Ferramenta para capturar screenshots no Wayland.
# slurp:						Selecionador de regiões da tela para o grim.

# --- Compatibilidade e Portais ---
# xdg-desktop-portal-hyprland:  Integração essencial para apps sandbox e screen sharing.
# xdg-utils:					Utilitários para operações comuns (abrir URLs, arquivos, etc).
# xdg-user-dirs:				Cria as pastas padrão (Downloads, Documentos, etc).
# qt5-wayland / qt6-wayland: 	Suporte para apps Qt rodarem nativamente no Wayland.
# polkit-kde-agent:				Agente de autenticação para permissões administrativas (sudo gráfico).

# --- Áudio (Pipewire) ---
# pipewire / pipewire-pulse / pipewire-alsa: O novo padrão de áudio do Linux.
# wireplumber:					Gerenciador de sessões e políticas para o Pipewire.

# --- Redes e Conectividade ---
# iwd / wireless_tools / wpa_supplicant: Ferramentas e daemons para Wi-Fi.
# openssh:						Protocolo para conexões remotas seguras.
# wget:							Utilitário para download de arquivos via terminal.

# --- Monitoramento e Editores ---
# btop / htop:					Monitores de recursos e processos do sistema.
# smartmontools:				Monitoramento de saúde de discos (SSD/HDD).
# vim / nano:					Editores de texto para terminal (avançado e simples).

# Ferramentas do sistema:
# kernel-modules-hook:			Um utilitário que automatiza a reconstrução de módulos do kernel após atualizações,
# garantindo que os módulos personalizados permaneçam compatíveis com o kernel em uso.

# Gerenciador de exibição:
# sddm:							Simple Desktop Display Manager, um gerenciador de exibição moderno e leve

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

# Obtém a versão do kernel em execução
kernel_version=$(uname -r)

# Obtém a versão do diretório em /lib/modules
# shellcheck disable=SC2010
module_version=$(ls /lib/modules | grep "^$kernel_version$")

if [ "$kernel_version" == "$module_version" ]; then
    echo
    # echo "OK: A versão do kernel ($kernel_version) e o diretório em /lib/modules correspondem."
    # exit 0
else
    echo "ERRO: A versão do kernel ($kernel_version) e o diretório em /lib/modules não correspondem."
    echo "Por favor, reinicie o sistema para aplicar as configurações corretamente."
    exit 1
fi

# Adiciona a linha "ILoveCandy" em /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf

# Instala o pacote 'kernel-modules-hook'
sudo pacman --needed --noconfirm -S kernel-modules-hook

# Ativa e inicia o serviço 'linux-modules-cleanup' para limpar os módulos antigos
# do kernel, liberando espaço e evitando possíveis conflitos com módulos desnecessários.
sudo systemctl enable --now linux-modules-cleanup.service

# Instalando Hyprland (Meta)
sudo pacman -S --needed \
    hyprland hyprutils uwsm wofi dunst nwg-displays \
    kitty grim slurp \
    xdg-desktop-portal-hyprland xdg-utils xdg-user-dirs \
    qt5-wayland qt6-wayland polkit polkit-kde-agent \
    pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber \
    iwd wireless_tools wpa_supplicant openssh wget \
    btop htop smartmontools vim nano \
    sddm

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Ativação do Display manager (Gerenciador de Login)
sudo systemctl disable "$(systemctl status display-manager.service | head -n1 | awk '{print $2}')" &>>/dev/null
sudo systemctl enable sddm.service

# Seguir para instalação do tema ML4W ou HyDE

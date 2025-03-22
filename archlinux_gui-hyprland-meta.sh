#!/bin/bash

# Hyprland Meta Install

# Instalação do Hyprland e Ferramentas:
# hyprland: Um compositor dinâmico e altamente personalizável para o Wayland.
# dunst: Um leve e altamente configurável daemon de notificações.
# kitty: Um emulador de terminal gráfico rápido e rico em recursos.
# wofi: Um iniciador de aplicativos leve projetado para Wayland.
# xdg-desktop-portal-hyprland: Integração de portal para Hyprland, essencial para compatibilidade com aplicativos sandbox.
# qt5-wayland e qt6-wayland: Suporte para rodar aplicativos baseados em Qt no ambiente Wayland.
# polkit-kde-agent: Gerenciador de autenticação do KDE, necessário para operações que requerem privilégios administrativos.
# grim: Ferramenta para capturar screenshots no Wayland.
# slurp: Usado em conjunto com o grim para selecionar regiões específicas da tela para capturar.
# hyprutils: Ferramentas adicionais para configuração e uso do Hyprland
# nwg-displays: Interface gráfica para gerenciar monitores no Wayland, facilitando ajustes em setups com múltiplas telas.

# Ferramentas essenciais e utilitários variados:
# btop: Uma ferramenta visual e interativa para monitoramento de recursos do sistema.
# htop: Um visualizador interativo de processos para o terminal, mais avançado que o top.
# iwd: Um daemon de gerenciamento de Wi-Fi criado pela Intel.
# nano: Um editor de texto simples e amigável para o terminal.
# openssh: Implementação do protocolo SSH para conexões seguras e transferência de arquivos.
# smartmontools: Conjunto de ferramentas para monitoramento e análise de discos rígidos e SSDs.
# vim: Um editor de texto poderoso e altamente configurável, amplamente utilizado por desenvolvedores.
# wget: Ferramenta de linha de comando para baixar arquivos da internet.
# wireless_tools: Conjunto de ferramentas para gerenciar conexões de rede sem fio.
# wpa_supplicant: Um cliente para gerenciamento de conexões Wi-Fi seguras.
# xdg-user-dirs: Gerenciador de diretórios padrão do usuário (como Documentos, Downloads, etc.).
# xdg-utils: Conjunto de utilitários para operações comuns, como abrir URLs ou arquivos, integrado ao ambiente de desktop.

# Ferramentas do sistema:
# kernel-modules-hook: Um utilitário que automatiza a reconstrução de módulos do kernel após atualizações,
# garantindo que os módulos personalizados permaneçam compatíveis com o kernel em uso.

# Gerenciador de exibição:
# sddm: Simple Desktop Display Manager, um gerenciador de exibição moderno e leve

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
sudo pacman --needed --noconfirm -Syyu hyprland dunst kitty wofi xdg-desktop-portal-hyprland qt5-wayland qt6-wayland polkit-kde-agent grim slurp hyprutils nwg-displays
sudo pacman --needed --noconfirm -S btop htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant xdg-user-dirs xdg-utils
sudo pacman --needed --noconfirm -S sddm

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Ativação do Display manager (Gerenciador de Login)
sudo systemctl disable "$(systemctl status display-manager.service | head -n1 | awk '{print $2}')" &>>/dev/null
sudo systemctl enable sddm.service

# Seguir para instalação do tema ML4W ou HyDE

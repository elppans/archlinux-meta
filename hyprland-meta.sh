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

locdir="$(pwd)"
install="$locdir"
export install
# shellcheck disable=SC2086
base_install="$(basename $install)"
export base_install

PACOTES=(
	# Pacotes Meta / Compositor & Sessão
	hyprland     # Compositor Wayland dinâmico baseado em tilling e wlroots
	hyprutils    # Biblioteca utilitária C++ compartilhada pelo ecossistema Hyprland
	uwsm         # Universal Wayland Session Manager (gerenciamento de sessão Systemd)
	wofi         # Application launcher e menu interativo para Wayland (estilo Rofi)
	dunst        # Daemon de notificações leve e altamente customizável
	nwg-displays # Interface gráfica GTK para configuração e layout de monitores

	# Terminal & Captura de Tela
	kitty    # Emulador de terminal acelerado por GPU com suporte a imagens
	grim     # Utilitário CLI para captura de tela (screenshot) em Wayland
	slurp    # Ferramenta para seleção visual de regiões na tela (usado com o grim)
	hyprshot # Utilitário para captura de tela (screenshot) em Wayland
	satty    # Modern screenshot annotation tool

	# Portais & Integração XDG
	xdg-desktop-portal-hyprland # Backend de portal desktop nativo para Hyprland (screencast, sharing)
	xdg-utils                   # Conjunto de ferramentas de integração de desktop (ex: xdg-open)
	xdg-user-dirs               # Gerenciador de pastas padrão do usuário (Downloads, Documents, etc.)

	# Toolkit & Autenticação
	qt5-wayland      # Módulo de suporte nativo ao Wayland para aplicações Qt5
	qt6-wayland      # Módulo de suporte nativo ao Wayland para aplicações Qt6
	polkit           # Toolkit para controle e gerenciamento de privilégios do sistema
	polkit-kde-agent # Agente de autenticação gráfica do Polkit baseado em KDE

	# Áudio & Mídia (PipeWire)
	pipewire       # Server de áudio/vídeo moderno de baixa latência
	pipewire-pulse # Emulação da API/daemon do PulseAudio sobre o PipeWire
	pipewire-alsa  # Plugin de redirecionamento do ALSA para o PipeWire
	pipewire-jack  # Emulação da API/cliente do JACK sobre o PipeWire
	wireplumber    # Gerenciador de sessão e políticas padrão para o PipeWire

	# Rede & Conectividade
	iwd            # Daemon moderno da Intel para gerenciamento de conexões Wi-Fi
	wireless_tools # Ferramentas legadas para configuração de redes sem fio (iwconfig)
	wpa_supplicant # Daemon de autenticação para redes Wi-Fi (WPA/WPA2/WPA3)
	openssh        # Cliente e servidor SSH para acesso e shell remoto seguro
	wget           # Utilitário para download de arquivos via HTTP, HTTPS e FTP

	# Monitoramento & Edição de Texto
	btop          # Monitor de recursos interativo com interface TUI moderna
	htop          # Visualizador de processos e monitor de sistema em modo texto
	smartmontools # Ferramentas de monitoramento de integridade de HDs/SSDs via S.M.A.R.T.
	vim           # Editor de texto avançado e altamente customizável
	nano          # Editor de texto simples para terminal

	# Interface, Status & Clipboard
	hyprpaper    # Utilitário nativo do Hyprland para gerenciamento de wallpapers
	waybar       # Barra de status customizável para compositores Wayland
	wl-clipboard # Utilitários CLI para manipulação da área de transferência (wl-copy/wl-paste)
	cliphist     # Gerenciador e histórico de área de transferência com suporte a texto e imagens

	# Pacotes Dev
	base-devel # Meta-pacote com ferramentas essenciais de compilação (gcc, make, autoconf, etc.)
	curl       # Ferramenta para transferência de dados via URLs com suporte a múltiplos protocolos
	git        # Sistema de controle de versão distribuído
	expac      # Utilitário de extração de dados do banco de dados do pacman
	pkgfile    # Ferramenta para buscar qual pacote provê determinado arquivo/binário
)

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

# Descomenta "Color" se ele estiver comentado
sudo sed -i 's/^#\s*Color/Color/' /etc/pacman.conf

if ! pacman -Qq kernel-modules-hook &>/dev/null; then
    # Sincroniza a base de dados E atualiza o sistema para evitar parcial upgrade
    sudo pacman -Syu --needed --noconfirm kernel-modules-hook

    # Ativa e inicia o serviço para limpar módulos antigos
	# liberando espaço e evitando possíveis conflitos com módulos desnecessários.
    sudo systemctl enable --now linux-modules-cleanup.service
fi

# Instalando Hyprland (Meta)
sudo pacman --needed --noconfirm -Syu "${PACOTES[@]}"
sudo pkgfile -u

# Ativação do Display manager (Gerenciador de Login)
cd "$install"/display-manager/ || exit 1
chmod +x display-manager-sddm_instalar.sh
./display-manager-sddm_instalar.sh
cd "$install" || exit 1

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Seguir para instalação do tema ML4W ou HyDE

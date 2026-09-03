#!/bin/bash

# **Plasma Meta Install**

### **Configurações de Ambiente**

# Tipo de ambiente: GUI / Perfil "plasma-desktop"
# Áudio: pipewire
# Acesso ao seat: polkit

# plasma-meta: "curated selection of kde plasma"
# plasma-desktop: "minimal kde plasma installation"

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
	# Ps.: Pacotes comentados são os que vi mais tarde que não são necessários, mas mantive nas linhas a fim de documentação
	# Pacotes Meta / Compositor & Sessão
	plasma-desktop				# Pacote minimal para a instalação usando Archinstall. Os outros pacotes abaixo são de escolha minha
	plasma-disks
	plasma-systemmonitor        # An interface for monitoring system sensors, process information and other system resources
	plasma-nm				    # Network manager applet
	plasma-pa                   # Audio volume applet
	dolphin                     # KDE File Manager (Não faz parte da lista)
	kate                        # Advanced text editor
	konsole	                    # KDE terminal emulator (Não faz parte da lista, mas é bom para ativar o Terminal no Dolphin. Para mais opções, consulte Dep. Opcionais)
	kscreen                     # KDE screen management software
	kinfocenter
	ark                         # Compressor de arquivos do Plasma
	filelight                   # View disk usage information
	flatpak-kcm
	spectacle                   # KDE screenshot capture utility
	gwenview                    # A fast and easy to use image viewer

	# Portais & Integração XDG
	xdg-utils                   # Conjunto de ferramentas de integração de desktop (ex: xdg-open)
	# xdg-user-dirs               # Gerenciador de pastas padrão do usuário (Downloads, Documents, etc.)

	# Toolkit & Autenticação
	# qt5-wayland      # Módulo de suporte nativo ao Wayland para aplicações Qt5
	# qt6-wayland      # Módulo de suporte nativo ao Wayland para aplicações Qt6 - Quando necessário, será instalado como dependência de aplicativos Plasma
	# polkit           # Toolkit para controle e gerenciamento de privilégios do sistema
	# polkit-kde-agent # Agente de autenticação gráfica do Polkit baseado em KDE

	# Áudio & Mídia (PipeWire)
	pipewire       # Server de áudio/vídeo moderno de baixa latência
	pipewire-pulse # Emulação da API/daemon do PulseAudio sobre o PipeWire
	pipewire-alsa  # Plugin de redirecionamento do ALSA para o PipeWire
	pipewire-jack  # Emulação da API/cliente do JACK sobre o PipeWire
	wireplumber    # Gerenciador de sessão e políticas padrão para o PipeWire

	# Rede & Conectividade
	# iwd            # Daemon moderno da Intel para gerenciamento de conexões Wi-Fi
	# wireless_tools # Ferramentas legadas para configuração de redes sem fio (iwconfig)
	wpa_supplicant # Daemon de autenticação para redes Wi-Fi (WPA/WPA2/WPA3)
	openssh        # Cliente e servidor SSH para acesso e shell remoto seguro
	wget           # Utilitário para download de arquivos via HTTP, HTTPS e FTP

	# Monitoramento & Edição de Texto
	btop          # Monitor de recursos interativo com interface TUI moderna
	htop          # Visualizador de processos e monitor de sistema em modo texto
	smartmontools # Ferramentas de monitoramento de integridade de HDs/SSDs via S.M.A.R.T.
	vim           # Editor de texto avançado e altamente customizável
	nano          # Editor de texto simples para terminal

	# Pacotes Dev
	base-devel # Meta-pacote com ferramentas essenciais de compilação (gcc, make, autoconf, etc.)
	curl       # Ferramenta para transferência de dados via URLs com suporte a múltiplos protocolos
	git        # Sistema de controle de versão distribuído
	expac      # Utilitário de extração de dados do banco de dados do pacman
	pkgfile    # Ferramenta para buscar qual pacote provê determinado arquivo/binário

	# Pacotes adicionais
	zram-generator # Systemd unit generator for zram devices
	# ufw 	       # Uncomplicated and easy to use CLI tool for managing a netfilter firewall
	# gufw		   # Uncomplicated way to manage your Linux firewall
	fwupd          # Dependência opcional para plasma-systemmonitor 
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
# pacote meta: plasma-login-manager
# A instalar: sddm
	if [ -d "$install"/display-manager ]; then
        cd "$install"/display-manager/ || exit 1
        chmod +x display-manager-sddm_instalar.sh
        ./display-manager-sddm_instalar.sh
        cd "$install" || exit 1
	else
        bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/display-manager/display-manager-sddm_instalar.sh')
	fi

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

### **Sincronismo plasma minimal**

# Instalação do plasma-sync
tmpdir=$(mktemp -d)
mkdir -p "$tmpdir/build"
cd "$tmpdir/build" || exit 1
git clone -b test https://github.com/elppans/plasma-sync.git
cd "$tmpdir/build/plasma-sync" || exit 1
sudo make install

# Download sincronismo plasma minimo
cd "$HOME/.config" || exit 1
git clone https://github.com/elppans/plasma-sync-minimal.git
echo s | /usr/local/bin/plasma-sync restore "$HOME/.config/plasma-sync-minimal"

echo "Configuração finalizada..."
echo "Reinicie o sistema para que as configurações surtam efeito."

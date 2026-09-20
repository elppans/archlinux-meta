#!/usr/bin/env bash

# **Cosmic Install**

### **Configurações de Ambiente**

# Tipo de ambiente: GUI / Perfil "Cosmic"
# Áudio: pipewire

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
	# Perfil Archinstall
	cosmic
	htop
	nano
	openssh
	smartmontools
	vim
	wget
	xdg-user-dirs
	xdg-utils

	# Greeter
	cosmic-greeter

	# Audio
	pipewire

	# Firewall
	ufw

	# Configuração de rede
	network-manager

	# Pacotes Dev
	base-devel 				# Meta-pacote com ferramentas essenciais de compilação (gcc, make, autoconf, etc.)
	curl       				# Ferramenta para transferência de dados via URLs com suporte a múltiplos protocolos
	git        				# Sistema de controle de versão distribuído
	expac      				# Utilitário de extração de dados do banco de dados do pacman
	pkgfile    				# Ferramenta para buscar qual pacote provê determinado arquivo/binário

	# Pacotes adicionais
	pipewire-pulse  		# Emulação da API/daemon do PulseAudio sobre o PipeWire
	pipewire-alsa   		# Plugin de redirecionamento do ALSA para o PipeWire
	pipewire-jack   		# Emulação da API/cliente do JACK sobre o PipeWire
	wireplumber     		# Gerenciador de sessão e políticas padrão para o PipeWire
	# smplayer        		# Media player with built-in codecs that can play virtually all video and audio formats
	# smplayer-themes 		# smplayer-themes
	wpa_supplicant 			# Daemon de autenticação para redes Wi-Fi (WPA/WPA2/WPA3)
	zram-generator 			# Systemd unit generator for zram devices
	gufw		            # Uncomplicated way to manage your Linux firewall. - Com "plasma-firewall" instalado, este não tem utilidade
	archlinux-wallpaper 	# Papéis de parede oficiais do Arch Linux
	gst-plugins-base		# Multimedia graph framework - base plugins
	gst-plugins-good		# Multimedia graph framework - good plugins
	gst-plugins-bad			# Multimedia graph framework - bad plugins

	# Pacote com base no PopOS
	gnome-disk-utility		# Disk Management Utility
	baobab					# Disk Usage Analyzer
	simple-scan				# Document Scanner
	papers					# Document Viewer. (No PopOS: evince)
	file-roller				# Gerenciador de arquivos compactados
	gnome-characters		# Mapa de caracters. (No PopOS: gucharmap)
	loupe					# Image Viewer. (No PopOS: eog)
	thunderbird-i18n-pt-br	# Gerenciador de e-mails da Mozilla
	firefox-i18n-pt-br		# Navegador Web
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

if [ -f "$install"/custom/zram-generator.sh ]; then
	cd "$install"/custom/ || exit 1
	chmod +x zram-generator.sh
	./zram-generator.sh
	cd "$install" || exit 1
else
	bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/custom/zram-generator.sh')
fi

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Configuração do Wallpaper "Conference"
if pacman -Qs archlinux-wallpaper >/dev/null; then
	if [ -d "/usr/share/backgrounds/archlinux" ]; then
		sudo mkdir -p /usr/share/wallpapers
		sudo ln -sf /usr/share/backgrounds/archlinux /usr/share/wallpapers/archlinux
		if [ -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" ]; then
			if ! grep -q conference.png "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"; then
				tee -a "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" &>/dev/null <<'EOF'

[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/backgrounds/archlinux/conference.png
SlidePaths=/usr/share/wallpapers/
EOF
			fi
		fi
	fi
fi

# Ocultar diretório archlinux-meta
if [ -d "$HOME/archlinux-meta" ]; then
echo 'archlinux-meta' | tee -a "$HOME/.hidden" &>>/dev/null
fi

echo "Configuração finalizada..."
echo "Reinicie o sistema para que as configurações surtam efeito."

# -- Scripts opcionais --

# ------------------------------------------------------------------------------
# Ativar o Chaotic AUR
# ------------------------------------------------------------------------------
# Baixa o script diretamente do GitHub, executa a instalação e remove o arquivo
# temporário utilizado durante o processo.
#
# OBSERVAÇÃO:
# A execução do Script pergunta por padrão se quer ativar o repositório ou não.
# Então não há necessidade de ativar a linha deste Script
#
# tmp=$(mktemp) && wget -qO "$tmp" 'https://elppans.github.io/archlinux-meta/helper/chaotic-aur_hyde.sh' && sudo bash "$tmp" --install; rm -f "$tmp"

# bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/helper/pacote-helper-yay.sh')
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-pacman')
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-flatpak')
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/ML4W/.local/bin/meta-custom')

#!/bin/bash

# Função para verificar se o pacote está instalado
verificar_pacote() {
	pacman -Q "$1" &>/dev/null
}

# Nome do pacote
PACOTE=""

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	comandos
fi

########################################################################################################
# pacote-pacman-apparmor-instalar.sh

# Variável para verificar se algum pacote está instalado
PACOTE_INSTALADO=false

# Lista de pacotes
PACOTES=("apparmor" "apparmor-utils" "apparmor-profiles")

# Loop para verificar cada pacote
for pacote in "${PACOTES[@]}"; do
	if verificar_pacote "$pacote"; then
		PACOTE_INSTALADO=true
		break
	fi
done

# Se pelo menos um dos pacotes estiver instalado, aplica a configuração
if $PACOTE_INSTALADO; then
	echo "Pelo menos um dos pacotes está instalado. Aplicando configuração..."

	# Configura os parâmetros do kernel no GRUB
	GRUB_FILE="/etc/default/grub"
	if [ -f "$GRUB_FILE" ]; then
		echo "Configurando os parâmetros do GRUB para habilitar o AppArmor..."
		if ! grep -q "apparmor=1" "$GRUB_FILE"; then
			sudo sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT="\)/\1apparmor=1 security=apparmor /' "$GRUB_FILE"
			echo "Parâmetros adicionados no GRUB_CMDLINE_LINUX_DEFAULT."
		else
			echo "Parâmetros do AppArmor já configurados no GRUB_CMDLINE_LINUX_DEFAULT."
		fi

		echo "Atualizando a configuração do GRUB..."
		sudo grub-mkconfig -o /boot/grub/grub.cfg
	else
		echo "Arquivo $GRUB_FILE não encontrado. Se você não utiliza o GRUB, adicione os parâmetros 'apparmor=1 security=apparmor' manualmente no seu bootloader."
	fi

	# Habilita e inicia o serviço do AppArmor
	echo "Habilitando e iniciando o serviço do AppArmor..."
	sudo systemctl enable apparmor.service
	sudo systemctl start apparmor.service

	echo "Status atual do serviço AppArmor:"
	sudo systemctl status apparmor.service --no-pager

	echo "Instalação e configuração do AppArmor concluída."
else
	echo
fi

########################################################################################################
# pacote-pacman-flameshot.sh

# Nome do pacote
PACOTE="flameshot"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	echo "O pacote $PACOTE está instalado. Aplicando configuração..."
	sudo pacman --noconfirm -R xf86-video-intel
	sudo cp -a /usr/share/applications/org.flameshot.Flameshot.desktop /etc/skel/.local/share/applications
	sudo sed -i 's|/usr/bin/flameshot|/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
	sudo sed -i 's|Exec=flameshot|Exec=/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
	cp -a /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop "$HOME/.local/share/applications"
	echo "Configuração do Flameshot concluída."
else
	echo
fi

########################################################################################################
# pacote-pacman-icon-theme.sh

# Tema de ícones

# Nome do pacote
PACOTE="obsidian-icon-theme"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
fi

# Nome do pacote
# PACOTE="cutefish-icons"

# Verifica se o pacote está instalado
# if verificar_pacote "$PACOTE"; then
# 	gsettings set org.gnome.desktop.interface icon-theme ""
# 	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme ""
# fi

########################################################################################################
# pacote-pacman-kernel-hook.sh

# Nome do pacote
PACOTE="kernel-modules-hook"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	sudo systemctl enable --now linux-modules-cleanup.service # Ativa e inicia o serviço para limpar módulos antigos do kernel.
fi

########################################################################################################
# pacote-pacman-lutris_instalar.sh

# sudo pacman -S --needed gamemode lib32-gamemode lutris wine-staging winetricks apparmor lib32-libpulse lib32-libsndfile lib32-libasyncns

########################################################################################################
# pacote-pacman-orchis-theme-black.sh e pacote-pacman-orchis-theme-full.sh

# Nome do pacote
PACOTE="orchis-theme"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
	gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
	gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
fi

# Nome do pacote
PACOTE="tela-circle-icon-theme-black"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-black"
	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Tela-circle-black"
fi

# Nome do pacote
PACOTE="vimix-cursors"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
	sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
fi

########################################################################################################
# pacote-pacman-steam_game-devices-udev.sh

# Instala o pacote game-devices-udev, que fornece regras udev para dispositivos de jogo (como controle, joystick, etc.)
# Dependẽncia para Steam versão Flatpak
# paru --needed --noconfirm -S game-devices-udev

########################################################################################################
# pacote-pacman-steam_instalar.sh

# Lista de pacotes
PACOTES=("steam-native-runtime" "steam")

# Variável para verificar se algum pacote está instalado
PACOTE_INSTALADO=false

# Loop para verificar cada pacote
for pacote in "${PACOTES[@]}"; do
	if verificar_pacote "$pacote"; then
		PACOTE_INSTALADO=true
		break
	fi
done

# Se pelo menos um dos pacotes estiver instalado, aplica a configuração
if $PACOTE_INSTALADO; then
	mkdir -p "$HOME/.config/autostart/"
	cp -av /usr/share/applications/steam-native.desktop "$HOME/.config/autostart/"
	sed -i 's|Exec=/usr/bin/steam-native %U|Exec=/usr/bin/steam-native %U -silent|' "$HOME/.config/autostart/steam-native.desktop"
	sudo sed -i '/en_US.UTF-8 UTF-8/s///' /etc/locale.gen
	grep 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' "$HOME/.pam_environment" && echo "Steam pam_environment OK!" || echo 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' >>"$HOME/.pam_environment"
	# shellcheck disable=SC2015
	grep 'STEAM_FRAME_FORCE_CLOSE' "/etc/environment" && echo "Steam force close OK!" || echo 'STEAM_FRAME_FORCE_CLOSE=1' | sudo tee -a "/etc/environment"
fi

########################################################################################################
# pacote-pacman-telegram_instalar.sh

# Nome do pacote
PACOTE="telegram-desktop"

# Verifica se o pacote está instalado
if verificar_pacote "$PACOTE"; then
	mkdir -p ~/.local/share/applications
	cp -rf /usr/share/applications/org.telegram.desktop.desktop ~/.local/share/applications/org.telegram.desktop.desktop
	sed -i '/Exec/s/\%u/\%u --hideStart/' ~/.local/share/applications/org.telegram.desktop.desktop
	cp -rf ~/.local/share/applications/org.telegram.desktop.desktop ~/.config/autostart/org.telegram.desktop.desktop
	chmod +x ~/.config/autostart/org.telegram.desktop.desktop
fi

########################################################################################################
# pacote-pacman-vscodium-ferramentas-cli.sh

# Instala os seguintes pacotes para análise e formatação de código:
# jq          Processador de JSON no terminal
# prettier    Formatador de código para várias linguagens
## shellcheck  Analisador estático para scripts shell
# shfmt       Formatador para scripts shell
# stylelint   Linter para arquivos CSS e preprocessadores como SCSS
# sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint

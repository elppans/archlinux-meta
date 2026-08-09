#!/usr/bin/env bash
# shellcheck disable=all

source /etc/os-release
source "$HOME"/.config/user-dirs.dirs

if [[ "$ID" == "arch" ]]; then
    echo "Arch Linux"
	DISTRO="arch"
elif [[ "$ID" =~ ^opensuse ]]; then
    echo "openSUSE"
	DISTRO="opensuse"
else
    echo "Outra distribuição ($ID)"
	exit 1
fi
export DISTRO

kora_icons() {
	cd /tmp
	git clone https://github.com/bikass/kora.git
	sudo cp -a /tmp/kora/{kora,kora-pgrey} /usr/share/icons/
	# cp -a /tmp/kora/{kora,kora-pgrey} "$HOME/.local/share/icons/"
}
orchis_theme() {
	echo "Configurando tema Orchis..."
	sleep 5
	echo "O tema será salvo em \"$XDG_PROJECTS_DIR\","
	echo "Para mudar algo no tema, masta usar o Script \"install.sh\"... "
	sleep 5
	cd "$XDG_PROJECTS_DIR" || exit 1
	git clone https://github.com/elppans/Orchis-theme.git
	cd "$XDG_PROJECTS_DIR"/Orchis-theme || exit 1
	# Garantindo que não tenha sugeira no usuário
	./install.sh -u &>/dev/null
	# compact = Desativa barra flutuante
	# submenu = Seta a cor do submenu para estilo Dark. Sem esta opção a cor do submenu é estilo Light
	# dock = Corrige estilo para extension 'dash-to-dock' ou 'ubuntu-dock'
	./install.sh --theme default --color dark --icon "$DISTRO" --libadwaita --fixed --tweaks submenu compact dock
	# Fix for Flatpak
	sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
}
bibata-cursor-theme() {
	mkdir -p /tmp/bibata-cursor-theme && cd /tmp/bibata-cursor-theme || exit 1
	curl -JOLk https://github.com/elppans/Bibata_Cursor/releases/download/v2.0.7/Bibata.tar.xz
	sudo mkdir -p /etc/skel/.local/share/icons/
	sudo tar -xJf Bibata.tar.xz -C /etc/skel/.local/share/icons/
	rsync -ah /etc/skel/. "$HOME/"
}

if [ "$(command -v pacman)" ]; then
	# Gerenciamento de pacotes e manutenção do sistema
	cd "$install"/helper/ || exit 1
	source helper_install.sh # Wrappers do pacman (AUR Helper)
	cd "$install" || exit 1
	# if ! pacman -Q yaru-sound-theme &>/dev/null; then
		# "${HELPER}" --needed --noconfirm -S yaru-sound-theme
	# fi
	if ! pacman -Q kora-icon-theme &>/dev/null; then
		kora_icons
	fi
	# if ! pacman -Q orchis-theme &>/dev/null; then
		orchis_theme # ativado orchis-theme da sessão pacman.list para completar a configuração de gsettings
	# fi
	if ! pacman -Q bibata-cursor-theme &>/dev/null; then
		bibata-cursor-theme
	fi
elif [ "$(command -v zypper)" ]; then
	sudo zypper --quiet --non-interactive refresh
	if ! zypper -q se -i sound-theme-yaru &>>/dev/null; then
		sudo zypper -n install sound-theme-yaru
	fi
	if ! zypper -q se -i kora-icon-theme &>>/dev/null; then
		sudo zypper -n install kora-icon-theme
	fi
	orchis_theme
	bibata-cursor-theme
else
	kora_icons
	orchis_theme
	bibata-cursor-theme
fi

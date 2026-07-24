#!/usr/bin/env bash
# shellcheck disable=all

kora_icons() {
	cd /tmp
	git clone https://github.com/bikass/kora.git
	sudo cp -a /tmp/kora/{kora,kora-pgrey} /usr/share/icons/
	# cp -a /tmp/kora/{kora,kora-pgrey} "$HOME/.local/share/icons/"
}
orchis_theme() {
	cd /tmp || exit 1
	git clone https://github.com/elppans/Orchis-theme.git
	cd /tmp/Orchis-theme || exit 1
	./install.sh -c dark -l -f -i opensuse --tweaks compact dock # primary = barra flutuante
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
	if ! pacman -Q yaru-sound-theme &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S yaru-sound-theme
	fi
	if ! pacman -Q kora-icon-theme &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S kora-icon-theme
	fi
	if ! pacman -Q orchis-theme &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S orchis-theme
	fi
	if ! pacman -Q bibata-cursor-theme &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S bibata-cursor-theme
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

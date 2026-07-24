#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1091

GSEPWD="$(pwd)"
export GSEPWD

gnome-shell-extension-appindicator() {
	mkdir -p /tmp/gnome-shell-extension-appindicator && cd /tmp/gnome-shell-extension-appindicator || exit 1
	curl -JOLk "https://github.com/ubuntu/gnome-shell-extension-appindicator/releases/download/v64/appindicatorsupport@rgcjonas.gmail.com.zip"
	gnome-extensions install appindicatorsupport@rgcjonas.gmail.com.zip
}
gnome-shell-extension-caffeine() {
	# https://github.com/eonpatapon/gnome-shell-extension-caffeine
	mkdir -p /tmp/gnome-shell-extension-caffeine && cd /tmp/gnome-shell-extension-caffeine || exit 1
	curl -JOLk "https://github.com/elppans/gnome-shell-extension-caffeine/releases/download/v60/caffeine@patapon.info.zip"
	gnome-extensions install caffeine@patapon.info.zip
}
dash-to-dock() {
	# https://github.com/micheleg/dash-to-dock
	mkdir -p /tmp/dash-to-dock && cd /tmp/dash-to-dock || exit 1
	curl -JOLk "https://github.com/micheleg/dash-to-dock/releases/download/extensions.gnome.org-v105/dash-to-dock@micxgx.gmail.com.zip"
	gnome-extensions install dash-to-dock@micxgx.gmail.com.zip
}
quick-sound-switcher() {
	# https://github.com/dustin-hawkins/quick-sound-switcher
	mkdir -p /tmp/quick-sound-switcher && cd /tmp/quick-sound-switcher || exit 1
	curl -JOLk "https://github.com/dustin-hawkins/quick-sound-switcher/releases/download/v1.0.1/quick-sound-switcher@dustin-hawkins-v1.0.1.shell-extension.zip"
	gnome-extensions install quick-sound-switcher@dustin-hawkins-v1.0.1.shell-extension.zip
}
enable-extensions() {
	# Ativar as 3 extensões instaladas
	gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'appindicatorsupport@rgcjonas.gmail.com', 'dash-to-dock@micxgx.gmail.com', 'quick-sound-switcher@dustin-hawkins']"
}

if [ "$(command -v pacman)" ]; then
	# Gerenciamento de pacotes e manutenção do sistema
	cd "$install"/helper/ || exit 1
	source helper_install.sh # Wrappers do pacman (AUR Helper)
	cd "$install" || exit 1
	if ! pacman -Q gnome-shell-extension-appindicator &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S gnome-shell-extension-appindicator
	fi
	if ! pacman -Q gnome-shell-extension-caffeine &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S gnome-shell-extension-caffeine
	fi
	if ! pacman -Q gnome-shell-extension-dash-to-dock &>/dev/null; then
		"${HELPER}" --needed --noconfirm -S gnome-shell-extension-dash-to-dock
	fi
	quick-sound-switcher
	enable-extensions
else
	gnome-shell-extension-appindicator
	gnome-shell-extension-caffeine
	dash-to-dock
	quick-sound-switcher
	enable-extensions
fi

#!/usr/bin/env bash
# shellcheck disable=SC2154,SC1091,SC2155,SC2001

GSEPWD="$(pwd)"
export GSEPWD

gnome_enable_ext() {
    local uuid="$1"
    
    # Lê as extensões ativas no formato array do GSettings
    local current=$(gsettings get org.gnome.shell enabled-extensions)
    
    # Verifica se já está na lista
    if [[ "$current" == *"$uuid"* ]]; then
        echo "Extensão $uuid já está habilitada."
        return 0
    fi

    # Formata a nova string de array injetando o novo UUID
    if [[ "$current" == "[]" ]]; then
        local updated="['$uuid']"
    else
        local updated=$(echo "$current" | sed "s/]/, '$uuid']/")
    fi

    # Escreve de volta no DConf
    gsettings set org.gnome.shell enabled-extensions "$updated"
    echo "Extensão $uuid habilitada com sucesso."
}
gnome-shell-extension-appindicator() {
	# https://github.com/ubuntu/gnome-shell-extension-appindicator
	local uuid="appindicatorsupport@rgcjonas.gmail.com"
	if gnome-extensions list --enabled | grep -qx "$uuid"; then
		echo "Extensão $uuid já está instalada e ativada."
		return 0
	fi
	mkdir -p /tmp/gnome-shell-extension-appindicator && cd /tmp/gnome-shell-extension-appindicator || exit 1
	curl -JOLk "https://github.com/ubuntu/gnome-shell-extension-appindicator/releases/download/v64/appindicatorsupport@rgcjonas.gmail.com.zip"
	gnome-extensions install --force "$uuid.zip"
	gnome-extensions enable "$uuid"
}
gnome-shell-extension-caffeine() {
	# https://github.com/eonpatapon/gnome-shell-extension-caffeine
	local uuid="caffeine@patapon.info"
	if gnome-extensions list --enabled | grep -qx "$uuid"; then
		echo "Extensão $uuid já está instalada e ativada."
		return 0
	fi
	mkdir -p /tmp/gnome-shell-extension-caffeine && cd /tmp/gnome-shell-extension-caffeine || exit 1
	curl -JOLk "https://github.com/elppans/gnome-shell-extension-caffeine/releases/download/v60/caffeine@patapon.info.zip"
	gnome-extensions install --force "$uuid.zip"
	gnome-extensions enable "$uuid"
}
dash-to-dock() {
	# https://github.com/micheleg/dash-to-dock
	local uuid="dash-to-dock@micxgx.gmail.com"
	if gnome-extensions list --enabled | grep -qx "$uuid"; then
		echo "Extensão $uuid já está instalada e ativada."
		return 0
	fi
	mkdir -p /tmp/dash-to-dock && cd /tmp/dash-to-dock || exit 1
	curl -JOLk "https://github.com/micheleg/dash-to-dock/releases/download/extensions.gnome.org-v105/dash-to-dock@micxgx.gmail.com.zip"
	gnome-extensions install --force "$uuid.zip"
	gnome-extensions enable "$uuid"
}
quick-sound-switcher() {
	# https://github.com/dustin-hawkins/quick-sound-switcher
	local uuid="quick-sound-switcher@dustin-hawkins"
	if gnome-extensions list --enabled | grep -qx "$uuid"; then
		echo "Extensão $uuid já está instalada e ativada."
		return 0
	fi
	mkdir -p /tmp/quick-sound-switcher && cd /tmp/quick-sound-switcher || exit 1
	curl -JOLk "https://github.com/dustin-hawkins/quick-sound-switcher/releases/download/v1.0.1/quick-sound-switcher@dustin-hawkins-v1.0.1.shell-extension.zip"
	gnome-extensions install --force "$uuid-v1.0.1.shell-extension.zip"
	gnome-extensions enable "$uuid"
}
enable-extensions() {
	# Ativar as extensões instaladas
	gnome_enable_ext "user-theme@gnome-shell-extensions.gcampax.github.com"
	gnome_enable_ext "appindicatorsupport@rgcjonas.gmail.com"
	gnome_enable_ext "caffeine@patapon.info"
	gnome_enable_ext "dash-to-dock@micxgx.gmail.com"
	gnome_enable_ext "quick-sound-switcher@dustin-hawkins"
	gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com', 'caffeine@patapon.info', 'appindicatorsupport@rgcjonas.gmail.com', 'dash-to-dock@micxgx.gmail.com', 'quick-sound-switcher@dustin-hawkins']"
}
helper(){
	bash <(curl -fsSL https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/helper/helper_install.sh)
}
install_enable() {
if [ "$(command -v pacman)" ]; then
	# Gerenciamento de pacotes e manutenção do sistema
	helper
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
}
gnome_extensions_guard() {
	# 1) Verifica se o GNOME está instalado (procura pelo gnome-shell)
	command -v gnome-shell &>/dev/null || return 0

	# 2) Verifica se a sessão logada atual é do GNOME
	# shellcheck disable=SC2034
	local session="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"
	[[ "${XDG_CURRENT_DESKTOP,,}" == *gnome* ]] || [[ "${DESKTOP_SESSION,,}" == *gnome* ]] || return 0

	# 3) Verifica se o comando gnome-extensions existe
	command -v gnome-extensions &>/dev/null || return 0

	# 4) Verifica se o comando gsettings existe
	command -v gsettings &>/dev/null || return 0

	# 5) Verifica se o comando curl existe
	command -v curl &>/dev/null || return 0

	# 6) Tudo OK, executa a função principal
	install_enable
}

gnome_extensions_guard
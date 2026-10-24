#!/usr/bin/env bash
set -euo pipefail

helper() {
	# --[no]removemake       Remove dependências de compilação após instalação
	# --[no]sudoloop         Repete chamadas sudo em segundo plano para evitar esgotar o tempo
	# --[no]keepsrc          Mantém diretórios src/ e pkg/ após compilar pacotes
	# yay/paru {-B --build}       [diretório(s)]

	# -C, --cleanbuild Remove o diretório $srcdir/ antes de compilar o pacote
	# -r, --rmdeps     Remove dependências instaladas após uma compilação bem-sucedida
	# -i, --install    Instala pacote após empacotamento bem-sucedido
	# -s, --syncdeps   Instala dependências em falta com pacman

	if [ "$(command -v yay)" ]; then
		yay --needed --noconfirm --removemake --sudoloop
	elif [ "$(command -v paru)" ]; then
		paru --needed --noconfirm --removemake --sudoloop --nokeepsrc
	else
		echo "Helper não encontrado, instale o yay ou o paru"
	fi
}

gnome-shell-extension-gnome-ui-tune_aur() {
if ! pacman -Qi gnome-shell-extension-gnome-ui-tune-git &>/dev/null; then
	echo "==> [2/3] Compilando accent-color-change do Manjaro PKGBUILDS..."
	BUILD_DIR="$(mktemp -d)"
	trap 'rm -rf "${BUILD_DIR}"' EXIT
	cd "${BUILD_DIR}" || exit 1
	# https://github.com/elppans/gnome-shell-extension-gnome-ui-tune.git
	RAW_URI="https://raw.githubusercontent.com/elppans/gnome-shell-extension-gnome-ui-tune/refs/heads/main"
	curl -sSLO "${RAW_URI}/PKGBUILD"
	curl -sSLO "${RAW_URI}/LICENSE"
	makepkg --needed --noconfirm -Cris
	cd -  || exit 1
else
	echo "==> [2/3] gnome-shell-extension-gnome-ui-tune-git já está instalado. Pulando build."
fi
}

DEPENDENCY=(
	# Dependências para "accent-color-change"
	adw-gtk-theme
	papirus-folders

	# Dependências para "gnome-layout-switcher"
	# accent-color-change # Compilado manualmente no passo 2
	addwater
	gdm-settings
	gnome-console
	gnome-shell
	gnome-shell-extension-appindicator
	gnome-shell-extension-arc-menu
	gnome-shell-extension-dash-to-dock
	gnome-shell-extension-dash-to-panel
	gnome-shell-extension-forge
	# gnome-shell-extension-gnome-ui-tune
	gnome-shell-extension-gtk4-desktop-icons-ng
	gnome-shell-extension-space-bar
	gnome-tweaks
	gtk3
	polkit
	python-click
	python-gobject
)

# Instalar extensão gnome-ui-tune
gnome-shell-extension-gnome-ui-tune_aur

# 1. Instalar dependências disponíveis via Arch/AUR
echo "==> [1/3] Instalando dependências do sistema via Helper..."
yay -S "${DEPENDENCY[@]}"

# 2. Compilar accent-color-change se não estiver presente
if ! pacman -Qi accent-color-change &>/dev/null; then
	echo "==> [2/3] Compilando accent-color-change do Manjaro PKGBUILDS..."
	BUILD_DIR="$(mktemp -d)"
	trap 'rm -rf "${BUILD_DIR}"' EXIT
	cd "${BUILD_DIR}"

	RAW_URI="https://raw.githubusercontent.com/manjaro/PKGBUILDs/refs/heads/main/extra/accent-color-change"
	curl -sSLO "${RAW_URI}/PKGBUILD"
	curl -sSLO "${RAW_URI}/maia-accent-color.patch"
	makepkg --needed --noconfirm -Cris
else
	echo "==> [2/3] accent-color-change já está instalado. Pulando build."
fi

# 3. Instalar o pacote binário do gnome-layout-switcher
echo "==> [3/3] Baixando e instalando gnome-layout-switcher (bypassing pamac-gtk)..."
# MIRROR_URI="https://linorg.usp.br/manjaro/stable/extra/x86_64"
MIRROR_URI="https://github.com/elppans/gnome-layout-switcher/releases/download/0.8.40-2"
PACKAGE_NAME="gnome-layout-switcher-0.8.40-2-any.pkg.tar.zst"

curl -sSLO "${MIRROR_URI}/${PACKAGE_NAME}"
yay --assume-installed pamac-gtk -U "${PACKAGE_NAME}"

sleep 5
if [ -f "/usr/lib/python3.14/site-packages/layoutswitcherlib/layoutsbox.py" ]; then
	# Troca do ícone Manjaro pelo ícone Arch para o menú "Tradicional" do Layout Switcher
	# gsettings set org.gnome.shell.extensions.arcmenu menu-button-icon "resource:///org/gnome/shell/extensions/arcmenu/icons/scalable/actions/distro-manjaro-symbolic.svg"
	# gsettings set org.gnome.shell.extensions.arcmenu menu-button-icon 'resource:///org/gnome/shell/extensions/arcmenu/icons/scalable/actions/distro-arch.svg'
	sudo cp -a /usr/lib/python3.14/site-packages/layoutswitcherlib/layoutsbox.py /usr/lib/python3.14/site-packages/layoutswitcherlib/layoutsbox.py.backup_"$(date +%Y%m%d%H%M)"
	sudo sed -i 's/distro-manjaro-symbolic.svg/distro-arch.svg/g' /usr/lib/python3.14/site-packages/layoutswitcherlib/layoutsbox.py
fi

echo "==> Instalação concluída com sucesso!"

#!/bin/bash

gnome_shel_set() {
# Ajustes de configurações via dconf

# Configurações do Menú Gnome
# Para verificar qual o nome da categoria, verificar os arquivos .directory em "/usr/share/desktop-directories/"

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Console.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['Games', 'Graphics', 'Multimedia', 'Network', 'Office', 'System', 'Utilities', 'Development', 'WebApps']"

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ name 'Game.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ categories "['Game']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Graphics.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ categories "['Viewer','Graphics','RasterGraphics','2DGraphics','Photography','VectorGraphics','Scanning']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ name 'AudioVideo.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ categories "['Music','Audio','AudioVideo','AudioVideoEditing','Player','Video']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Network.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ categories "['Network', 'FileTransfer', 'X-GNOME-NetworkSettings']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ name 'Office.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ categories "['Office']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Office/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ name 'X-GNOME-Shell-System.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ categories "['System', 'X-GNOME-System', 'Settings']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'X-GNOME-Shell-Utilities.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ categories "['Utility', 'X-GNOME-Utilities']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ name 'Development.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ categories "['Development']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Development/ translate true

gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/WebApps/ name 'WebApps'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/WebApps/ categories "['WebApps']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/WebApps/ translate false

# Restaura o layout padrão do menu de aplicativos (app-picker) do GNOME.
xdg-desktop-menu forceupdate
update-desktop-database "$HOME/.local/share/applications"
gsettings reset org.gnome.shell app-picker-layout

# Outras configurações

# Trancar icon-theme
# 1. Certifique-se de criar o diretório de locks
# sudo mkdir -p /etc/dconf/db/local.d/locks

# 2. Defina o valor padrão
# sudo mkdir -p /etc/dconf/db/local.d
# cat << 'EOF' | sudo tee /etc/dconf/db/local.d/00-icon-theme
# [org/gnome/desktop/interface]
# icon-theme='kora'
# EOF

# 3. Bloqueie a alteração por outros processos
# cat << 'EOF' | sudo tee /etc/dconf/db/local.d/locks/icon-theme
# /org/gnome/desktop/interface/icon-theme
# EOF

# 4. Atualize a base dconf
# sudo dconf update
}

gnome_shell_set_guard() {
	# 1) Verifica se o GNOME está instalado (procura pelo gnome-shell)
	command -v gnome-shell &>/dev/null || return 0

	# 2) Verifica se a sessão logada atual é do GNOME
	# shellcheck disable=SC2034
	local session="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"
	[[ "${XDG_CURRENT_DESKTOP,,}" == *gnome* ]] || [[ "${DESKTOP_SESSION,,}" == *gnome* ]] || return 0

	# 3) Verifica se o comando xdg-desktop-menu existe
	command -v xdg-desktop-menu &>/dev/null || return 0

	# 4) Verifica se o comando gsettings existe
	command -v gsettings &>/dev/null || return 0

	# 5) Verifica se o comando update-desktop-database existe
	command -v update-desktop-database &>/dev/null || return 0

	# 6) Tudo OK, executa a função principal
	gnome_shel_set
}
gnome_shell_set_guard &>/dev/null
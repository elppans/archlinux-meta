#!/bin/bash

# Ajustes de configurações via dconf

# Configurações do Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

# Ajustes de configurações via gsettings

# Temas e Configurações Gnome
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
# gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
# gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
# gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
# gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
# gsettings set org.gnome.desktop.sound theme-name "Yaru"

# Configurações gerais do Gnome
gsettings set org.gnome.Console transparency true
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.shell.weather automatic-location true
gsettings set org.gnome.shell.extensions.window-list grouping-mode 'auto'

# Temas e Configurações GDM
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Yaru-blue-dark"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-weekday true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-seconds true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface show-battery-percentage true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
# sudo systemctl restart gdm

# Configurações do Menú Gnome

# Para verificar qual o nome da categoria, verificar os arquivos .directory em "/usr/share/desktop-directories/"

gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Console.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['Games', 'Graphics', 'Multimedia', 'Network', 'Office', 'System', 'Utilities']"

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

# Restaura o layout padrão da menu de aplicativos (app-picker) do GNOME.
# Remove alterações personalizadas e reorganiza os ícones em categorias padrão.
gsettings reset org.gnome.shell app-picker-layout
xdg-desktop-menu forceupdate
update-desktop-database ~/.local/share/applications

# Configurações diretas

# Trocar o ícone do Gnome Text Editor e padronizando em "skel" (O ícone do TextEditor é MUITO FEIO)
sudo sed -i 's/^Icon=.*/Icon=gedit/' "/usr/share/applications/org.gnome.TextEditor.desktop"
sudo mkdir -p "/etc/skel/.local/share/applications"
mkdir -p "$HOME/.local/share/applications"
sudo cp "/usr/share/applications/org.gnome.TextEditor.desktop" "/etc/skel/.local/share/applications"
cp "/usr/share/applications/org.gnome.TextEditor.desktop" "$HOME/.local/share/applications"

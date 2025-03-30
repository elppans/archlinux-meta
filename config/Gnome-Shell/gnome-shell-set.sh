#!/bin/bash

# Ajustes de configurações via dconf

# Configurações do Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
# dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

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
sudo systemctl restart gdm

# Configurações do Menú Gnome
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.Console.desktop']"
gsettings set org.gnome.desktop.app-folders folder-children "['Accessories', 'Games', 'Graphics', 'Multimedia', 'Network', 'Pardus', 'Settings', 'System', 'Utilities', 'YaST']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ name 'Accessories'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ apps "['com.github.marktext.marktext.desktop', 'yelp.desktop', 'org.gnome.Tour.desktop', 'vim.desktop', 'org.kde.kate.desktop', 'org.gnome.Calculator.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Accessories/ translate true
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ name 'Games'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ apps "['net.lutris.Lutris.desktop', 'com.valvesoftware.Steam.desktop', 'com.heroicgameslauncher.hgl.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Games/ translate true
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ name 'Graphics'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ apps "['org.gnome.gThumb.desktop', 'org.flameshot.Flameshot.desktop', 'simple-scan.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Graphics/ translate true
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ name 'Multimedia'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ apps "['mystiq.desktop', 'org.gnome.Rhythmbox3.desktop', 'qvidcap.desktop', 'qv4l2.desktop', 'org.gnome.Totem.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Multimedia/ translate true
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ name 'Network'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ apps "['bssh.desktop', 'bvnc.desktop', 'avahi-discover.desktop', 'org.remmina.Remmina.desktop', 'com.rtosta.zapzap.desktop', 'org.telegram.desktop.desktop', 'com.microsoft.Edge.desktop', 'com.discordapp.Discord.desktop', 'de.haeckerfelix.Fragments.desktop']"
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Network/ translate true
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Settings/ name 'Settings'
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Settings/ translate true
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ name 'System'
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/System/ translate true
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilitie/ name 'Utilitie'
# gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilitie/ translate true

# Configurações diretas

# Trocar o ícone do Gnome Text Editor e padronizando em "skel"
sudo sed -i 's/^Icon=.*/Icon=gedit/' "/usr/share/applications/org.gnome.TextEditor.desktop"
sudo mkdir -p "/etc/skel/.local/share/applications"
mkdir -p "$HOME/.local/share/applications"
sudo cp "/usr/share/applications/org.gnome.TextEditor.desktop" "/etc/skel/.local/share/applications"
cp "/usr/share/applications/org.gnome.TextEditor.desktop" "$HOME/.local/share/applications"

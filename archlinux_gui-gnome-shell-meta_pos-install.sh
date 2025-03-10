#!/bin/bash
# shellcheck disable=SC2027,SC2046,SC2002,SC2016

# Atualização do sistema
sudo pacman --needed --noconfirm -Syyu

# Instalação de pacotes para desenvolvimento
sudo pacman --needed --noconfirm -S base-devel git

# Complementos para o pacman
sudo pacman --needed --noconfirm -S expac pkgfile
sudo pkgfile -u

# Wrappers do pacman (AUR Helper)
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin || exit
makepkg --needed --noconfirm -Cris

# Gerenciador de pacotes Flatpak
sudo pacman --needed --noconfirm -S flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Remoção de aplicativos
sudo pacman --noconfirm -R epiphany gnome-music loupe

# Instalação de pacotes via pacman

## Pacote para vídeo em QEMU/KVM/Virt Manager
# sudo pacman --needed --noconfirm -S xf86-video-qxl

## Complementos do GNOME
sudo pacman --needed --noconfirm -S cheese file-roller fragments gnome-firmware gthumb power-profiles-daemon rhythmbox

sudo pacman --needed --noconfirm -S ""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')""

## Extensões do GNOME
sudo pacman --needed --noconfirm -S gnome-shell-extension-appindicator gnome-shell-extension-caffeine

## Funcionalidades do Nautilus
sudo pacman --needed --noconfirm -S nautilus-image-converter nautilus-share

## Demais aplicações
sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint wine-staging winetricks

# Instalação de pacotes via AUR

## Aplicativos
paru --needed --noconfirm -S mystiq
paru --needed --noconfirm -S actions-for-nautilus-git gtkhash meld xclip

## Configuração do Actions for Nautilus
mkdir -p "$HOME/.local/share/actions-for-nautilus"
curl -JLk -o "$HOME/.local/share/actions-for-nautilus/config.json" "https://raw.githubusercontent.com/elppans/actions-for-nautilus/refs/heads/main/configurator/sample-config.json"
sed -i 's/gnome-terminal/gnome-console/g' "$HOME/.local/share/actions-for-nautilus/config.json"
sed -i 's/gedit/gnome-text-editor/g' "$HOME/.local/share/actions-for-nautilus/config.json"
nautilus -q

## Temas do GNOME Shell
paru --needed --noconfirm -Syyu --batchinstall --skipreview --removemake --mflags -Cris inkscape xorg-server-xvfb \
yaru-gnome-shell-theme yaru-gtk-theme yaru-icon-theme yaru-metacity-theme yaru-session yaru-sound-theme yaru-unity-theme yaru-xfwm4-theme
# || \
echo "Reinicie o sistema e rode o Script novamente!" && exit 1

# Instalação de pacotes via Flatpak

## Aplicativos
sudo flatpak -y install com.github.marktext.marktext
sudo flatpak -y install io.github.realmazharhussain.GdmSettings
sudo flatpak -y install com.microsoft.Edge
sudo flatpak -y install com.rtosta.zapzap
sudo flatpak -y install com.vscodium.codium && export VSCODIUM="1"
sudo flatpak -y install io.dbeaver.DBeaverCommunity
# sudo flatpak -y install me.dusansimic.DynamicWallpaper
sudo flatpak -y install org.kde.kate

## Pacotes Flatpak comentados (para ativação posterior)
# sudo flatpak install -y flathub com.anydesk.Anydesk
sudo flatpak install -y flathub com.github.maoschanz.DynamicWallpaperEditor
# sudo flatpak install -y flathub com.google.Chrome
# sudo flatpak install -y flathub com.rustdesk.RustDesk
# sudo flatpak install -y com.opera.Opera
# sudo flatpak install -y com.vivaldi.Vivaldi

# Ajustes de configurações via dconf

## Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

# Ajustes de configurações via gsettings

## Temas 
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell.extensions.user-theme name "Yaru-prussiangreen-dark"
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-prussiangreen-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-prussiangreen-dark"
gsettings set org.gnome.desktop.sound theme-name "Yaru"

## Temas e Configurações GDM
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Yaru-prussiangreen-dark"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Yaru-prussiangreen-dark"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-weekday true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-seconds true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
sudo systemctl restart gdm

## Outras configurações
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Configuração do SAMBA

## Configuração do arquivo smb.conf
sudo curl -JLk -o /etc/samba/smb.conf "https://git.samba.org/samba.git/?p=samba.git;a=blob_plain;f=examples/smb.conf.default;hb=HEAD"
sudo sed -i -E 's/(log file = ).*/\1\/var\/log\/samba\/%m.log/' /etc/samba/smb.conf
sudo sed -i -E '/log file = /a logging = systemd' /etc/samba/smb.conf
sudo sed -i -E 's/(workgroup =).*/\1 WORKGROUP/' /etc/samba/smb.conf

## Configuração de compartilhamentos de usuários
sudo mkdir -m 1770 -p /var/lib/samba/usershares
sudo groupadd -r sambashare
sudo chown root:sambashare /var/lib/samba/usershares
sudo usermod -aG sambashare "$USER"
sudo sed -i -E '/Share Definitions/i \
usershare path = /var/lib/samba/usershares\n\
usershare max shares = 100\n\
usershare allow guests = yes\n\
usershare owner only = yes\n' /etc/samba/smb.conf

## Habilitar e configurar serviços
sudo systemctl enable --now nmb smb
echo 'arch' | sudo -S smbpasswd -a "$USER"

# Finalizando com Scripts

## Configuração do VSCodium
if [ "$VSCODIUM" -eq 1 ]; then
    echo "VSCodium selecionado! Executando configuração..."
    cd || exit
    echo -e 'alias codium="flatpak run com.vscodium.codium "' | tee -a "$HOME"/.bashrc
    alias codium="flatpak run com.vscodium.codium "
    mkdir -p "$HOME/.config/VSCodium/User"
    curl -JLk -o /tmp/vscodium_backup.tar.gz "https://github.com/elppans/vscodeum/raw/refs/heads/main/vscodium_backup/vscodium_backup_20250226_170128.tar.gz"
    tar -xzf /tmp/vscodium_backup.tar.gz -C "$HOME"/.config/VSCodium/User/
    # cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 codium --install-extension
    cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 flatpak run com.vscodium.codium --install-extension
fi

## Action Script, conversão de imagens
git clone https://github.com/elppans/el-images.git /tmp/el-images
cd /tmp/el-images || exit
./install.sh
cd || exit

## Modelos de arquivos
git clone https://github.com/elppans/ubuntu_file_templates.git /tmp/file_templates
cp -a /tmp/file_templates/* "$(xdg-user-dir TEMPLATES)"

## Gnome Shell Extensions Manager
echo -e 'PATH="$PATH:$HOME/.local/bin"' | tee -a "$HOME"/.bashrc
mkdir -p "$HOME"/.local/bin
mkdir -p "$HOME"/.config/autostart
mkdir -p "$HOME"/.local/share/gnome-shell
wget -c "https://raw.githubusercontent.com/elppans/gnome-shell-extensions_manager/refs/heads/main/gnome-shell-extensions_manager.sh" -P "$HOME"/.local/bin
chmod +x "$HOME"/.local/bin/gnome-shell-extensions_manager.sh
echo -e '\n"$HOME"/.local/bin/gnome-shell-extensions_manager.sh &>>/dev/null\n' | tee -a "$HOME"/.bash_profile
touch "$HOME"/.local/share/gnome-shell/extensions.list
echo -e 'caffeine@patapon.info
appindicatorsupport@rgcjonas.gmail.com
user-theme@gnome-shell-extensions.gcampax.github.com' | tee "$HOME"/.local/share/gnome-shell/extensions.list
cat "$HOME"/.local/share/gnome-shell/extensions.list

## GDM Settings (Em edição)
# /etc/dconf/db/gdm.d/95-gdm-settings
# Exportar as customizações do GDM via dconf
# sudo -u gdm dbus-launch dconf dump / > gdm-settings.ini
# Importar as customizações no GDM
# sudo -u gdm dbus-launch dconf load / < gdm-settings.ini

## Plano de fundo Gnome (Em edição)
# /usr/share/backgrounds/gnome/

# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

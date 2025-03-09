#!/bin/bash

# Atualização do sistema
sudo pacman --needed --noconfirm -Syyu

# Instalação de pacotes para desenvolvimento
sudo pacman --needed --noconfirm -S base-devel git

# Complementos para o pacman
sudo pacman --needed --noconfirm -S expac pkgfile
sudo pkgfile -u

# Wrappers do pacman (AUR Helper)
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin
makepkg -Cris

# Remoção de aplicativos
sudo pacman --noconfirm -R gnome-music loupe

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
paru --needed --noconfirm -S --batchinstall --skipreview --removemake --mflags -Cris inkscape xorg-server-xvfb yaru-gnome-shell-theme

# Instalação de pacotes via Flatpak

## Aplicativos
sudo flatpak -y install com.github.marktext.marktext
sudo flatpak -y install com.github.realmazharhussain.GdmSettings
sudo flatpak -y install com.microsoft.Edge
sudo flatpak -y install com.rtosta.zapzap
sudo flatpak -y install com.vscodium.codium && export VSCODIUM="1"
sudo flatpak -y install io.dbeaver.DBeaverCommunity
sudo flatpak -y install me.dusansimic.DynamicWallpaper
sudo flatpak -y install org.kde.kate

## Pacotes Flatpak comentados (para ativação posterior)
# sudo flatpak install -y flathub com.anydesk.Anydesk
# sudo flatpak install -y flathub com.github.maoschanz.DynamicWallpaperEditor
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
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-olive-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-olive-dark"

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
sudo usermod -aG sambashare $USER
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
    cd
    mkdir -p "$HOME/.config/VSCodium/User"
    curl -JLk -o /tmp/vscodium_backup.tar.gz "https://github.com/elppans/vscodeum/raw/refs/heads/main/vscodium_backup/vscodium_backup_20250226_170128.tar.gz"
    tar -xzf /tmp/vscodium_backup.tar.gz -C "$HOME"/.config/VSCodium/User/
    cat "$HOME"/.config/VSCodium/User/extensions_list.txt | xargs -L 1 codium --install-extension
fi

## Action Script, conversão de imagens
git clone https://github.com/elppans/el-images.git /tmp/el-images
cd /tmp/el-images
./install.sh
cd

## Modelos de arquivos
git clone https://github.com/elppans/ubuntu_file_templates.git /tmp/file_templates
cp -a /tmp/file_templates/* "$(xdg-user-dir TEMPLATES)"

## Gnome Shell Extensions Manager
echo -e 'PATH="$PATH:$HOME/.local/bin"' | tee -a $HOME/.bashrc
mkdir -p "$HOME"/.local/bin
mkdir -p "$HOME"/.config/autostart
wget -c "https://raw.githubusercontent.com/elppans/gnome-shell-extensions_manager/refs/heads/main/gnome-shell-extensions_manager.sh" -P "$HOME"/.local/bin
chmod +x "$HOME"/.local/bin/gnome-shell-extensions_manager.sh
echo -e '\n"$HOME"/.local/bin/gnome-shell-extensions_manager.sh\n' | tee -a $HOME/.bash_profile
echo -e 'caffeine@patapon.info
appindicatorsupport@rgcjonas.gmail.com' | tee "$HOME"/.local/share/gnome-shell/extensions.list
cat "$HOME"/.local/share/gnome-shell/extensions.list


# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

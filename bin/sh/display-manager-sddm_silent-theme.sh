#!/bin/bash
# shellcheck disable=all
#
# https://github.com/uiriansan/SilentSDDM

# Para testar temas do pacote SilentSDDM, deve ir no diretório "/usr/share/sddm/themes/silent/" e executar o Script "test.sh"
# Para mudar o tema, deve editar o arquivo "metadata.desktop", escolher a linha com "ConfigFile=", descomentar e comentar o atual.

sudo pacman -Sy --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
mkdir -p "$HOME/build"
cd "$HOME/build" || exit 1
git clone https://aur.archlinux.org/sddm-silent-theme.git
cd sddm-silent-theme
makepkg -Cris
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable sddm.service

if [ -d /etc/sddm.conf ]; then
    sudo cp -a /etc/sddm.conf /etc/sddm.conf.backup_"$(date +%Y%m%d%H%M%S)"
fi

echo -e '# Make sure these options are correct:
    [General]
    InputMethod=qtvirtualkeyboard
    GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

    [Theme]
    Current=silent' | sudo tee /etc/sddm.conf


curl -JLk -o /etc/profile.d/silent-sddm-switch_theme.sh 'https://raw.githubusercontent.com/elppans/sddm-silent-customizer/refs/heads/main/etc/profile.d/sddm-silent-customizer.sh'

grep sddm /etc/group || sudo groupadd sddm
groups $USER | grep -q '\bsddm\b' || sudo usermod -aG sddm $USER
sudo chgrp sddm /usr/share/sddm/themes/silent
sudo chmod 0755 /usr/share/sddm/themes/silent
sudo chgrp sddm /usr/share/sddm/themes/silent/metadata.desktop
sudo chmod 664 /usr/share/sddm/themes/silent/metadata.desktop
sudo chmod +x /etc/profile.d/silent-sddm-switch_theme.sh
sudo ln -sf /etc/profile.d/silent-sddm-switch_theme.sh /usr/local/bin/silent-sddm-switch_theme

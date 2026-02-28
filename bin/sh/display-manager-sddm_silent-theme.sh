#!/bin/bash
#
# https://github.com/uiriansan/SilentSDDM

Para testar temas do pacote SilentSDDM, deve ir no diretório "/usr/share/sddm/themes/silent/" e executar o Script "test.sh"
Para mudar o tema, deve editar o arquivo "metadata.desktop", escolher a linha com "ConfigFile=", descomentar e comentar o atual.

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

echo -e '#!/bin/bash

# Path to the metadata.desktop file
FILE="/usr/share/sddm/themes/silent/metadata.desktop"

# Detects system language
if [[ "$LANG" == pt* ]]; then
    MSG_COMMENTED="Linha ativa comentada."
    MSG_CHANGED="Tema alterado com sucesso!"
    MSG_ACTIVE="Linha ativa agora:"
else
    MSG_COMMENTED="Active line commented."
    MSG_CHANGED="Theme successfully changed!"
    MSG_ACTIVE="Active line now:"
fi

# Get all lines with "ConfigFile="
mapfile -t configs < <(grep -n "ConfigFile=" "$FILE")

# Identifies the active line (without a # at the beginning)
active_line=$(grep -n "^[[:space:]]*ConfigFile=" "$FILE" | cut -d: -f1)

# Comment on the active line
if [[ -n "$active_line" ]]; then
    sed -i "${active_line}s/^/  #/" "$FILE"
    echo "$MSG_COMMENTED"
fi

# Randomly select another line
random_line=$(printf "%s\n" "${configs[@]}" | shuf -n 1 | cut -d: -f1)

# Uncomment on the chosen line
sed -i "${random_line}s/^#//" "$FILE"

# Displays final result
echo "$MSG_CHANGED"
echo "$MSG_ACTIVE"
grep "^[[:space:]]*ConfigFile=" "$FILE"
' | sudo tee /etc/profile.d/silent-sddm-switch_theme.sh

grep sddm /etc/group || sudo groupadd sddm
groups $USER | grep -q '\bsddm\b' || sudo usermod -aG sddm $USER
sudo chgrp sddm /usr/share/sddm/themes/silent
sudo chgrp sddm /usr/share/sddm/themes/silent/metadata.desktop
sudo chmod 664 /usr/share/sddm/themes/silent/metadata.desktop
sudo chmod +x /etc/profile.d/silent-sddm-switch_theme.sh
sudo ln -sf /etc/profile.d/silent-sddm-switch_theme.sh /usr/local/bin/silent-sddm-switch_theme

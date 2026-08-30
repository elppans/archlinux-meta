#!/bin/bash
# shellcheck disable=all
#
# https://github.com/uiriansan/SilentSDDM

# Para testar temas do pacote SilentSDDM, deve ir no diretório "/usr/share/sddm/themes/silent/" e executar o Script "test.sh"
# Para mudar o tema, deve editar o arquivo "metadata.desktop", escolher a linha com "ConfigFile=", descomentar e comentar o atual.

# Verifica se o pacote 'sddm' está instalado no sistema via pacman
if pacman -Qs "^sddm$" &>/dev/null; then
	echo "[+] SDDM detectado. Aplicando customizações..."
	sleep 5
	# sudo pacman -Sy --needed --noconfirm sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg qt6-imageformats
	# mkdir -p "$HOME/build"
	# cd "$HOME/build" || exit 1
	# git clone https://aur.archlinux.org/sddm-silent-theme.git
	# cd sddm-silent-theme
	# makepkg -Cris

if [ -d "$HOME/build/SilentSDDM" ]; then
	cd "$HOME/build/SilentSDDM" || exit 1
	git fetch origin
	git reset --hard origin/main
	git clean -fd
	./install.sh
else
	mkdir -p "$HOME/build"
	cd "$HOME/build" || exit 1
	git clone -b main --depth=1 https://github.com/uiriansan/SilentSDDM && cd SilentSDDM && ./install.sh
fi
	if [ -f /etc/sddm.conf ]; then
		sudo cp -a /etc/sddm.conf /etc/sddm.conf.backup_"$(date +%Y%m%d%H%M%S)"

		sudo tee /etc/sddm.conf &>>/dev/null <<'EOF'
# Make sure these options are correct:
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
EOF
	else
		sudo tee /etc/sddm.conf &>>/dev/null <<'EOF'
# Make sure these options are correct:
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=silent
EOF
	fi

	# shellcheck disable=SC2046
	sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
	systemctl is-enabled display-manager.service && sudo systemctl disable display-manager.service
	systemctl is-enabled sddm.service || sudo systemctl enable sddm.service

	# Script para usar com "SDDM-Silent-Theme"
	if pacman -Qqs sddm-silent-theme; then
		mkdir -p "$HOME/build/sddm-silent-random"
		wget -O "$HOME/build/sddm-silent-random/PKGBUILD" "https://raw.githubusercontent.com/elppans/sddm-silent-random/refs/heads/main/PKGBUILD" || exit 1
		cd "$HOME/build/sddm-silent-random" || exit 1
		makepkg -Cris || exit 1
	else
		if [ -d /usr/share/sddm/themes/silent/ ]; then
			sudo rm -rf /usr/local/bin/sddm-silent-random /etc/systemd/system/sddm-silent-random.service &>>/dev/null
			sudo curl -JLk -o /usr/local/bin/sddm-silent-random 'https://raw.githubusercontent.com/elppans/sddm-silent-random/refs/heads/main/usr/local/bin/sddm-silent-random'
			sudo curl -JLk -o /etc/systemd/system/sddm-silent-random.service 'https://raw.githubusercontent.com/elppans/sddm-silent-random/refs/heads/main/etc/systemd/system/sddm-silent-random.service'
		fi
	fi

	grep sddm /etc/group || sudo groupadd sddm
	groups $USER | grep -q '\bsddm\b' || sudo usermod -aG sddm $USER
	sudo chgrp sddm /usr/share/sddm/themes/silent
	sudo chmod 0755 /usr/share/sddm/themes/silent
	sudo chgrp sddm /usr/share/sddm/themes/silent/metadata.desktop
	sudo chmod 664 /usr/share/sddm/themes/silent/metadata.desktop
	# sudo chmod +x /etc/profile.d/sddm-silent-random.sh
	# sudo ln -sf /etc/profile.d/sddm-silent-random.sh /usr/local/bin/sddm-silent-random
	sudo chmod +x /usr/local/bin/sddm-silent-random
	sudo systemctl daemon-reload
	sudo systemctl enable sddm-silent-random.service

	sleep 5
	echo "[+] Configuração customizada do SDDM aplicada com sucesso."
	sleep 5
else
	sleep 5
	echo "[-] SDDM não está instalado no sistema. Ignorando etapas de configuração."
	sleep 5
	# exit 0
fi

# faceconv está na lista de pkgbuilds_git.sh

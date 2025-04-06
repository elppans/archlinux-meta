#!/bin/bash

########################################################################################################
pacote-pacman-apparmor-instalar.sh
#!/bin/bash
# Script para instalar e configurar o AppArmor no Arch Linux

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

echo "Atualizando o sistema..."
sudo pacman -Syu --noconfirm

echo "Instalando os pacotes necessários: apparmor, apparmor-utils e apparmor-profiles..."
sudo pacman -S --noconfirm apparmor apparmor-utils apparmor-profiles

# Configura os parâmetros do kernel no GRUB
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then
	echo "Configurando os parâmetros do GRUB para habilitar o AppArmor..."
	# Se os parâmetros já não estiverem presentes, adiciona-os
	if ! grep -q "apparmor=1" "$GRUB_FILE"; then
		sudo sed -i 's/^\(GRUB_CMDLINE_LINUX_DEFAULT="\)/\1apparmor=1 security=apparmor /' "$GRUB_FILE"
		echo "Parâmetros adicionados no GRUB_CMDLINE_LINUX_DEFAULT."
	else
		echo "Parâmetros do AppArmor já configurados no GRUB_CMDLINE_LINUX_DEFAULT."
	fi

	echo "Atualizando a configuração do GRUB..."
	sudo grub-mkconfig -o /boot/grub/grub.cfg
else
	echo "Arquivo $GRUB_FILE não encontrado. Se você não utiliza o GRUB, adicione os parâmetros 'apparmor=1 security=apparmor' manualmente no seu bootloader."
fi

# Habilita e inicia o serviço do AppArmor
echo "Habilitando e iniciando o serviço do AppArmor..."
sudo systemctl enable apparmor.service
sudo systemctl start apparmor.service

echo "Status atual do serviço AppArmor:"
sudo systemctl status apparmor.service --no-pager

echo "Instalação e configuração do AppArmor concluída."
########################################################################################################
pacote-pacman-flameshot.sh
#!/bin/bash
# shellcheck disable=SC2016,SC2027,SC2046

sudo pacman --noconfirm -R xf86-video-intel 
sudo pacman --needed --noconfirm -S flameshot
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" flameshot | tr ' ' '\n')""  

# Flameshot em Wayland (Movido para o diretório bin)
# echo -e '#!/bin/bash

# options=("$@")
# export QT_QPA_PLATFORM=wayland
# export QT_SCREEN_SCALE_FACTORS="1;1"

# /usr/bin/flameshot "${options[@]}"
# ' | sudo tee /usr/local/bin/flameshot

sudo cp -a /usr/share/applications/org.flameshot.Flameshot.desktop /etc/skel/.local/share/applications
sudo sed -i 's|/usr/bin/flameshot|/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
sudo sed -i 's|Exec=flameshot|Exec=/usr/local/bin/flameshot|g' /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop
cp -a /etc/skel/.local/share/applications/org.flameshot.Flameshot.desktop "$HOME/.local/share/applications"

########################################################################################################
pacote-pacman-icon-theme.sh
#!/bin/bash

# Tema de ícones
# obsidian-icon-theme -> Tema de ícones Obsidian baseado no Papirus  
# cutefish-icons      -> Conjunto de ícones do ambiente Cutefish  
sudo pacman --needed --noconfirm -S obsidian-icon-theme
# sudo pacman --needed --noconfirm -S cutefish-icons

gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"

########################################################################################################
pacote-pacman-kernel-hook.sh
#!/bin/bash

# Kernel
sudo pacman --needed --noconfirm -S kernel-modules-hook    # Instala o pacote para gerenciar corretamente os módulos do kernel após atualizações.
sudo systemctl enable --now linux-modules-cleanup.service  # Ativa e inicia o serviço para limpar módulos antigos do kernel.

########################################################################################################
pacote-pacman-lutris_instalar.sh
#!/bin/bash

sudo pacman -S --needed gamemode lib32-gamemode lutris wine-staging winetricks \
apparmor lib32-libpulse lib32-libsndfile lib32-libasyncns

########################################################################################################
pacote-pacman-orchis-theme-black.sh
#!/bin/bash

# Tema Orchis
# orchis-theme                    -> Tema moderno para GTK e GNOME Shell  
# tela-circle-icon-theme-black    -> Variante preta do conjunto de ícones Tela Circle  
# vimix-cursors                   -> Tema de cursores Vimix  
sudo pacman --needed --noconfirm -S orchis-theme
sudo pacman --needed --noconfirm -S tela-circle-icon-theme-black
sudo pacman --needed --noconfirm -S vimix-cursors

# Temas do usuário
gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"

## Temas e Configurações GDM
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"

########################################################################################################
pacote-pacman-orchis-theme-full.sh
#!/bin/bash

# Instala temas e ícones para personalização do GNOME:  
# gnome-themes-extra          -> Conjunto de temas adicionais para GTK  
# orchis-theme                -> Tema moderno para GTK e GNOME Shell  
# tela-circle-icon-theme-all  -> Conjunto de ícones Tela Circle  
# vimix-cursors               -> Tema de cursores Vimix  
sudo pacman --needed --noconfirm -S gnome-themes-extra orchis-theme tela-circle-icon-theme-all vimix-cursors

## Temas e Configurações GDM
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"

########################################################################################################
pacote-pacman-steam_game-devices-udev.sh
#!/bin/bash

# Instala o pacote game-devices-udev, que fornece regras udev para dispositivos de jogo (como controle, joystick, etc.)
# Dependẽncia para Steam versão Flatpak
paru --needed --noconfirm -S game-devices-udev

########################################################################################################
pacote-pacman-steam_instalar.sh
#!/bin/bash
# shellcheck disable=SC2015

sudo pacman -S --needed \
steam-native-runtime \
xf86-video-amdgpu xf86-video-ati xf86-video-intel \
lib32-fontconfig ttf-liberation wqy-zenhei \
lib32-systemd

mkdir -p "$HOME/.config/autostart/"
cp -av /usr/share/applications/steam-native.desktop "$HOME/.config/autostart/"
sed -i 's|Exec=/usr/bin/steam-native %U|Exec=/usr/bin/steam-native %U -silent|' "$HOME/.config/autostart/steam-native.desktop"

sudo sed -i '/en_US.UTF-8 UTF-8/s///' /etc/locale.gen
grep 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' "$HOME/.pam_environment" && echo "Steam pam_environment OK!" || echo 'STEAM_FRAME_FORCE_CLOSE DEFAULT=1' >> "$HOME/.pam_environment"
grep 'STEAM_FRAME_FORCE_CLOSE' "/etc/environment" && echo "Steam force close OK!" || echo 'STEAM_FRAME_FORCE_CLOSE=1' | sudo tee -a "/etc/environment"

########################################################################################################
pacote-pacman-telegram_instalar.sh
#!/bin/bash

sudo pacman -S --needed telegram-desktop

mkdir -p ~/.local/share/applications
cp -rf /usr/share/applications/org.telegram.desktop.desktop ~/.local/share/applications/org.telegram.desktop.desktop
sed -i '/Exec/s/\%u/\%u --hideStart/' ~/.local/share/applications/org.telegram.desktop.desktop
cp -rf ~/.local/share/applications/org.telegram.desktop.desktop ~/.config/autostart/org.telegram.desktop.desktop
chmod +x ~/.config/autostart/org.telegram.desktop.desktop

########################################################################################################
pacote-pacman-vscodium-ferramentas-cli.sh
#!/bin/bash

# Instala os seguintes pacotes para análise e formatação de código:
# jq          Processador de JSON no terminal
# prettier    Formatador de código para várias linguagens
## shellcheck  Analisador estático para scripts shell
# shfmt       Formatador para scripts shell
# stylelint   Linter para arquivos CSS e preprocessadores como SCSS
sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint

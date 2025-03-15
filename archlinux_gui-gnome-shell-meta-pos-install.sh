#!/bin/bash
# shellcheck disable=SC2027,SC2046,SC2002,SC2016

locdir="$(pwd)"

# Atualização do sistema
sudo pacman --needed --noconfirm -Syyu

# Instalação de pacotes para desenvolvimento
sudo pacman --needed --noconfirm -S base-devel git

# Complementos para o pacman
# expac    -> Ferramenta para exibir informações detalhadas sobre pacotes do pacman  
# pkgfile  -> Utilitário para buscar arquivos pertencentes a pacotes no repositório  
sudo pacman --needed --noconfirm -S expac pkgfile
sudo pkgfile -u

# Wrappers do pacman (AUR Helper)
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin || exit
makepkg --needed --noconfirm -Cris

# Gerenciador de pacotes Flatpak
# Pacote Flatpak versão ArchLinux já adiciona o repositório flathub, então não é necessário o comando "remote-add"
sudo pacman --needed --noconfirm -S flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Remove os seguintes pacotes do sistema:  
# epiphany     -> Navegador web GNOME Web  
# gnome-music  -> Aplicativo de reprodução de música do GNOME  
# loupe        -> Visualizador de imagens moderno do GNOME  
sudo pacman --noconfirm -R epiphany gnome-music loupe


# Instalação de pacotes via pacman

## Pacotes para Virtual Machines

# QEMU/KVM com SPICE
sudo pacman --needed --noconfirm -S qemu-guest-agent spice-vdagent xf86-input-vmmouse xf86-video-qxl gdk-pixbuf-xlib
sudo systemctl enable qemu-guest-agent spice-vdagentd

# VMWare
sudo pacman --needed --noconfirm -S open-vm-tools
sudo systemctl enable vmtoolsd

# Virtual Box
sudo pacman --needed --noconfirm -S virtualbox-guest-utils
sudo systemctl enable vboxservice

## Aplicatibos Gnome

# Pacotes Gnome do repositório oficial
sudo pacman --needed --noconfirm -S archlinux-wallpaper    # Papéis de parede oficiais do Arch Linux
sudo pacman --needed --noconfirm -S gnome-tweaks           # Ferramenta para ajustar configurações avançadas do GNOME
sudo pacman --needed --noconfirm -S rhythmbox              # Player de música padrão do GNOME
sudo pacman --needed --noconfirm -S fragments              # Cliente BitTorrent simples para o GNOME  
sudo pacman --needed --noconfirm -S gthumb                 # Visualizador e organizador de imagens  
sudo pacman --needed --noconfirm -S remmina                # Cliente de acesso remoto compatível com RDP, VNC e outros protocolos  

## Complementos para o GNOME

# Daemon para gerenciar perfis de energia no Linux, permitindo otimizar o consumo de energia em laptops e dispositivos móveis.
sudo pacman --needed --noconfirm -S power-profiles-daemon

# File Roller: Gerenciador de arquivos compactados do GNOME
sudo pacman --needed --noconfirm -Syyu file-roller  

# Instala dependências opcionais do File Roller listadas pelo expac
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')""  

## Extensões do GNOME
sudo pacman --needed --noconfirm -S gnome-shell-extension-appindicator gnome-shell-extension-caffeine

## Funcionalidades do Nautilus
sudo pacman --needed --noconfirm -S nautilus-image-converter nautilus-share

## Demais aplicações
sudo pacman --needed --noconfirm -S wine-staging winetricks


# Instalação de pacotes via AUR

# mystiq -> Conversor de vídeo e áudio baseado no FFmpeg com interface gráfica simples  
paru --needed --noconfirm -S mystiq

# actions-for-nautilus-git: Ações adicionais para o Nautilus (explorador de arquivos); 
# gtkhash: Ferramenta para calcular e verificar somas de verificação de arquivos; 
# meld: Ferramenta para comparação de arquivos e diretórios; 
# xclip: Utilitário para manipulação da área de transferência no Linux
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

# Em teste:
paru --needed --noconfirm -S gnome-themes-extra materia-gtk-theme orchis-theme tela-circle-icon-theme-all vimix-cursors
# Adicionar
# teamviewer_amd64
# openfortigui
# cisco-secure-client-vpn_5.1.6.103_amd64


# Instalação de pacotes via Flatpak

# Pacotes Gnome do repositório Flatpak (Para que tenha menos dependências no ArchLinux)
sudo flatpak install -y flathub com.github.maoschanz.DynamicWallpaperEditor # Editor de papel de parede dinâmico
sudo flatpak install -y flathub io.github.realmazharhussain.GdmSettings     # GDM Settings: Ferramenta para configurar o GDM (GNOME Display Manager)
sudo flatpak install -y flathub org.kde.kate                                # Kate: Editor de texto avançado da comunidade KDE

## Pacotes Opcionais para uso no sistema
sudo flatpak -y install com.rtosta.zapzap                        # ZapZap: Cliente de mensagens instantâneas (WhatsApp) para Linux
# sudo flatpak -y install me.dusansimic.DynamicWallpaper           # Dynamic Wallpaper: Ferramenta para criar papéis de parede dinâmicos (comentado)


# Ajustes de configurações via dconf

## Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
# dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

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
gsettings set org.gnome.Console transparency true

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

# Habilita e inicia os serviços do Samba:  
# nmb -> Serviço NetBIOS para descoberta de dispositivos na rede  
# smb -> Serviço principal do Samba para compartilhamento de arquivos  
sudo systemctl enable --now nmb smb  

# Define a senha do usuário atual no Samba  
# 'arch' -> Senha sendo definida para o usuário no Samba  
echo 'arch' | sudo -S smbpasswd -a "$USER"


# Customizações do sistema com Scripts

# Nautilus-Status-Bar-Replacement
sudo mkdir -p /usr/share/nautilus-python/extensions
sudo curl -JLk -o /usr/share/nautilus-python/extensions/DiskUsageLocationWidget.py \
"https://raw.githubusercontent.com/elppans/Nautilus-Status-Bar-Replacement/refs/heads/master/DiskUsageLocationWidget.py"

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

# gnome-shell-extension-unite > AUR (Teste)
# Importar as configurações (salvo no github)
# curl -JLk -o /tmp/unite-settings.conf "https://raw.githubusercontent.com/elppans/ubuntu2204-package-list/refs/heads/main/unite-extensions-settings.conf"
# dconf load /org/gnome/shell/extensions/unite/ < /tmp/unite-settings.conf

# Ativar a extenção
# gnome-extensions enable "unite@hardpixel.eu"

# Instalação de pacotes via Scripts externos

# cd "$locdir" || exit 1

# ./pacote-flatpak-anydesk.sh           # Script para instalar o AnyDesk via Flatpak
# ./pacote-flatpak-browser-brave.sh     # Script para instalar o navegador Brave via Flatpak
# ./pacote-flatpak-browser-chrome.sh    # Script para instalar o navegador Google Chrome via Flatpak
bash "$locdir"/pacote-flatpak-browser-edge.sh      # Script para instalar o navegador Microsoft Edge via Flatpak
# ./pacote-flatpak-browser-firefox.sh   # Script para instalar o navegador Firefox via Flatpak
# ./pacote-flatpak-browser-opera.sh     # Script para instalar o navegador Opera via Flatpak
# ./pacote-flatpak-browser-vivaldi.sh   # Script para instalar o navegador Vivaldi via Flatpak
# ./pacote-flatpak-dbeaver-ce.sh        # Script para instalar o DBeaver Community Edition via Flatpak
bash "$locdir"/pacote-flatpak-discord.sh           # Script para instalar o Discord via Flatpak
bash "$locdir"/pacote-flatpak-heroic.sh            # Script para instalar o Heroic Games Launcher via Flatpak
bash "$locdir"/pacote-flatpak-lutris.sh            # Script para instalar o Lutris via Flatpak
# ./pacote-flatpak-marktext.sh          # Script para instalar o Mark Text (editor de markdown) via Flatpak
# ./pacote-flatpak-rustdesk.sh          # Script para instalar o RustDesk (software de acesso remoto) via Flatpak
bash "$locdir"/pacote-flatpak-steam.sh               # Script para instalar o Steam (plataforma de jogos) via Flatpak
bash "$locdir"/pacote-flatpak-telegram.sh          # Script para instalar o Telegram Desktop via Flatpak
# ./pacote-flatpak-vscodium.sh          # Script para instalar o VSCodium (editor de código baseado no VSCode) via Flatpak
bash "$locdir"/pacote-flatpak-zapzap.sh            # Script para instalar o ZapZap (cliente de WhatsApp via Flatpak)


# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

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
# Pacote Flatpak versão ArchLinux já adiciona o repositório flathub, então não é necessário o comando "remote-add"
sudo pacman --needed --noconfirm -S flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Remoção de aplicativos
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
sudo pacman --needed --noconfirm -Syyu archlinux-wallpaper    # Papéis de parede oficiais do Arch Linux
sudo pacman --needed --noconfirm -Syyu fwupd                  # Ferramenta para atualização de firmware de dispositivos
sudo pacman --needed --noconfirm -Syyu fwupd-efi              # Módulo EFI para atualizar firmware via fwupd
sudo pacman --needed --noconfirm -Syyu gnome-disk-utility     # Gerenciador de discos e partições do GNOME
sudo pacman --needed --noconfirm -Syyu gnome-menus            # Biblioteca para manipulação de menus no GNOME
# sudo pacman --needed --noconfirm -Syyu gnome-remote-desktop   # Suporte a compartilhamento de área de trabalho via RDP e VNC
sudo pacman --needed --noconfirm -Syyu gnome-shell-extensions # Extensões para personalizar o GNOME Shell
# sudo pacman --needed --noconfirm -Syyu gnome-software         # Loja de aplicativos do GNOME para gerenciar pacotes e Flatpaks
sudo pacman --needed --noconfirm -Syyu gnome-tweaks           # Ferramenta para ajustar configurações avançadas do GNOME
sudo pacman --needed --noconfirm -Syyu gnome-user-share       # Compartilhamento de arquivos via WebDAV no GNOME
sudo pacman --needed --noconfirm -Syyu rhythmbox              # Player de música padrão do GNOME
sudo pacman --needed --noconfirm -Syyu sushi                  # Visualizador rápido de arquivos para o Nautilus
# sudo pacman --needed --noconfirm -Syyu yelp                   # Visualizador de ajuda e documentação do GNOME

## Complementos para o GNOME

# Daemon para gerenciar perfis de energia no Linux, permitindo otimizar o consumo de energia em laptops e dispositivos móveis.
sudo pacman --needed --noconfirm -S power-profiles-daemon

# File Roller: Gerenciador de arquivos compactados do GNOME (Usando a versão Flatpak)
# sudo pacman --needed --noconfirm -Syyu file-roller  

# Instala dependências do File Roller listadas pelo expac (gerenciador de arquivos compactados)
# sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')""  

## Extensões do GNOME
sudo pacman --needed --noconfirm -S gnome-shell-extension-appindicator gnome-shell-extension-caffeine

## Funcionalidades do Nautilus
sudo pacman --needed --noconfirm -S nautilus-image-converter nautilus-share

## Demais aplicações
sudo pacman --needed --noconfirm -S jq prettier shellcheck shfmt stylelint wine-staging winetricks

# Instalação de pacotes via AUR

## Aplicativos

# Mystiq: Ferramenta de gerenciamento de senhas e autenticação para Linux
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

# Adicionar
# teamviewer_amd64
# openfortigui
# cisco-secure-client-vpn_5.1.6.103_amd64

# Instalação de pacotes via Flatpak

# Pacotes Gnome do repositório Flatpak (Para que tenha menos dependências no ArchLinux)
sudo flatpak install -y flathub org.gnome.Platform//47                      # Plataforma base do GNOME versão 47
sudo flatpak install -y flathub org.gnome.SDK//47                           # SDK do GNOME versão 47
sudo flatpak install -y flathub ca.desrt.dconf-editor                       # Editor de configurações avançado do GNOME
sudo flatpak install -y flathub com.github.maoschanz.DynamicWallpaperEditor # Editor de papel de parede dinâmico
sudo flatpak install -y flathub de.haeckerfelix.Fragments                   # Aplicativo de fragmentação de arquivos (Torrent)
sudo flatpak install -y flathub io.github.celluloid_player.Celluloid        # Player de vídeo (anteriormente MPV)
sudo flatpak install -y flathub io.github.realmazharhussain.GdmSettings     # Configurações do GDM
sudo flatpak install -y flathub org.gnome.baobab        # Analisador de espaço em disco do GNOME
sudo flatpak install -y flathub org.gnome.Calendar      # Aplicativo de calendário do GNOME
sudo flatpak install -y flathub org.gnome.Calculator    # Calculadora do GNOME
sudo flatpak install -y flathub org.gnome.Characters    # Visualizador de caracteres especiais do GNOME
sudo flatpak install -y flathub org.gnome.Cheese        # Aplicativo de câmera do GNOME
# sudo flatpak install -y flathub org.gnome.clocks        # Relógio e alarme do GNOME
# sudo flatpak install -y flathub org.gnome.Contacts      # Gerenciador de contatos do GNOME
sudo flatpak install -y flathub org.gnome.FileRoller    # Compactador e descompactador de arquivos do GNOME
# sudo flatpak install -y flathub org.gnome.Firmware      # Aplicativo para atualização de firmware do GNOME
sudo flatpak install -y flathub org.gnome.font-viewer   # Visualizador de fontes do GNOME
sudo flatpak install -y flathub org.gnome.gThumb        # Visualizador de imagens e gerenciador de galerias
sudo flatpak install -y flathub org.gnome.Logs          # Aplicativo de logs do GNOME
# sudo flatpak install -y flathub org.gnome.Maps          # Mapas e navegação do GNOME
sudo flatpak install -y flathub org.gnome.meld          # Ferramenta de comparação de arquivos
sudo flatpak install -y flathub org.gnome.SimpleScan    # Scanner de documentos do GNOME
sudo flatpak install -y flathub org.gnome.Snapshot      # Ferramenta de captura de tela do GNOME
sudo flatpak install -y flathub org.gnome.TextEditor    # Editor de texto do GNOME
sudo flatpak install -y flathub org.gnome.Weather       # Aplicativo de previsão do tempo do GNOME
sudo flatpak install -y flathub org.kde.kate            # Editor de texto avançado do KDE (Kate)
sudo flatpak install -y flathub org.remmina.Remmina     # Cliente de desktop remoto (RDP, VNC, SSH)

## Pacotes Opcionais para uso no sistema
sudo flatpak -y install com.github.marktext.marktext             # MarkText: Editor de texto Markdown simples e poderoso
sudo flatpak -y install io.github.realmazharhussain.GdmSettings  # GDM Settings: Ferramenta para configurar o GDM (GNOME Display Manager)
sudo flatpak -y install com.microsoft.Edge                       # Microsoft Edge: Navegador web da Microsoft
sudo flatpak -y install com.rtosta.zapzap                        # ZapZap: Cliente de mensagens instantâneas (WhatsApp) para Linux
sudo flatpak -y install com.vscodium.codium && export VSCODIUM="1"  # VSCodium: Versão de código aberto do Visual Studio Code (sem o rastreamento de dados)
sudo flatpak -y install io.dbeaver.DBeaverCommunity              # DBeaver: Ferramenta de gerenciamento de banco de dados multi-plataforma
# sudo flatpak -y install me.dusansimic.DynamicWallpaper           # Dynamic Wallpaper: Ferramenta para criar papéis de parede dinâmicos (comentado)
sudo flatpak -y install org.kde.kate                             # Kate: Editor de texto avançado da comunidade KDE


## Pacotes Flatpak comentados (para ativação posterior)
# sudo flatpak install -y flathub com.anydesk.Anydesk                          # AnyDesk: Software de acesso remoto para controle e suporte remoto
sudo flatpak install -y flathub com.github.maoschanz.DynamicWallpaperEditor  # Dynamic Wallpaper Editor: Editor para criar e personalizar papéis de parede dinâmicos
# sudo flatpak install -y flathub com.google.Chrome                            # Google Chrome: Navegador web da Google
# sudo flatpak install -y flathub com.rustdesk.RustDesk                        # RustDesk: Software de acesso remoto de código aberto
# sudo flatpak install -y com.opera.Opera                                      # Opera: Navegador web com foco em privacidade e recursos avançados
# sudo flatpak install -y com.vivaldi.Vivaldi                                  # Vivaldi: Navegador web altamente personalizável


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

# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

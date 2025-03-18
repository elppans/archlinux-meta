#!/bin/bash
# shellcheck disable=SC2027,SC2046,SC2002,SC2016

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

locdir="$(pwd)"
install="$locdir"

# Adiciona a linha "ILoveCandy" em /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf

# Atualização do sistema:

# Sincroniza os repositórios e atualiza todos os pacotes do sistema  
sudo pacman --needed --noconfirm -Syyu  


# Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland:

# Instala o XWayland, que permite rodar aplicativos X11 dentro do Wayland  
# xorg-xlsclients: ferramenta para listar clientes conectados ao servidor X  
# glfw-wayland: biblioteca para desenvolvimento de aplicações gráficas com suporte a Wayland  
sudo pacman --needed --noconfirm -S xorg-xwayland xorg-xlsclients glfw-wayland  

# Instala a biblioteca libinput para gerenciar dispositivos de entrada (mouse, teclado, etc.)  
# wayland: protocolo de servidor gráfico que substitui o X11  
# wayland-protocols: coleção de protocolos usados para comunicação entre clientes e servidores Wayland  
sudo pacman --needed --noconfirm -S libinput wayland wayland-protocols  

# Instala os portais do XDG para garantir a compatibilidade com aplicações Wayland e GNOME
# - xdg-desktop-portal: Fornece uma interface entre aplicativos sandboxed e o ambiente de desktop
# - xdg-desktop-portal-gnome: Implementação específica para o GNOME, garantindo melhor integração com o Hyprland no GNOME
sudo pacman --needed --noconfirm -S xdg-desktop-portal xdg-desktop-portal-gnome

# Instala o IBus  
# IBus (Intelligent Input Bus) é um framework para gerenciamento de métodos de entrada,  
# útil para digitação em diferentes idiomas e caracteres especiais  
# sudo pacman --needed --noconfirm -Syyu ibus  


# Instalação de pacotes essenciais para desenvolvimento e gerenciamento de código:  

# base-devel -> Conjunto de ferramentas básicas para compilação de software no Arch Linux  
# git        -> Sistema de controle de versão distribuído  
sudo pacman --needed --noconfirm -S base-devel git

# Complementos para o pacman:

# expac    -> Ferramenta para exibir informações detalhadas sobre pacotes do pacman  
# pkgfile  -> Utilitário para buscar arquivos pertencentes a pacotes no repositório  
sudo pacman --needed --noconfirm -S expac pkgfile
sudo pkgfile -u

# Wrappers do pacman (AUR Helper) - paru
git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
cd /tmp/paru-bin || exit
makepkg --needed --noconfirm -Cris


# Gerenciador de pacotes Flatpak
sudo pacman --needed --noconfirm -S flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Remoção de pacotes:

# Remove os seguintes pacotes do sistema:  
# epiphany     -> Navegador web GNOME Web  
# gnome-music  -> Aplicativo de reprodução de música do GNOME  
# loupe        -> Visualizador de imagens moderno do GNOME  
sudo pacman --noconfirm -R epiphany gnome-music loupe


# Instalação de pacotes via pacman:

## Pacotes para Virtual Machines

# Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários
# para melhorar a integração com o hypervisor. O script usa três métodos para detecção:
# 1. systemd-detect-virt (se disponível)
# 2. lscpu | grep -i hypervisor
# 3. grep -i hypervisor /proc/cpuinfo
# Se uma VM for detectada, os pacotes apropriados para QEMU/KVM, VMWare ou VirtualBox serão
# instalados automaticamente. Caso contrário, nada será feito.
"$install"/detect-and-install-vm-packages.sh

## Aplicatibos Gnome

# Pacotes Gnome do repositório oficial
sudo pacman --needed --noconfirm -S archlinux-wallpaper    # Papéis de parede oficiais do Arch Linux
sudo pacman --needed --noconfirm -S dconf-editor           # Editor gráfico para modificar configurações avançadas do GNOME  
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

# Dependências opcionais do File Roller listadas pelo expac
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')""  

# Extensões do GNOME Shell:  
# gnome-shell-extension-appindicator -> Suporte a indicadores de aplicativos na barra de sistema  
# gnome-shell-extension-caffeine     -> Impede que a tela desligue ou entre em suspensão  
sudo pacman --needed --noconfirm -S gnome-shell-extension-appindicator
sudo pacman --needed --noconfirm -S gnome-shell-extension-caffeine

# Extensões para o gerenciador de arquivos Nautilus:  
# nautilus-image-converter -> Adiciona opções para redimensionar e girar imagens no menu de contexto  
# nautilus-share           -> Permite compartilhar pastas via Samba diretamente pelo Nautilus  
sudo pacman --needed --noconfirm -S nautilus-image-converter
sudo pacman --needed --noconfirm -S nautilus-share

# Demais aplicações
# Wine e ferramentas relacionadas para executar aplicativos Windows no Linux:  
# wine-staging  -> Versão do Wine com patches experimentais e melhorias não incluídas na versão estável  
# winetricks    -> Script para facilitar a instalação de bibliotecas e aplicativos no Wine  
# sudo pacman --needed --noconfirm -S wine-staging winetricks

# https://wiki.archlinux.org/title/AppArmor
# Movido para Sessão de Scripts

# Instalação de pacotes via AUR

# Gerenciador de pacotes Snapd
# https://wiki.archlinux.org/title/Snap
paru --needed --noconfirm -S snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable --now snapd snapd.socket snapd.apparmor
# ocultar a pasta. snap
echo "$HOME/Snap" | tee -a "$HOME"/.hidden >>/dev/null
echo "$HOME/Snapd" | tee -a "$HOME"/.hidden >>/dev/null

# mystiq -> Conversor de vídeo e áudio baseado no FFmpeg com interface gráfica simples  
paru --needed --noconfirm -S mystiq

# GDM Settings, uma ferramenta gráfica para configurar o GDM (GNOME Display Manager)  (Ativado na versão Flatpak)
# paru --needed --noconfirm -S gdm-settings

# actions-for-nautilus-git: Ações adicionais para o Nautilus (explorador de arquivos); 
# gtkhash: Ferramenta para calcular e verificar somas de verificação de arquivos; 
# meld: Ferramenta para comparação de arquivos e diretórios; 
# xclip: Utilitário para manipulação da área de transferência no Linux
paru --needed --noconfirm -S actions-for-nautilus-git gtkhash meld xclip

## Configuração CUSTOMIZADA do Actions for Nautilus
mkdir -p "$HOME/.local/share/actions-for-nautilus"
curl -JLk -o "$HOME/.local/share/actions-for-nautilus/config.json" "https://raw.githubusercontent.com/elppans/actions-for-nautilus/refs/heads/main/configurator/sample-config.json"
sed -i 's/gnome-terminal/gnome-console/g' "$HOME/.local/share/actions-for-nautilus/config.json"
sed -i 's/gedit/gnome-text-editor/g' "$HOME/.local/share/actions-for-nautilus/config.json"
nautilus -q

## Temas e ícones para personalização do GNOME:  

# Tema Orchis
# orchis-theme                    -> Tema moderno para GTK e GNOME Shell  
# tela-circle-icon-theme-black    -> Variante preta do conjunto de ícones Tela Circle  
# vimix-cursors                   -> Tema de cursores Vimix  
sudo pacman --needed --noconfirm -S orchis-theme
sudo pacman --needed --noconfirm -S tela-circle-icon-theme-black
sudo pacman --needed --noconfirm -S vimix-cursors

# Tema de ícones
# obsidian-icon-theme -> Tema de ícones Obsidian baseado no Papirus  
# cutefish-icons      -> Conjunto de ícones do ambiente Cutefish  
sudo pacman --needed --noconfirm -S obsidian-icon-theme
# sudo pacman --needed --noconfirm -S cutefish-icons

# Adicionar
# teamviewer_amd64
# openfortigui
# cisco-secure-client-vpn_5.1.6.103_amd64


# Instalação de pacotes via Flatpak
# Movido para a sessão final, "Instalação de pacotes via Scripts externos"


# Ajustes de configurações via dconf

## Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
# dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

# Ajustes de configurações via gsettings

## Temas e Configurações Gnome
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
# gsettings set org.gnome.desktop.sound theme-name "Yaru"

## Configurações gerais do Gnome
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.Console transparency true
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

## Temas e Configurações GDM
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Yaru-blue-dark"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-weekday true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-seconds true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface show-battery-percentage true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
sudo systemctl restart gdm


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

# Trocar o ícone do Gnome Text Editor e padronizando em "skel"
sudo sed -i 's/^Icon=.*/Icon=gedit/' "/usr/share/applications/org.gnome.TextEditor.desktop"
sudo mkdir -p "/etc/skel/.local/share/applications"
mkdir -p "$HOME/.local/share/applications"
sudo cp "/usr/share/applications/org.gnome.TextEditor.desktop" "/etc/skel/.local/share/applications"
cp "/usr/share/applications/org.gnome.TextEditor.desktop" "$HOME/.local/share/applications"

# Nautilus-Status-Bar-Replacement (Não funciona mais (Nautilus 47)
# sudo mkdir -p /usr/share/nautilus-python/extensions
# sudo curl -JLk -o /usr/share/nautilus-python/extensions/DiskUsageLocationWidget.py \
# "https://raw.githubusercontent.com/elppans/Nautilus-Status-Bar-Replacement/refs/heads/master/DiskUsageLocationWidget.py"

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

## Executar aplicativos com  xWayland
sudo curl -JLk -o /usr/local/bin/run-x11.sh https://raw.githubusercontent.com/elppans/customshell/refs/heads/master/run-x11.sh
sudo chmod +x /usr/local/bin/run-x11.sh

# https://flameshot.org/docs/guide/wayland-help/
echo -e '/usr/local/bin/run-x11.sh flameshot gui' | sudo tee /usr/local/bin/flameshot >>/dev/null
sudo chmod +x /usr/local/bin/flameshot

# Usar aplicações baseadas no electron nativamente no Wayland
echo -e '--enable-features=UseOzonePlatform
--ozone-platform=wayland' | tee ${XDG_CONFIG_HOME}/electron-flags.conf

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
# gnome-extensions enable "unite@hardpixel.eu"

# Instalação de pacotes via Scripts externos

"$install"/pacote-pacman-apparmor-instalar.sh  # Instala o AppArmor usando pacman (Recomendado para uso com Snapd)
# "$install"/pacote-flatpak-anydesk.sh           # Script para instalar o AnyDesk via Flatpak
# "$install"/pacote-flatpak-browser-brave.sh     # Script para instalar o navegador Brave via Flatpak
# "$install"/pacote-flatpak-browser-chrome.sh    # Script para instalar o navegador Google Chrome via Flatpak
"$install"/pacote-flatpak-browser-edge.sh      # Script para instalar o navegador Microsoft Edge via Flatpak
# "$install"/pacote-flatpak-browser-firefox.sh   # Script para instalar o navegador Firefox via Flatpak
# "$install"/pacote-flatpak-browser-opera.sh     # Script para instalar o navegador Opera via Flatpak
# "$install"/pacote-flatpak-browser-vivaldi.sh   # Script para instalar o navegador Vivaldi via Flatpak
# "$install"/pacote-flatpak-dbeaver-ce.sh        # Script para instalar o DBeaver Community Edition via Flatpak
"$install"/pacote-flatpak-discord.sh           # Script para instalar o Discord via Flatpak
# "$install"/pacote-flatpak-dynamic-wallpaper.sh        # Script para instalar a Ferramenta para criar papéis de parede dinâmicos
"$install"/pacote-flatpak-dynamic-wallpaper-editor.sh # Script para instalar o Editor de papel de parede dinâmico
"$install"/pacote-flatpak-gdm-settings.sh    # Script para instalar o GDM Settings via Flatpak  (Contém na sessão AUR)
"$install"/pacote-flatpak-heroic.sh            # Script para instalar o Heroic Games Launcher via Flatpak
"$install"/pacote-flatpak-kate.sh            # Script para instalar o Editor de texto avançado da comunidade KDE
"$install"/pacote-flatpak-lutris.sh            # Script para instalar o Lutris via Flatpak
"$install"/pacote-flatpak-marktext.sh          # Script para instalar o Mark Text (editor de markdown) via Flatpak
# "$install"/pacote-flatpak-rustdesk.sh          # Script para instalar o RustDesk (software de acesso remoto) via Flatpak
"$install"/pacote-flatpak-steam.sh               # Script para instalar o Steam (plataforma de jogos) via Flatpak (e dependência "game-devices-udev" via pacman)
"$install"/pacote-flatpak-telegram.sh          # Script para instalar o Telegram Desktop via Flatpak
# "$install"/pacote-flatpak-vscodium.sh          # Script para instalar o VSCodium (editor de código baseado no VSCode) via Flatpak
"$install"/pacote-flatpak-zapzap.sh            # Script para instalar o ZapZap (cliente de WhatsApp via Flatpak)
"$install"/pacote-pacman-flameshot.sh          # Script para insalar Flameshot, aplicativo para Screenshots com mais opções que o padrão do Gnome
# "$install"/pacote-aur-yaru-theme-full.sh       # Script para instalar o Tema Yaru completo via AUR  
# "$install"/pacote-pacman-orchis-theme-full.sh  # Script para instalar o Tema Orchis completo via Pacman  
# "$install"/pacote-helper-yay_instalar.sh       # Executa o script para instalar o AUR helper Yay  


# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

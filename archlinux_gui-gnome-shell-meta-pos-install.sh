#!/bin/bash
# shellcheck disable=SC2010,SC2027,SC2046,SC2002,SC2016,SC2086,SC2317

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

locdir="$(pwd)"
install="$locdir"

# Obtém a versão do kernel em execução
kernel_version=$(uname -r)

# Verifica se a versão do kernel em execução existe em /lib/modules
if ls /lib/modules | grep -q "^$kernel_version$"; then
    echo
    # echo "OK: A versão do kernel ($kernel_version) está presente em /lib/modules."
    # exit 0
else
    echo "ERRO: A versão do kernel ($kernel_version) não está presente em /lib/modules."
    echo "Por favor, reinicie o sistema para aplicar as configurações corretamente."
    exit 1
fi

# Adiciona a linha "ILoveCandy" em /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf

sudo pacman --needed --noconfirm -Syyu base-devel git  # Atualiza os sistema e instala pacotes essenciais para desenvolvimento junto com o Git.

sudo pacman --needed --noconfirm -S expac # Ferramenta para exibir informações detalhadas sobre pacotes do pacman  
sudo pacman --needed --noconfirm -S pkgfile # Utilitário para buscar arquivos pertencentes a pacotes no repositório  
sudo pkgfile -u

sudo pacman --needed --noconfirm -S flatpak # Gerenciador de pacotes Flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

"$install"/helper/pacote-helper-paru_instalar.sh # Wrappers do pacman (AUR Helper) - paru
"$install"/helper/pacote-helper-yay_instalar.sh  # Wrappers do pacman (AUR Helper) - yay

# Kernel
sudo pacman --needed --noconfirm -S kernel-modules-hook    # Instala o pacote para gerenciar corretamente os módulos do kernel após atualizações.
sudo systemctl enable --now linux-modules-cleanup.service  # Ativa e inicia o serviço para limpar módulos antigos do kernel.

# Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland:

sudo pacman --needed --noconfirm -S xorg-xwayland xorg-xlsclients glfw-wayland   # Instala o XWayland, ferramenta xlsclients e biblioteca glfw com suporte ao Wayland.
sudo pacman --needed --noconfirm -S libinput wayland wayland-protocols           # Instala a biblioteca libinput, o protocolo Wayland e os protocolos adicionais para comunicação no Wayland.
sudo pacman --needed --noconfirm -S xdg-desktop-portal xdg-desktop-portal-gnome  # Instala os portais do XDG para compatibilidade com Wayland e GNOME, incluindo suporte específico para o GNOME.

# Remoção de pacotes:

sudo pacman --noconfirm -R epiphany gnome-music loupe  # Remove o navegador GNOME Web, o aplicativo de música e o visualizador de imagens modernos do GNOME.

# Instalação de pacotes

"$install"/pacman/detect-and-install-vm-packages.sh # Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários

# Pacotes Gnome do repositório oficial (Adicionar nos arquivos do diretório pacman)
sudo pacman --needed --noconfirm -S archlinux-wallpaper    # Papéis de parede oficiais do Arch Linux
sudo pacman --needed --noconfirm -S dconf-editor           # Editor gráfico para modificar configurações avançadas do GNOME  
sudo pacman --needed --noconfirm -S gnome-tweaks           # Ferramenta para ajustar configurações avançadas do GNOME
sudo pacman --needed --noconfirm -S rhythmbox              # Player de música padrão do GNOME
sudo pacman --needed --noconfirm -S fragments              # Cliente BitTorrent simples para o GNOME  
sudo pacman --needed --noconfirm -S gthumb                 # Visualizador e organizador de imagens  
sudo pacman --needed --noconfirm -S remmina                # Cliente de acesso remoto compatível com RDP, VNC e outros protocolos  

## Complementos para o GNOME

sudo pacman --needed --noconfirm -S power-profiles-daemon                                       # Instala o daemon para gerenciar perfis de energia.
sudo pacman --needed --noconfirm -Syyu file-roller                                              # Instala o File Roller, gerenciador de arquivos compactados.
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" file-roller | tr ' ' '\n')""  # Instala as dependências opcionais do File Roller.
sudo pacman --needed --noconfirm -S gnome-shell-extension-appindicator                          # Suporte a indicadores de aplicativos no GNOME Shell.
sudo pacman --needed --noconfirm -S gnome-shell-extension-caffeine                              # Impede que a tela desligue ou entre em suspensão.
sudo pacman --needed --noconfirm -S nautilus-image-converter                                    # Redimensionar e girar imagens pelo Nautilus.
sudo pacman --needed --noconfirm -S nautilus-share                                              # Compartilha pastas via Samba pelo Nautilus.


# Demais aplicações
sudo pacman --needed --noconfirm -S wine-staging  # Instala o Wine Staging, versão de teste do Wine com patches extras.
sudo pacman --needed --noconfirm -S winetricks   # Instala o Winetricks, ferramenta para gerenciar bibliotecas e configurações no Wine.


# https://wiki.archlinux.org/title/AppArmor
# Movido para Sessão de Scripts

# Instalação de pacotes via AUR

# Gerenciador de pacotes Snapd
# https://wiki.archlinux.org/title/Snap
# paru --needed --noconfirm -S snapd
# sudo ln -s /var/lib/snapd/snap /snap
# sudo systemctl enable --now snapd snapd.socket snapd.apparmor
# ocultar a pasta. snap
# shellcheck disable=SC2129
# echo "snap" | tee -a "$HOME"/.hidden >>/dev/null
# echo "Snap" | tee -a "$HOME"/.hidden >>/dev/null
# echo "Snapd" | tee -a "$HOME"/.hidden >>/dev/null

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




## Nautilus
dconf write /org/gnome/nautilus/preferences/show-create-link true
# dconf write /org/gnome/nautilus/preferences/show-delete-permanently true

# Ajustes de configurações via gsettings

## Temas e Configurações Gnome
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
# gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
gsettings set org.gnome.desktop.interface gtk-theme "Orchis-Dark-Compact"
gsettings set org.gnome.desktop.interface icon-theme "Obsidian-Aqua-Light"
# gsettings set org.gnome.desktop.sound theme-name "Yaru"

## Configurações gerais do Gnome
gsettings set org.gnome.Console transparency true
gsettings set org.gnome.desktop.background picture-options 'spanned'
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/archlinux/conference.png'
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.shell.weather automatic-location true
gsettings set org.gnome.shell.extensions.window-list grouping-mode 'auto'

## Temas e Configurações GDM
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface gtk-theme "Yaru-blue-dark"
# sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme "Orchis-Dark-Compact"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme "Vimix-cursors"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-weekday true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface clock-show-seconds true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface show-battery-percentage true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
sudo systemctl restart gdm

## Configurações do Menú Gnome
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
cd /tmp/el-images || exit 1
./install.sh
cd || exit 1

git clone https://github.com/elppans/factions-shell.git /tmp/factions-shell
cd /tmp/factions-shell || exit 1
./install.sh
cd || exit 1

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
# echo -e '/usr/local/bin/run-x11.sh flameshot gui' | sudo tee /usr/local/bin/flameshot >>/dev/null
# sudo chmod +x /usr/local/bin/flameshot

#
chmod +x "$install"/bin/*
sudo cp -a "$install"/bin/* /usr/local/bin

# Usar aplicações baseadas no electron nativamente no Wayland
echo -e '--enable-features=UseOzonePlatform
--ozone-platform=wayland' | tee ${XDG_CONFIG_HOME}/electron-flags.conf

# Instalação de pacotes via Scripts externos

"$install"/pacote-aur-mystiq_instalar.sh                      # Conversor de vídeo e áudio baseado no FFmpeg com interface gráfica simples
# "$install"/pacman/pacote-pacman-apparmor-instalar.sh        # Instala o AppArmor usando pacman (Recomendado para uso com Snapd)
# "$install"/flatpak/pacote-flatpak-anydesk.sh                # Script para instalar o AnyDesk via Flatpak
# "$install"/flatpak/pacote-flatpak-browser-brave.sh          # Script para instalar o navegador Brave via Flatpak
# "$install"/flatpak/pacote-flatpak-browser-chrome.sh         # Script para instalar o navegador Google Chrome via Flatpak
"$install"/flatpak/pacote-flatpak-browser-edge.sh             # Script para instalar o navegador Microsoft Edge via Flatpak
# "$install"/flatpak/pacote-flatpak-browser-firefox.sh        # Script para instalar o navegador Firefox via Flatpak
# "$install"/flatpak/pacote-flatpak-browser-opera.sh          # Script para instalar o navegador Opera via Flatpak
# "$install"/flatpak/pacote-flatpak-browser-vivaldi.sh        # Script para instalar o navegador Vivaldi via Flatpak
# "$install"/flatpak/pacote-flatpak-dbeaver-ce.sh             # Script para instalar o DBeaver Community Edition via Flatpak
"$install"/flatpak/pacote-flatpak-discord.sh                  # Script para instalar o Discord via Flatpak
# "$install"/flatpak/pacote-flatpak-dynamic-wallpaper.sh      # Script para instalar a Ferramenta para criar papéis de parede dinâmicos
"$install"/flatpak/pacote-flatpak-dynamic-wallpaper-editor.sh # Script para instalar o Editor de papel de parede dinâmico
"$install"/flatpak/pacote-flatpak-gdm-settings.sh             # Script para instalar o GDM Settings via Flatpak  (Contém na sessão AUR)
"$install"/flatpak/pacote-flatpak-heroic.sh                   # Script para instalar o Heroic Games Launcher via Flatpak
"$install"/flatpak/pacote-flatpak-kate.sh                     # Script para instalar o Editor de texto avançado da comunidade KDE
"$install"/flatpak/pacote-flatpak-lutris.sh                   # Script para instalar o Lutris via Flatpak
"$install"/flatpak/pacote-flatpak-marktext.sh                 # Script para instalar o Mark Text (editor de markdown) via Flatpak
# "$install"/flatpak/pacote-flatpak-rustdesk.sh               # Script para instalar o RustDesk (software de acesso remoto) via Flatpak
"$install"/flatpak/pacote-flatpak-steam.sh                    # Script para instalar o Steam (plataforma de jogos) via Flatpak (e dependência "game-devices-udev" via pacman)
"$install"/flatpak/pacote-flatpak-telegram.sh                 # Script para instalar o Telegram Desktop via Flatpak
# "$install"/flatpak/pacote-flatpak-vscodium.sh               # Script para instalar o VSCodium (editor de código baseado no VSCode) via Flatpak
"$install"/flatpak/pacote-flatpak-zapzap.sh                   # Script para instalar o ZapZap (cliente de WhatsApp via Flatpak)
"$install"/pacman/pacote-pacman-flameshot.sh                  # Script para insalar Flameshot, aplicativo para Screenshots com mais opções que o padrão do Gnome
# "$install"/aur/pacote-aur-yaru-theme-full.sh                # Script para instalar o Tema Yaru completo via AUR  
# "$install"/pacman/pacote-pacman-orchis-theme-full.sh        # Script para instalar o Tema Orchis completo via Pacman  
# "$install"/helper/pacote-helper-yay_instalar.sh             # Executa o script para instalar o AUR helper Yay  


# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

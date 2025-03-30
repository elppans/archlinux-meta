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

# Gerenciamento de pacotes e manutenção do sistema

"$install"/pacman/gerenciador-de-pacotes-flatpak.sh # Gerenciador de pacotes Flatpak
# "$install"/pacman/gerenciador-de-pacotes-snapd.sh # Gerenciador de pacotes Snapd (Recomendado ativar instalação de AppArmor)
"$install"/helper/pacote-helper-paru_instalar.sh # Wrappers do pacman (AUR Helper) - paru
# "$install"/helper/pacote-helper-yay_instalar.sh  # Wrappers do pacman (AUR Helper) - yay
"$install"/pacman_aur/repositorio-chaotic-aur.sh # Adicionar repositório Chaotic-AUR
"$install"/pacman_aur/pacote-pacman-kernel-hook.sh # Kernel: Pacote para gerenciar os módulos do kernel após atualizações
"$install"/pacman/pacote-gnome-wayland-session.sh # Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland:

# Remoção de pacotes:

sudo pacman --noconfirm -R epiphany gnome-music loupe  # Remove o navegador GNOME Web, o aplicativo de música e o visualizador de imagens modernos do GNOME.

# Instalação de pacotes

"$install"/pacman/detect-and-install-vm-packages.sh # Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários
"$install"/pacman/pacote-gnome-applications.sh      # Aplicações Gnome
"$install"/pacman/pacote-gnome-complements.sh       # Complementos para o GNOME
"$install"/pacman/pacote-other-applications.sh # Demais aplicações
"$install"/pacman_aur/pacote-aur-actions-for-nautilus.sh # Ações adicionais para o Nautilus (explorador de arquivos)

# Temas e ícones para personalização do GNOME:  

# "$install"/pacman_aur/pacote-aur-yaru-theme-full.sh         # Tema Yaru completo via AUR  
# "$install"/pacman/pacote-pacman-orchis-theme-black.sh       # Tema Orchis COMPLETO
"$install"/pacman/pacote-pacman-orchis-theme-black.sh         # Tema Orchis Black
"$install"/pacman/pacote-pacman-icon-theme.sh                 # Tema de ícones
"$install"/pacman_aur/pacote-pacman-sound-theme.sh            # Tema de som (Via AUR)

# Instalação de pacotes DIVERSOS

"$install"/pacman_aur/pacote-aur-mystiq_instalar.sh           # Conversor de vídeo e áudio baseado no FFmpeg com interface gráfica simples
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




# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

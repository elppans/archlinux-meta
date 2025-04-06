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
export install

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

# Atualização completa do sistema e instalação de pacotes excenciais para a base e gerenciador de pacotes

sudo pacman --needed --noconfirm -Syyu base-devel git         # Atualiza os sistema e instala pacotes essenciais para desenvolvimento junto com o Git.
sudo pacman --needed --noconfirm -S expac                     # Ferramenta para exibir informações detalhadas sobre pacotes do pacman  
sudo pacman --needed --noconfirm -S pkgfile                   # Utilitário para buscar arquivos pertencentes a pacotes no repositório  
sudo pkgfile -u

# Gerenciamento de pacotes e manutenção do sistema

"$install"/pacman/gerenciador-de-pacotes-flatpak.sh           # Gerenciador de pacotes Flatpak
# "$install"/pacman/gerenciador-de-pacotes-snapd.sh           # Gerenciador de pacotes Snapd (Recomendado ativar instalação de AppArmor)
"$install"/helper/pacote-helper-paru_instalar.sh              # Wrappers do pacman (AUR Helper) - paru
# "$install"/helper/pacote-helper-yay_instalar.sh             # Wrappers do pacman (AUR Helper) - yay
"$install"/pacman_aur/repositorio-chaotic-aur.sh              # Adicionar repositório Chaotic-AUR
"$install"/pacman/pacote-pacman-kernel-hook.sh            # Kernel: Pacote para gerenciar os módulos do kernel após atualizações
"$install"/pacman/pacote-gnome-wayland-session.sh             # Garantindo que o Gnome Shell funcione corretamente em uma Sessão Wayland:

# Remoção de pacotes:

sudo pacman --noconfirm -R epiphany gnome-music         # Remove o navegador GNOME Web, o aplicativo de música do GNOME.

# Instalação de pacotes

"$install"/pacman/detect-and-install-vm-packages.sh           # Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários
"$install"/pacman/pacote-gnome-applications.sh                # Aplicações Gnome
"$install"/pacman/pacote-gnome-complements.sh                 # Complementos para o GNOME
"$install"/pacman/pacote-other-applications.sh                # Demais aplicações
"$install"/pacman_aur/pacote-aur-actions-for-nautilus.sh      # Ações adicionais para o Nautilus (explorador de arquivos)

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
"$install"/flatpak/pacote-flatpak-dbeaver-ce.sh             # Script para instalar o DBeaver Community Edition via Flatpak
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
"$install"/flatpak/pacote-flatpak-vscodium.sh               # Script para instalar o VSCodium (editor de código baseado no VSCode) via Flatpak
"$install"/flatpak/pacote-flatpak-zapzap.sh                   # Script para instalar o ZapZap (cliente de WhatsApp via Flatpak)
"$install"/pacman/pacote-pacman-flameshot.sh                  # Script para insalar Flameshot, aplicativo para Screenshots com mais opções que o padrão do Gnome
# Adicionar libreoffice (still)

# Configurações do sistema

"$install"/config/Gnome-Shell/gnome-shell-set.sh              # Configurações do Gnome Shell+
"$install"/config/System/samba-share-set.sh                   # Configuração do SAMBA

# Customizações do sistema com Scripts
cd "$install" || exit 1
find "$install"/custom -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "custom", desde que tenham permissão de execução

# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

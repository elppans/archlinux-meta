#!/bin/bash
# shellcheck disable=SC2155,SC2162,SC2046

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

# Define variáveis
USER_REAL="$USER"
HOME_REAL="$HOME"
BKP_NAME="$HOME_REAL.BKP_$(date +%Y%m%d_%H%M)"

echo "Iniciando reset do ambiente de usuário para: $USER_REAL"
sleep 3

# 1. Move o diretório atual (Backup)
# Usamos sudo mas garantimos que o caminho seja absoluto
sudo mv "$HOME_REAL" "$BKP_NAME"

# 2. Cria o novo HOME
sudo mkdir -p "$HOME_REAL"

# 3. Copia TUDO do skel (não apenas .bash*)
# O ponto '.' ao final de /etc/skel/. garante que arquivos ocultos sejam copiados
sudo cp -ra /etc/skel/. "$HOME_REAL/"

# 4. Ajusta permissões de forma recursiva
# Garante que o usuário e o grupo principal do usuário sejam donos
sudo chown -R "$USER_REAL":"$(id -gn "$USER_REAL")" "$HOME_REAL"

echo "Processo concluído. O backup está em: $BKP_NAME"

echo -e 'Redefinindo o Shell do usuário'
sleep 3
sudo chsh -s /bin/bash "$USER"

# Pause para verificar se as respostas estão corretas.
# Se OK, apertar ENTER para continuar, senão, CTRL+C para cancelar
read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo de instalação de TODOS os pacotes instalados "como Explicitamente" para "como dependência"'
sleep 5
sudo pacman -D --asdeps $(pacman -Qqn)

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo da instalação para "como explicitamente" apenas os PACOTES ESSENCIAIS. Aqueles que você NÃO deseja remover'
sleep 5
sudo pacman -D --asexplicit $(pacman -Qqs ucode) base linux linux-firmware btrfs-progs git nano networkmanager pipewire wpa_supplicant wireless_tools sudo wget

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Remover os pacotes, menos os configurados como "Instalados Explicitamente"'
sleep 5
sudo pacman -Rsunc $(pacman -Qttdq)

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Retornando alguns pacotes de compilação'
sleep 5
sudo pacman --needed --noconfirm -S base-devel

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Garantindo o GRUB'
sleep 5
sudo pacman -S --needed --noconfirm grub-efi-x86_64 efibootmgr dosfstools os-prober mtools
sudo grub-mkconfig -o /boot/grub/grub.cfg

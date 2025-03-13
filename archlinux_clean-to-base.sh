#!/bin/bash
# shellcheck disable=SC2155,SC2162,SC2046

# Variáveis para o HOME e Backup na data atual
export HM="$(basename "$HOME")"
export HMN="$HM.BKP_$(date +%d%m%H%M)"

echo -e 'Renomear diretório "HOME" para backup e criar novo diretório de usuário.'
sleep 5
cd /home || exit
sudo mv -v /home/"$HM"  /home/"$HMN"
sudo mkdir -p "$HOME"
sudo cp -av /etc/skel/.bash* "$HOME"
sudo chown -R "$USER":"$USER" "$HOME"

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

#!/bin/bash
# shellcheck disable=SC2155,SC2162

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
read -p "Apertae ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo de instalação de TODOS os pacotes instalados "como Explicitamente" para "como dependência"'
sleep 5
sudo pacman -D --asdeps "$(pacman -Qqe)"

read -p "Apertae ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo da instalação para "como explicitamente" apenas os PACOTES ESSENCIAIS. Aqueles que você NÃO deseja remover'
sleep 5
sudo pacman -D --asexplicit base base-devel linux linux-headers linux-firmware amd-ucode intel-ucode btrfs-progs git fakeroot reflector nano ntp man-db man-pages texinfo grub-efi-x86_64 efibootmgr dosfstools os-prober mtools networkmanager wpa_supplicant wireless_tools dialog sudo pkgconf wget

read -p "Apertae ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Remover os pacotes, menos os configurados como "Instalados Explicitamente"'
sleep 5
sudo pacman -Rsunc "$(pacman -Qtdq)"

read -p "Apertae ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Retornando alguns pacotes de compilação'
sleep 5
sudo pacman --needed --noconfirm -S base-devel

read -p "Apertae ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Garantindo o GRUB'
sleep 5
sudo pacman -S --needed --noconfirm grub-efi-x86_64 efibootmgr dosfstools os-prober mtools
sudo grub-mkconfig -o /boot/grub/grub.cfg

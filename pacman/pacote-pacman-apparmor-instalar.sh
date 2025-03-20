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

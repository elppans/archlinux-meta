#!/bin/bash

# No final, é criado uma senha de compartilhamento para o usuário atual como "arch"
# Modifique a senha para sua preferência com o comando sudo smbpasswd SEU_USUÁRIO

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


#!/bin/bash

# Instalar o Virt Manager e pacotes essenciais
sudo pacman --needed --noconfirm -Syu virt-manager qemu-desktop swtpm dmidecode dnsmasq edk2-ovmf

# Pacote legado, agora só existe no AUR
# sudo pacman --needed --noconfirm -Syu bridge-utils

# Define os grupos aos quais o usuário deve ser adicionado
sudo usermod -aG kvm "$USER"
grep virt /etc/group | cut -d: -f1 | while IFS= read -r gvirt; do
	sudo usermod -a -G "$gvirt" "$USER"
done

# Remove qualquer configuração existente do firewall_backend
sudo sed -i '/^firewall_backend/d' /etc/libvirt/network.conf

# Define o firewall_backend como iptables
echo 'firewall_backend = "iptables"' | sudo tee -a /etc/libvirt/network.conf >>/dev/null

if [ -f /etc/qemu/bridge.conf ]; then
	sudo touch /etc/qemu/bridge.conf
fi

# Liberar o uso de qualquer rede/bridge para o Virt Manager/QEMU (sem restringir a interfaces específicas)
grep -q 'allow all' /etc/qemu/bridge.conf || echo 'allow all' | sudo tee -a /etc/qemu/bridge.conf &>>/dev/null

# Liberar o uso apenas a "portas Fixas" (br0 até br9)
# for i in {0..9}; do echo "allow br$i" | sudo tee -a /etc/qemu/bridge.conf ; done

# Habilitar Encaminhamento de Pacotes IPv4
grep -q 'net.ipv4.ip_forward=1' /etc/sysctl.d/99-sysctl.conf &>>/dev/null || echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf >>/dev/null

# Aplicar a configuração imediatamente sem precisar reiniciar o sistema:
sudo sysctl -w net.ipv4.ip_forward=1

# Recarrega/atualiza as informações do SystemD
sudo systemctl daemon-reload

# Ativa/Inicia/Reinicia o serviço libvirtd
if systemctl is-enabled libvirtd.service &>/dev/null; then
	sudo systemctl restart libvirtd.service
else
	sudo systemctl enable --now libvirtd.service
fi

# Iniciar e configurar a rede NAT para iniciar de forma automatica:
sudo virsh net-start default 2>/dev/null
sudo virsh net-autostart default

# Verificar a configuração da rede NAT
sudo virsh net-list

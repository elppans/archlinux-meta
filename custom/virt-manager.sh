#!/bin/bash

# Instalar o Virt Manager e pacotes essenciais
sudo pacman --needed --noconfirm -Syu virt-manager qemu-desktop swtpm dmidecode dnsmasq edk2-ovmf

# Pacote legado, agora só existe no AUR
# sudo pacman --needed --noconfirm -Syu bridge-utils

# Habilitar "Instrospecção de VM via libguestfs"
# Atenção — no Arch essa combinação é conhecida por dar dor de cabeça:
# O libguestfs precisa montar um "appliance" (uma mini-VM interna) para inspecionar o disco, 
# e isso costuma falhar no Arch com erros como "cannot find any suitable libguestfs supermin appliance", 
# porque o Arch não gera o appliance da forma tradicional (via supermin) que outras distros usam.
# sudo pacman --needed --noconfirm -Syu libguestfs python-libguestfs

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

# Ativar conexão QEMU/KVM - O padrão é "libvirt-lxc"
dconf write /org/virt-manager/virt-manager/connections/uris "['qemu:///system']"
dconf write /org/virt-manager/virt-manager/connections/autoconnect "['qemu:///system']"

# Configurar padrão de novas VMs para UEFI - O padrão é BIOS
dconf write /org/virt-manager/virt-manager/new-vm/firmware "['uefi']"

# Configurar padrão de disco de novas VMs para QCOW2 - O padrão é QCOW2 mesmo
dconf write /org/virt-manager/virt-manager/new-vm/storage-format "['qcow2']"

# Criar disco grande com arquivo pequeno (O mesmo efeito que o Boxes)
# qemu-img create -f qcow2 -o preallocation=off /caminho/disco.qcow2 40G

# Em uma definição de XML gerada pelo GNOME Boxes, a tag do disco aparece como 
# disk type='file' device='disk' com driver name='qemu' type='qcow2' cache='writeback'.
# Fonte: https://tracker.pureos.net/T292

# Disco no "virt-install":

# sparse=yes (Já é o padrão - Quando usado --disk path)
# virt-install --name minha-vm --disk path=/caminho/disco.qcow2,size=54,format=qcow2,sparse=yes ...

# Usando o arquivo já criado:
# Neste caso, não precisa especificar tamanho e o parâmetro "sparse", pois já foi configurado pelo qemu-img
# virt-install --name minha-vm --disk path=/caminho/disco.qcow2,format=qcow2 ...

# Iniciar Virt Manager minimizado
# Não existe nativamente

# No Hyprland:
# Configurar exec-once = virt-manager → inicia junto com a sessão
# Configurar windowrulev2 = workspace special:silent, class:^(virt-manager)$ → nasce escondido
# Ícone na bandeja → clique nele quando precisar abrir a janela

# No Gnome:
# precisaria de uma extensão tipo "Hide Window" ou "AutoMinimize" da extensions.gnome.org, 
# já que no Wayland ferramentas como xdotool não funcionam para forçar minimização de outros apps.


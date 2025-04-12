#!/bin/bash

# Função para detectar se o sistema está em uma VM
detect_vm() {
    # Verifica se o comando systemd-detect-virt existe
    if command -v systemd-detect-virt &> /dev/null; then
        VM_TYPE=$(systemd-detect-virt)
        if [ "$VM_TYPE" != "none" ]; then
            echo "VM detectada: $VM_TYPE"
            return 0
        else
            echo "Nenhuma VM detectada (systemd-detect-virt)."
            return 1
        fi
    fi

    # Se systemd-detect-virt não estiver disponível, tenta usar lscpu
    if command -v lscpu &> /dev/null; then
        if lscpu | grep -i -q hypervisor; then
            echo "VM detectada (lscpu)."
            return 0
        else
            echo "Nenhuma VM detectada (lscpu)."
            return 1
        fi
    fi

    # Se lscpu não estiver disponível, verifica /proc/cpuinfo
    if grep -i -q hypervisor /proc/cpuinfo; then
        echo "VM detectada (/proc/cpuinfo)."
        return 0
    else
        echo "Nenhuma VM detectada (/proc/cpuinfo)."
        return 1
    fi
}

# Função para instalar pacotes com base no hypervisor detectado
install_vm_packages() {
    case "$1" in
        "kvm" | "qemu")
            echo "Instalando pacotes para QEMU/KVM..."
            sudo pacman --needed --noconfirm -S qemu-guest-agent spice-vdagent xf86-input-vmmouse xf86-video-qxl gdk-pixbuf-xlib
            sudo systemctl enable qemu-guest-agent spice-vdagentd
            ;;
        "vmware")
            echo "Instalando pacotes para VMWare..."
            sudo pacman --needed --noconfirm -S open-vm-tools
            sudo systemctl enable vmtoolsd
            ;;
        "oracle")
            echo "Instalando pacotes para VirtualBox..."
            sudo pacman --needed --noconfirm -S virtualbox-guest-utils
            sudo systemctl enable vboxservice
            ;;
        *)
            echo "Hypervisor não suportado ou não detectado."
            ;;
    esac
}

# Executa a detecção de VM
if detect_vm; then
    # Se uma VM foi detectada, instala os pacotes apropriados
    install_vm_packages "$VM_TYPE"
else
    echo "Nenhuma VM detectada. Nada a fazer."
fi

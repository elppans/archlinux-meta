#!/bin/bash

function setup_arch_linux() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script deve ser executado como root." >&2
        exit 1
    fi

    if ! command -v arch-chroot &> /dev/null; then
        echo "O comando arch-chroot não foi encontrado. Por favor, instale o pacote arch-install-scripts." >&2
        exit 1
    fi

    local root_partition="$1"
    local boot_partition="$2"

    if [[ -z "$root_partition" || -z "$boot_partition" ]]; then
        echo "Uso: setup_arch_linux <root_partition> <boot_partition>" >&2
        exit 1
    fi

    echo "Montando partições..."
    mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@ "$root_partition" /mnt
    mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@cache "$root_partition" /mnt/var/cache
    mount -o relatime,space_cache=v2,discard=async,autodefrag,compress=zstd,commit=10,subvol=@log "$root_partition" /mnt/var/log
    mount "$boot_partition" /mnt/boot/efi

    echo "Verificando partições montadas:"
    mount | grep "/mnt"

    echo "Instalando GRUB..."
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux --recheck
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

    echo "Configuração concluída."
}

setup_arch_linux "$@"


#!/bin/bash

sudo pacman -S --needed --noconfirm grub-efi-x86_64 efibootmgr dosfstools os-prober mtools
sudo grub-mkconfig -o /boot/grub/grub.cfg

#!/bin/bash

sudo systemctl disable lightdm.service
sudo pacman -Rsunc lightdm-gtk-greeter-settings


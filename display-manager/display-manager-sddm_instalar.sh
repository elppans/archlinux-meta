#!/bin/bash
# shellcheck disable=SC2046

sudo pacman -S sddm sddm-kcm
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable sddm.service


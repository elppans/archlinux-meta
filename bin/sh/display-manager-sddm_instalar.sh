#!/bin/bash

sudo pacman --needed -S sddm sddm-kcm
# shellcheck disable=SC2046
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable sddm.service


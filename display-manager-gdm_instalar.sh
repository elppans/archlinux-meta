#!/bin/bash

sudo pacman -S gdm
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable gdm.service


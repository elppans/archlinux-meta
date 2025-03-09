#!/bin/bash

yay -S --needed xboxdrv
sudo systemctl enable --now xboxdrv.service

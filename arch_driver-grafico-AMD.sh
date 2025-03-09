#!/bin/bash

sudo pacman --needed --noconfirm -S libva-mesa-driver \
mesa \
vulkan-radeon \
xf86-video-amdgpu \
xf86-video-ati \
xorg-server \
xorg-xinit


#!/bin/bash

# Repositórios
temp_dir="$(mktemp -d big-comm-repo.XXXXXXXXXX)"
cd "$temp_dir" || exit 1
git clone https://github.com/elppans/big-comm-repo.git
cd big-comm-repo || exit 1
makepkg -si
cd - || exit 1
rm -rf "$temp_dir"
sudo pacman -Syyu

pacotes=(
# Pacotes retirados
# bigbashview
# bigblocks
# bigcommunity-name
# big-kernel-manager # Não há pacote
# big-mount
# big-parental-controls
# big-preload
# big-theme-colloided-adwaita
# biglinux-apps-rename
# biglinux-base-icons
# biglinux-bash-config # Depende de: ttf-meslo-nerd-font-powerlevel10k (instalar primeiro)
# biglinux-hibernate-in-swapfile-btrfs
# biglinux-improve-compatibility
# biglinux-keyring
# biglinux-l18n
# biglinux-metapackage
# biglinux-mime # Este pacote depende de pamac
# biglinux-nano-config
# biglinux-systemd-swap
# biglinux-vaapi
# comm-improve-compatibility
# comm-skel
# community-release
# ghc-libs
# grub-theme-community
# jbig2dec
# jbig2enc
# jbigkit
# libbytesize
# mhwd-biglinux
# perl
# plymouth-theme-community
# power-profiles-daemon-biglinux
# rhvoice-brazilian-portuguese-complementary-dict-biglinux
# ttf-nerd-fonts-symbols-with-biglinux
# tts-biglinux

# Principais pacotes
big-bibata-cursor-theme
big-hardware-info
bigicons-papient
biglinux-driver-manager
biglinux-settings
comm-wallpapers-gnome
comm-gnome-config
gnome-shell-big-shot
gnome-shell-extension-copyous
gnome-shell-extension-gtk4-desktop-icons-ng
numlockx
pnpm

# Pacotes adicionais
big-audio-converter
big-network-info
big-video-converter
biglinux-meta-audio-config
biglinux-noise-reduction-pipewire
# biglinux-webapps
bigocrpdf
bigrecorder
bigsudo
pipewire-biglinux-config
)

yay --needed --noconfirm --removemake --sudoloop -S "${pacotes[@]}" --overwrite \*

# # Aplicativo de temas
temp_dir="$(mktemp -d big-gnome-center.XXXXXXXXXX)"
cd "$temp_dir" || exit 1
# git clone https://github.com/elppans/big-gnome-center.git
# cd big-gnome-center/pkgbuild || exit 1
# yay --noconfirm --removemake --sudoloop -S comm-gnome-config --overwrite \*
# sed -i 's/big-comm/elppans/' PKGBUILD
# makepkg -Cris
wget -q https://github.com/elppans/big-gnome-center/releases/download/26.09.30-2326/big-gnome-center-26.09.30-2326-any.pkg.tar.zst
sudo pacman -U big-gnome-center-26.09.30-2326-any.pkg.tar.zst
cd - || exit 1
rm -rf "$temp_dir"

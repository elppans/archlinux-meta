#!/usr/bin/env bash

# Pacote de chaves do repositório do BIGLinux
sudo ln -sf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorcdn
temp_dir="$(mktemp -d biglinux-keyring.XXXXXXXXXX)"
cd "$temp_dir" || exit 1
curl -O https://repo.biglinux.com.br/stable/x86_64/biglinux-keyring-20220827-3-any.pkg.tar.zst
curl -O https://repo.biglinux.com.br/stable/x86_64/biglinux-keyring-20220827-3-any.pkg.tar.zst.sig
key_id="$(echo "$(gpg --homedir /etc/pacman.d/gnupg --verify biglinux-keyring-20220827-3-any.pkg.tar.zst.sig biglinux-keyring-20220827-3-any.pkg.tar.zst 2>&1 || true)" | grep -E 'using|usando|usar' | grep -oiE '[0-9a-f]{8,40}')"
sudo pacman-key --recv-keys "$key_id" --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key "$key_id"
sudo pacman -U --noconfirm biglinux-keyring-20220827-3-any.pkg.tar.zst
cd - || exit 1
rm -rf "$temp_dir"
sed -i 's/SyncFirst/# SyncFirst/g' /etc/pacman.conf

# Pacote de chaves do repositório BIG Community
temp_dir="$(mktemp -d community-keyring.XXXXXXXXXX)"
cd "$temp_dir" || exit 1
git clone https://github.com/big-comm/community-keyring.git
cd community-keyring || exit 1
makepkg -Cris
cd - || exit 1
rm -rf "$temp_dir"

# Pacote para a adição dos repositórios do BIGLinux e BIGCommunity
temp_dir="$(mktemp -d big-comm-repo.XXXXXXXXXX)"
cd "$temp_dir" || exit 1
git clone https://github.com/elppans/big-comm-repo.git
cd big-comm-repo || exit 1
makepkg -si
cd - || exit 1
rm -rf "$temp_dir"

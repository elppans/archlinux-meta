#!/usr/bin/env bash

set -euo pipefail

# Dependências do sistema (openSUSE)
SYS_PKGS=(
    jq ruby ShellCheck shfmt nodejs npm
)

# Dependências Node.js (Globais)
NODE_PKGS=(
    "prettier"
    "stylelint"
)

echo "==> Atualizando repositórios e instalando pacotes do sistema..."
if command -v zypper ; then
	sudo zypper --non-interactive refresh
	sudo zypper --non-interactive install --no-recommends "${SYS_PKGS[@]}"
elif command -v pacman ; then
    sudo pacman -Syu --needed --noconfirm "${SYS_PKGS[@]}"
fi

echo "==> Instalando ferramentas CLI globais via npm..."
sudo npm install --global "${NODE_PKGS[@]}"

echo "==> Verificando instalações:"
for cmd in jq prettier ruby shellcheck shfmt stylelint; do
    if command -v "$cmd" &> /dev/null; then
        echo "  [✓] $cmd: $(which $cmd)"
    else
        echo "  [✗] $cmd não encontrado no PATH"
    fi
done
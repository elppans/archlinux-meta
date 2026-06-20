#!/bin/bash
# shellcheck disable=SC1073,SC1072

mkdir -p "$HOME/build"
cd "$HOME/build" || exit 1
scversion="stable" # or "v0.4.7", or "latest"
wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJ
sudo cp "shellcheck-${scversion}/shellcheck" /usr/local/bin/
# shellcheck --version

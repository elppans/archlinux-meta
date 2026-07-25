#!/usr/bin/env bash

mkdir -p "$HOME"/.ssh/{sockets,config.d}
curl -JLk -o "$HOME/.ssh/config" "https://raw.githubusercontent.com/elppans/ssh_config/refs/heads/main/config"
chmod 600 "$HOME/.ssh/config"
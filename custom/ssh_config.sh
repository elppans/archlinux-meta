#!/usr/bin/env bash

mkdir -p "$HOME/.ssh/sockets"
curl -JLk -o "$HOME/.ssh/config" "https://raw.githubusercontent.com/elppans/ssh_config/refs/heads/main/config"

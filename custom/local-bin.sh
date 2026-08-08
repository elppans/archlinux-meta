#!/bin/bash

# Scripts/Comandos customizados em bin local
# shellcheck disable=SC2154,SC2016
chmod +x "$install"/bin/*
sudo cp -a "$install"/bin/* /usr/local/bin

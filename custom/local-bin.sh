#!/bin/bash

# Scripts/Comandos customizados em bin local
# shellcheck disable=SC2154
chmod +x "$install"/bin/*
sudo cp -a "$install"/bin/* /usr/local/bin

#
if [ ! -f /usr/local/bin/faceconv.sh ]; then
	sudo curl -JLk -o "/usr/local/bin/faceconv.sh" "https://raw.githubusercontent.com/elppans/sddm-silent-customizer/refs/heads/main/usr/local/bin/faceconv"
	sudo chmod +x "/usr/local/bin/faceconv.sh"
fi

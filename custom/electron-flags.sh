#!/bin/bash
# shellcheck disable=SC2086

# Usar aplicações baseadas no electron nativamente no Wayland
echo -e '--enable-features=UseOzonePlatform
--ozone-platform=wayland' | tee ${XDG_CONFIG_HOME}/electron-flags.conf
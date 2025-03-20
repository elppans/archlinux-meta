#!/bin/bash
# shellcheck disable=SC2027,SC2046
sudo pacman --needed --noconfirm -S flameshot
sudo pacman --needed --noconfirm -Syyu ""$(/usr/bin/expac -S "%o" flameshot | tr ' ' '\n')""  
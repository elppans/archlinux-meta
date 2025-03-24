#!/bin/bash

cd "$HOME"
sudo pacman --needed --noconfirm -S xdg-user-dir swappy satty
mkdir -p "$HOME"/.config/hyde/themes
cp -a ./HyDE/Configs/.local "$HOME"/.config/hyde

echo -e '#!/bin/bash
source $HOME/.config/hyde/.local/bin/hyde-shell
XDG_PICTURES_DIR="$(xdg-user-dir PICTURES)"
export XDG_PICTURES_DIR
$LIB_DIR/hyde/screenshot.sh "$@"
' | tee $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh
chmod +x $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh

# DEVE adicionar no arquivo custom.conf do tema ML4W as seguintes linhas, para que o Script possa ser usado
# DESCOMENTE as linhas de variáveis para que os atalhos possam ser ativados

# Configuração do arquivo keybindings
# $d=[$ut|Screen Capture]
# bindd = $mainMod Shift, P, $d color picker, exec, hyprpicker -an # Pick color (Hex) >> clipboard#
# bindd = $mainMod SHIFT, PRINT, $d freeze and snip screen, exec, $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh s # partial screenshot capture
# bindd = $mainMod CTRL, PRINT, $d freeze and snip screen, exec, $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh sf # partial screenshot capture (frozen screen)
# binddl = $mainMod ALT, PRINT, $d print monitor , exec, $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh m # monitor screenshot capture
# binddl = , PRINT, $d print all monitors , exec, $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh p # all monitors screenshot capture


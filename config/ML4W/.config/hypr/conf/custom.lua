-- -----------------------------------------------------
-- AUTOSTART (INICIALIZAÇÃO)
-- -----------------------------------------------------
-- exec-once = /usr/local/bin/autostart.sh
-- exec-once = flatpak run --command=zapzap com.rtosta.zapzap --hideStart
-- exec-once = flatpak run com.rtosta.zapzap --hideStart
-- exec-once = flatpak run com.discordapp.Discord %U --start-minimized
-- exec-once = flatpak run com.valvesoftware.Steam %U -silent
-- exec-once = flatpak run com.heroicgameslauncher.hgl %U
-- exec-once = flatpak run --command=Telegram org.telegram.desktop -autostart


-- -----------------------------------------------------
-- ATALHOS - APLICATIVOS E SISTEMA
-- -----------------------------------------------------

bind("$mainMod", "A", "exec", "pkill rofi || rofi -show drun -replace -i")
-- Launcher de aplicativos (Rofi)

bind("$mainMod", "HOME", "exec", "~/.config/waybar/toggle.sh")
-- Alternar visibilidade da Waybar

bind("$mainMod CTRL", "HOME", "exec", "~/.config/waybar/launch.sh")
-- Recarregar/Reiniciar Waybar

bind("CTRL ALT", "DELETE", "exec", "qs ipc call power toggle")
-- Menu de energia (Power Menu)

bind("$mainMod SHIFT", "E", "exec", "~/.config/ml4w/settings/emojipicker.sh")
-- Open the emoji picker (com.tomjwatson.Emote)

bind("$mainMod SHIFT", "C", "exec", "~/.config/ml4w/settings/calculator.sh")
-- Open the calculator (org.gnome.Calculator)

bind("CTRL ALT", "right", "workspace", "e+1")
-- Open next workspace

bind("CTRL ALT", "left", "workspace", "e-1")
-- Open previous workspace

bind("CTRL ALT", "up", "workspace", "empty")
-- Open the next empty workspace


-- -----------------------------------------------------
-- GERENCIAMENTO DE JANELAS (LAYOUT)
-- -----------------------------------------------------

bind("$mainMod", "END", "togglefloating")
-- Alternar janela atual para flutuante

bind("$mainMod SHIFT", "END", "workspaceopt", "allfloat")
-- Alternar todas as janelas para flutuante

bind("$mainMod", "J", "layoutmsg", "togglesplit")
-- Alternar divisão (Vertical/Horizontal)

bind("$mainMod", "PAGE_UP", "layoutmsg", "togglesplit")
-- Alternar divisão (Atalho 2)

bind("$mainMod CTRL", "left", "layoutmsg", "togglesplit")
-- Alternar divisão (Atalho 3)

bind("$mainMod", "K", "layoutmsg", "swapsplit")
-- Trocar lado das janelas divididas

bind("$mainMod", "PAGE_DOWN", "layoutmsg", "swapsplit")
-- Trocar lado (Atalho 2)

bind("$mainMod CTRL", "right", "layoutmsg", "swapsplit")
-- Trocar lado (Atalho 3)


-- Mover posição das janelas (Swap)

unbind("$mainMod ALT", "left")
unbind("$mainMod ALT", "right")
unbind("$mainMod ALT", "up")
unbind("$mainMod ALT", "down")

binde("$mainMod ALT", "left", "swapwindow", "l")
-- Mover janela para a esquerda

binde("$mainMod ALT", "right", "swapwindow", "r")
-- Mover janela para a direita

binde("$mainMod ALT", "up", "swapwindow", "u")
-- Mover janela para cima

binde("$mainMod ALT", "down", "swapwindow", "d")
-- Mover janela para baixo


-- -----------------------------------------------------
-- CAPTURA DE TELA E FERRAMENTAS
-- -----------------------------------------------------

bindle("", "XF86AudioRaiseVolume", "exec",
    "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+")
-- Increase volume by 5% (max 100% limit also added hold to raise volume)

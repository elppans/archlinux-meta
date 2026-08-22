-- Configuration
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- ----------------------------------------------------- 
-- ------------- APLICATIVOS CUSTOMIZADOS --------------
-- ----------------------------------------------------- 

-- Captura de tela e ferramentas
-- Habilitar estas linhas apenas se for instalado o aplicativo de screenshot do HyprDE (ml4w_hyde_bin_install.sh)
-- OBSERVAÇÃO: AINDA EM EDIÇÃO
-- ----------------------------------------------------- 
-- $d=[$ut|Screen Capture]
-- bindd = $mainMod Shift, P, $d color picker, exec, hyprpicker -an       -- Seletor de cores (Hex -> Clipboard)
-- bindd = $mainMod SHIFT, PRINT, $d snip, exec, hyprctl dispatch exec "[float; center; size 900 600] $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh s"                   -- Print de área selecionada
-- binddl = $mainMod ALT, PRINT, $d print all, exec, hyprctl dispatch exec "[float; center; size 900 600] $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh p"               -- Print de todos os monitores
-- binddl = , PRINT, $d print monitor, exec, hyprctl dispatch exec "[float; center; size 900 600] $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh m"                       -- Print do monitor atual
-- bindd = $mainMod CTRL, PRINT, $d freeze and snip screen, exec, hyprctl dispatch exec "[float; center; size 900 600] $HOME/.config/hyde/.local/lib/hyde/screenshot2.sh sf" -- partial screenshot capture (frozen screen)
-- bind = SHIFT, Print, exec, grim -g "$(slurp)" - | swappy -f - -- Print de área selecionada (Requer: grim, slurp e swappy)
-- bind = CTRL, Print, exec, grim -t png /tmp/screen_freeze.png && grim -g "$(slurp)" - | swappy -f - && rm /tmp/screen_freeze.png -- Print de área selecionada (frozen screen (Requer: grim, slurp e swappy))

-- ----------------------------------------------------- 
-- ---------- CONFIGURAÇÕES DO SISTEMA -----------------
-- ----------------------------------------------------- 

-- ----------------------------------------------------- 
-- AUTOSTART (INICIALIZAÇÃO)
-- ~/.config/hypr/conf/autostart.lua
-- ----------------------------------------------------- 
-- Autostart do sistema
-- hl.exec_cmd("/usr/local/bin/autostart.sh")

-- ZapZap minimizado
-- hl.exec_cmd("flatpak run --command=zapzap com.rtosta.zapzap --hideStart")

-- Discord minimizado
-- hl.exec_cmd("flatpak run com.discordapp.Discord %U --start-minimized")

-- Steam em modo silencioso
-- hl.exec_cmd("flatpak run com.valvesoftware.Steam %U -silent")

-- Heroic Games Launcher
-- hl.exec_cmd("flatpak run com.heroicgameslauncher.hgl %U")

-- Telegram
-- hl.exec_cmd("flatpak run --command=Telegram org.telegram.desktop -autostart")

-- ----------------------------------------------------- 
-- Key Bindings
-- ~/.config/hypr/conf/keybindings/default.lua
-- ----------------------------------------------------- 

-- Windows
hl.bind(mainMod .. " + DELETE", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(mainMod .. " + SHIFT + DELETE", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-allfloat"), { description = "Toggle floating for all windows of workspace" })
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.layout("swapsplit"), { description = "Swapsplit" })

-- Este atalho não funciona mesmo com "unbind > bind" e não tenho idéia de como resolve
-- hl.unbind(mainMod .. " + ALT + left")
-- hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap tiled window left" })

-- Action

-- Screenshots: substituir os atalhos padrão do ML4W
-- Pacotes necessários: hyprshot satty wl-clipboard
hl.unbind(mainMod .. " + PRINT")
hl.unbind(mainMod .. " + ALT + F")
hl.unbind(mainMod .. " + ALT + S")
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -"), { description = "Screenshot: select area and annotate" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.exec_cmd("hyprshot -m output"), { description = "Take an instant full-screen screenshot" })
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("hyprshot -m region"), { description = "Take an instant area screenshot" })

-- 
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/launcher.sh"), { description = "Open application launcher" })
hl.bind(mainMod .. " + CTRL + DELETE", hl.dsp.exec_cmd("qs ipc call power toggle"), { description = "Start Power Menu" })
hl.bind(mainMod .. " + CTRL + HOME", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-reload-statusbar"), { description = "Reload Status Bar" })
hl.bind(mainMod .. " + HOME", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-statusbar"), { description = "Toggle Status Bar" })
hl.bind(mainMod .. " + CTRL + END", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-reload-dock"), { description = "Reload Dock" })
hl.bind(mainMod .. " + END", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-toggle-dock"), { description = "Toggle Dock" })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.focus({ workspace = "e+1" }), { description = "Switch to next workspace" })
hl.bind(mainMod .. " + CTRL + LEFT",   hl.dsp.focus({ workspace = "e-1" }), { description = "Switch to previous workspace" })

-- Laptop multimedia keys for volume and LCD brightness
hl.unbind("XF86AudioRaiseVolume")
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.9 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = false, repeating = true, description = "Raise volume" })

-- -----------------------------------------------------
-- Input
-- ~/.config/hypr/input.lua
-- -----------------------------------------------------

hl.config({
    input = {
        kb_layout    = "br",
        kb_variant   = "abnt2",
        kb_model     = "pc104",
        kb_options   = "grp:alt_shift_toggle",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll = true,
        },
    },
})

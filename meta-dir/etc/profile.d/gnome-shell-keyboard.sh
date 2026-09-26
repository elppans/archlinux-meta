#!/usr/bin/env bash

gnome_shell_keyboard() {
# ==============================================================================
# 0. LIMPEZA DOS ATALHOS
# ==============================================================================

gsettings_set() {
# 1. Resetar atalhos nativos (Gravação e Lançadores)
gsettings reset org.gnome.shell.keybindings show-screen-recording-ui
gsettings reset org.gnome.settings-daemon.plugins.media-keys calculator
gsettings reset org.gnome.settings-daemon.plugins.media-keys email
gsettings reset org.gnome.settings-daemon.plugins.media-keys control-center
gsettings reset org.gnome.settings-daemon.plugins.media-keys help
gsettings reset org.gnome.settings-daemon.plugins.media-keys www
gsettings reset org.gnome.settings-daemon.plugins.media-keys home
gsettings reset org.gnome.settings-daemon.plugins.media-keys search

# 2. Resetar controle de Som e Mídia
gsettings reset org.gnome.settings-daemon.plugins.media-keys mic-mute
gsettings reset org.gnome.settings-daemon.plugins.media-keys volume-mute
gsettings reset org.gnome.settings-daemon.plugins.media-keys volume-up
gsettings reset org.gnome.settings-daemon.plugins.media-keys volume-down

# 3. Limpar a lista global de atalhos personalizados
gsettings reset org.gnome.settings-daemon.plugins.media-keys custom-keybindings

# 4. Apagar recursivamente as definições salvas no dconf para os atalhos customizados
# Nota: gsettings não possui operação recursiva nativa para caminhos relocáveis, 
# por isso utiliza-se o backend dconf diretamente aqui.
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/

# ==============================================================================
# 1. ATALHOS NATIVOS DO SISTEMA
# ==============================================================================

# Gravação de tela interativa
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Ctrl>Print']"

# Lançadores (System Launchers)
gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Shift><Super>c']"
gsettings set org.gnome.settings-daemon.plugins.media-keys email "['@as []']" # Desabilitado
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Ctrl><Super>c']"
gsettings set org.gnome.settings-daemon.plugins.media-keys help "['<Super>F1']"
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys search "['<Super>p']"

# Som e Mídia (Utilizando os keycodes do Teclado Numérico - KP)
gsettings set org.gnome.settings-daemon.plugins.media-keys mic-mute "['<Super>KP_Divide']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Super>KP_Multiply']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Super>KP_Add']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Super>KP_Subtract']"


# ==============================================================================
# 2. ATALHOS PERSONALIZADOS (CUSTOM KEYBINDINGS)
# ==============================================================================

# Definição dos perfis [Nome do Atalho, Comando Executável, Combinação de Teclas]
# Nota: Altere o comando do 'Browser' ou do 'Terminal' caso utilize binários específicos.
custom_bindings=(
    # "Browser:xdg-open about:blank:<Super>b"
    "Emote:emote:<Shift><Super>e"
    "Flameshot:flameshot gui:<Super>Print"
    "GEdit:gedit:<Super>t"
    "Kate:kate:<Super>k"
    # "Nautilus:nautilus:<Super>e"
    # "VSCode:code:<Ctrl><Super>v"
	"VSCodium:codium --new-window --locale pt-BR:<Ctrl><Super>v"
    # "gnome-calculator:gnome-calculator:<Super>c"
    "gnome-calendar:gnome-calendar:<Alt><Super>c"
	"gnome-system-monitor:gnome-system-monitor --show-resources-tab:<Ctrl><Super>M"
    "Terminal:kgx:<Ctrl><Super>t"
)

# Inicializa a lista de caminhos para o gsettings
bindings_list=""

# Loop para registrar cada atalho personalizado no dconf de forma iterativa
for i in "${!custom_bindings[@]}"; do
    IFS=":" read -r name command binding <<< "${custom_bindings[$i]}"
    path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${i}/"
    
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" name "$name"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" command "$command"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$path" binding "$binding"
    
    bindings_list="${bindings_list}'${path}', "
done

# Remove a última vírgula e atualiza a lista global de caminhos ativos
bindings_list="[${bindings_list%, }]"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "$bindings_list"
}

gsettings_set &>/dev/null
}
gnome_keyboard_guard() {
	# 1) Verifica se o GNOME está instalado (procura pelo gnome-shell)
	command -v gnome-shell &>/dev/null || return 0

	# 2) Verifica se a sessão logada atual é do GNOME
	# shellcheck disable=SC2034
	local session="${XDG_CURRENT_DESKTOP:-}${DESKTOP_SESSION:-}"
	[[ "${XDG_CURRENT_DESKTOP,,}" == *gnome* ]] || [[ "${DESKTOP_SESSION,,}" == *gnome* ]] || return 0

	# 3) Verifica se o comando gnome-extensions existe
	command -v gnome-extensions &>/dev/null || return 0

	# 4) Verifica se o comando gsettings existe
	command -v gsettings &>/dev/null || return 0

	# 5) Verifica se o comando curl existe
	command -v dconf &>/dev/null || return 0

	# 6) Tudo OK, executa a função principal
	gnome_shell_keyboard
}
gnome_keyboard_guard &>/dev/null
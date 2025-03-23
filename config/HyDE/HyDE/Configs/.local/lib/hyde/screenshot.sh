#!/usr/bin/env bash

# shellcheck source=$HOME/.local/bin/hyde-shell
# shellcheck disable=SC1091

# Configuração do arquivo keybindings
# $d=[$ut|Screen Capture]
# bindd = $mainMod Shift, P, $d color picker, exec, hyprpicker -an # Pick color (Hex) >> clipboard#
# bindd = $mainMod, P, $d snip screen , exec, $scrPath/screenshot.sh s # partial screenshot capture
# bindd = $mainMod Control, P, $d freeze and snip screen, exec, $scrPath/screenshot.sh sf # partial screenshot capture (frozen screen)
# binddl = $mainMod Alt, P, $d print monitor , exec, $scrPath/screenshot.sh m # monitor screenshot capture
# binddl = , Print, $d print all monitors , exec, $scrPath/screenshot.sh p # all monitors screenshot capture

# Dependências:
# xdg-user-dirs, comando xdg-user-dir
# swappy
# satty

# Lista de comandos a serem verificados
comandos=("xdg-user-dir" "swappy" "satty")

for cmd in "${comandos[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Erro: o comando '$cmd' não foi encontrado."
        exit 1
    fi
done

# if ! source "$(which hyde-shell)"; then
#         echo "[wallbash] code :: Error: hyde-shell not found."
#         echo "[wallbash] code :: Is HyDE installed?"
#         exit 1
# fi

USAGE() {
        cat <<"USAGE"

        Usage: $(basename "$0") [option]
        Options:
                p     Print all outputs
                s     Select area or window to screenshot
                sf    Select area or window with frozen screen
                m     Screenshot focused monitor

USAGE
}

SCREENSHOT_POST_COMMAND+=(
)

SCREENSHOT_PRE_COMMAND+=(
)

pre_cmd() {
        for cmd in "${SCREENSHOT_PRE_COMMAND[@]}"; do
                eval "$cmd"
        done
        trap 'post_cmd' EXIT
}

post_cmd() {
        for cmd in "${SCREENSHOT_POST_COMMAND[@]}"; do
                eval "$cmd"
        done
}

if [ -z "$XDG_PICTURES_DIR" ]; then
        XDG_PICTURES_DIR="$(xdg-user-dir PICTURES)"
fi

confDir="$(xdg-user-dir HOME)"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"
annotation_tool=${SCREENSHOT_ANNOTATION_TOOL}
annotation_args=("-o" "${save_dir}/${save_file}" "-f" "${temp_screenshot}")
if [[ -z "$annotation_tool" ]]; then
        pkg_installed "swappy" && annotation_tool="swappy"
        pkg_installed "satty" && annotation_tool="satty"
fi
mkdir -p "$save_dir"

# Fixes the issue where the annotation tool doesn't save the file in the correct directory
if [[ "$annotation_tool" == "swappy" ]]; then
        swpy_dir="${confDir}/swappy"
        mkdir -p "$swpy_dir"
        echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" >"${swpy_dir}"/config
fi

if [[ "$annotation_tool" == "satty" ]]; then
        annotation_args+=("--copy-command" "wl-copy")
fi

annotation_args+=("${SCREENSHOT_ANNOTATION_ARGS[@]}")
evaluated_annotation_args=$(eval echo "${annotation_args[@]}")

pre_cmd

case $1 in
p) # print all outputs
        # timeout 0.2 slurp # capture animation lol
        # shellcheck disable=SC2086
        "$LIB_DIR/hyde/grimblast" copysave screen $temp_screenshot && "${annotation_tool}" ${evaluated_annotation_args} # intended globbing
        ;;
s) # drag to manually snip an area / click on a window to print it
        # shellcheck disable=SC2086
        "$LIB_DIR/hyde/grimblast" copysave area $temp_screenshot && "${annotation_tool}" ${evaluated_annotation_args} ;; # intended globbing
sf)                                                                                                               # frozen screen, drag to manually snip an area / click on a window to print it
        # shellcheck disable=SC2086
        "$LIB_DIR/hyde/grimblast" --freeze --cursor copysave area $temp_screenshot && "${annotation_tool}" ${evaluated_annotation_args} ;; # intended globbing
m)                                                                                                                                  # print focused monitor
        # timeout 0.2 slurp                                                                                                                  # capture animation lol
        # shellcheck disable=SC2086
        "$LIB_DIR/hyde/grimblast" copysave output $temp_screenshot && "${annotation_tool}" ${evaluated_annotation_args} # intended globbing
        ;;
*) # invalid option
        USAGE ;;
esac

[ -f "$temp_screenshot" ] && rm "$temp_screenshot"

if [ -f "${save_dir}/${save_file}" ]; then
        notify-send -a "Screenshot Alert" -i "${save_dir}/${save_file}" "saved in ${save_dir}"
fi

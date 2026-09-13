#!/usr/bin/env bash
#
# gnome-backup.sh - Tool to backup and restore complete GNOME configurations
#

set -euo pipefail

# Visual/Formatting setup
# Definindo as variáveis com a sintaxe ANSI-C do Bash
readonly BOLD=$'\033[1m'
readonly RED=$'\033[31m'
readonly GREEN=$'\033[32m'
readonly YELLOW=$'\033[33m'
readonly BLUE=$'\033[34m'
readonly RESET=$'\033[0m'

# Default directories and file paths
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DEFAULT_BACKUP_DIR="${HOME}/gnome-backup-${TIMESTAMP}"

log_info()    { printf "%s[INFO]%s %s\n" "${BLUE}" "${RESET}" "$1"; }
log_success() { printf "%s[OK]%s %s\n"   "${GREEN}" "${RESET}" "$1"; }
log_warn()    { printf "%s[WARN]%s %s\n" "${YELLOW}" "${RESET}" "$1"; }
log_error()   { printf "%s[ERROR]%s %s\n" "${RED}" "${RESET}" "$1"; }

show_help() {
	cat <<EOF
${BOLD}USAGE:${RESET}
    $(basename "$0") [COMMAND] [OPTIONS]

${BOLD}DESCRIPTION:${RESET}
    Full backup and restore utility for GNOME environments.
    Handles dconf database, user extensions, GTK configs, themes, icons, and dnf/apt/pacman extension lists.

${BOLD}COMMANDS:${RESET}
    export, -e, --export    Dumps GNOME configuration and user assets to a targeted directory or tarball.
    import, -i, --import    Restores GNOME configuration and assets from a backup source.
    help, -h, --help        Displays this help message.

${BOLD}OPTIONS:${RESET}
    -path, --path PATH      Path to target directory or archive file.
                            (Default for export: ~/gnome-backup-YYYYMMDD_HHMMSS.tar.gz)
    --no-compress           Export to directory directly without creating a .tar.gz archive.

${BOLD}EXAMPLES:${RESET}
    # Export full environment to a timestamped tarball
    ./$(basename "$0") export

    # Export to a custom path without compression
    ./$(basename "$0") export --path /tmp/my-gnome-config --no-compress

    # Import from a tarball archive
    ./$(basename "$0") import --path ~/gnome-backup-20260913_120000.tar.gz

    # Import from an extracted directory
    ./$(basename "$0") import --path /tmp/my-gnome-config
EOF
}

check_dependencies() {
	local deps=("dconf" "tar")
	for cmd in "${deps[@]}"; do
		if ! command -v "$cmd" &>/dev/null; then
			log_error "Required dependency direct binary '$cmd' not found in PATH."
			exit 1
		fi
	done
}

export_gnome() {
	local target_path="$1"
	local compress="$2"
	local work_dir="$target_path"

	if [[ "$compress" == "true" ]]; then
		work_dir=$(mktemp -d -t gnome-backup-XXXXXX)
		trap 'rm -rf "$work_dir"' EXIT
	fi

	log_info "Creating target directory structure at: $work_dir"
	mkdir -p "$work_dir"/{dconf,extensions,themes,icons,gtk}

	log_info "Dumping dconf /org/gnome/ tree..."
	dconf dump /org/gnome/ >"$work_dir/dconf/org-gnome.dconf"

	log_info "Saving enabled extension IDs..."
	if command -v gnome-extensions &>/dev/null; then
		gnome-extensions list --enabled >"$work_dir/extensions/enabled-extensions.txt" || true
		gnome-extensions list >"$work_dir/extensions/all-installed-extensions.txt" || true
	fi

	log_info "Copying user extensions, themes, icons, and GTK assets..."
	[[ -d "$HOME/.local/share/gnome-shell/extensions" ]] && cp -r "$HOME/.local/share/gnome-shell/extensions/"* "$work_dir/extensions/" 2>/dev/null || true
	[[ -d "$HOME/.local/share/themes" ]] && cp -r "$HOME/.local/share/themes/"* "$work_dir/themes/" 2>/dev/null || true
	[[ -d "$HOME/.local/share/icons" ]] && cp -r "$HOME/.local/share/icons/"* "$work_dir/icons/" 2>/dev/null || true
	[[ -d "$HOME/.config/gtk-3.0" ]] && cp -r "$HOME/.config/gtk-3.0" "$work_dir/gtk/" 2>/dev/null || true
	[[ -d "$HOME/.config/gtk-4.0" ]] && cp -r "$HOME/.config/gtk-4.0" "$work_dir/gtk/" 2>/dev/null || true

	if [[ "$compress" == "true" ]]; then
		log_info "Compressing backup into: $target_path"
		mkdir -p "$(dirname "$target_path")"
		tar -czf "$target_path" -C "$work_dir" .
		log_success "Export complete: $target_path"
	else
		log_success "Export complete (uncompressed): $work_dir"
	fi
}

import_gnome() {
	local source_path="$1"
	local work_dir="$source_path"
	local temp_created=false

	if [[ ! -e "$source_path" ]]; then
		log_error "Source path '$source_path' does not exist."
		exit 1
	fi

	if [[ -f "$source_path" && "$source_path" =~ \.tar\.gz$ ]]; then
		log_info "Extracting archive to temporary workspace..."
		work_dir=$(mktemp -d -t gnome-restore-XXXXXX)
		temp_created=true
		tar -xzf "$source_path" -C "$work_dir"
	fi

	if [[ $temp_created == true ]]; then
		trap 'rm -rf "$work_dir"' EXIT
	fi

	log_info "Restoring assets (extensions, themes, icons, GTK)..."
	mkdir -p "$HOME/.local/share/gnome-shell/extensions" \
		"$HOME/.local/share/themes" \
		"$HOME/.local/share/icons" \
		"$HOME/.config/gtk-3.0" \
		"$HOME/.config/gtk-4.0"

	[[ -d "$work_dir/extensions" ]] && cp -r "$work_dir/extensions/"* "$HOME/.local/share/gnome-shell/extensions/" 2>/dev/null || true
	[[ -d "$work_dir/themes" ]] && cp -r "$work_dir/themes/"* "$HOME/.local/share/themes/" 2>/dev/null || true
	[[ -d "$work_dir/icons" ]] && cp -r "$work_dir/icons/"* "$HOME/.local/share/icons/" 2>/dev/null || true
	[[ -d "$work_dir/gtk/gtk-3.0" ]] && cp -r "$work_dir/gtk/gtk-3.0/"* "$HOME/.config/gtk-3.0/" 2>/dev/null || true
	[[ -d "$work_dir/gtk/gtk-4.0" ]] && cp -r "$work_dir/gtk/gtk-4.0/"* "$HOME/.config/gtk-4.0/" 2>/dev/null || true

	if [[ -f "$work_dir/dconf/org-gnome.dconf" ]]; then
		log_info "Loading dconf registry entries into /org/gnome/..."
		dconf load /org/gnome/ <"$work_dir/dconf/org-gnome.dconf"
	else
		log_warn "No dconf dump file found at $work_dir/dconf/org-gnome.dconf"
	fi

	log_info "Attempting shell interface refresh..."
	if [[ "${XDG_SESSION_TYPE:-}" == "x11" ]]; then
		busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'meta_restart()' &>/dev/null || true
		log_success "GNOME Shell restarted (X11)."
	else
		log_warn "Wayland session detected. Re-login or restart the system for all extension binaries and dconf keys to apply fully."
	fi

	log_success "Import complete."
}

main() {
	check_dependencies

	if [[ $# -eq 0 ]]; then
		show_help
		exit 0
	fi

	local action=""
	local custom_path=""
	local compress=true

	while [[ $# -gt 0 ]]; do
		case "$1" in
		export | -e | --export)
			action="export"
			shift
			;;
		import | -i | --import)
			action="import"
			shift
			;;
		help | -h | --help)
			show_help
			exit 0
			;;
		--path | -path)
			custom_path="$2"
			shift 2
			;;
		--no-compress)
			compress=false
			shift
			;;
		*)
			log_error "Unknown argument: $1"
			show_help
			exit 1
			;;
		esac
	done

	case "$action" in
	export)
		if [[ -z "$custom_path" ]]; then
			if [[ "$compress" == "true" ]]; then
				custom_path="${DEFAULT_BACKUP_DIR}.tar.gz"
			else
				custom_path="${DEFAULT_BACKUP_DIR}"
			fi
		fi
		export_gnome "$custom_path" "$compress"
		;;
	import)
		if [[ -z "$custom_path" ]]; then
			log_error "Import requires specifying a source file/directory using --path <PATH>"
			exit 1
		fi
		import_gnome "$custom_path"
		;;
	*)
		log_error "No valid action specified (use export or import)."
		show_help
		exit 1
		;;
	esac
}

main "$@"

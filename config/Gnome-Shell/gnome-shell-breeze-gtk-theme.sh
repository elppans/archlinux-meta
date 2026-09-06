#!/usr/bin/env bash

set -euo pipefail

# Cores para saída no terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Modo padrão: "dark" ou "light"
MODE="${1:-dark}"

if [[ "$MODE" == "dark" ]]; then
    THEME_NAME="Breeze-Dark"
    ICON_NAME="breeze-dark"
    COLOR_SCHEME="prefer-dark"
else
    THEME_NAME="Breeze"
    ICON_NAME="breeze"
    COLOR_SCHEME="default"
fi

CURSOR_NAME="breeze_cursors"

log_info "Iniciando configuração do tema GTK/Libadwaita ($THEME_NAME)..."

# 1. Instalação das dependências
PKGS=(
    breeze-gtk
    breeze-icons
    gsettings-desktop-schemas
    dconf
)

MISSING_PKGS=()
for pkg in "${PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    log_info "Instalando pacotes necessários via pacman: ${MISSING_PKGS[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
else
    log_success "Todos os pacotes necessários já estão instalados."
fi

# 2. Configuração do GTK 3.0
log_info "Configurando ~/.config/gtk-3.0/settings.ini..."
mkdir -p ~/.config/gtk-3.0

cat <<EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=$THEME_NAME
gtk-icon-theme-name=$ICON_NAME
gtk-cursor-theme-name=$CURSOR_NAME
gtk-font-name=Noto Sans 10
gtk-application-prefer-dark-theme=$([ "$MODE" == "dark" ] && echo "1" || echo "0")
EOF

# 3. Vincular arquivos do Breeze no GTK 4.0 / Libadwaita
log_info "Aplicando overrides no GTK 4.0 (Libadwaita)..."
GTK4_DIR="$HOME/.config/gtk-4.0"
SYSTEM_THEME_DIR="/usr/share/themes/$THEME_NAME/gtk-4.0"

mkdir -p "$GTK4_DIR"

if [ -d "$SYSTEM_THEME_DIR" ]; then
    # Remove symlinks ou arquivos antigos para evitar conflitos
    rm -rf "$GTK4_DIR/gtk.css" "$GTK4_DIR/gtk-dark.css" "$GTK4_DIR/assets"
    
    # Cria symlinks apontando diretamente para as folhas de estilo do Breeze
    ln -sf "$SYSTEM_THEME_DIR/gtk.css" "$GTK4_DIR/gtk.css"
    ln -sf "$SYSTEM_THEME_DIR/gtk-dark.css" "$GTK4_DIR/gtk-dark.css"
    
    if [ -d "$SYSTEM_THEME_DIR/assets" ]; then
        ln -sf "$SYSTEM_THEME_DIR/assets" "$GTK4_DIR/assets"
    fi
    
    log_success "Symlinks do GTK 4.0 vinculados ao $THEME_NAME."
else
    log_warn "Diretório $SYSTEM_THEME_DIR não encontrado. O override do GTK4 pode não funcionar corretamente."
fi

# 4. Atualizar chaves GSettings / Dconf
log_info "Definindo preferências globais do XDG / GNOME via gsettings..."

gsettings set org.gnome.desktop.interface gtk-theme "$THEME_NAME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme "$ICON_NAME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_NAME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME" 2>/dev/null || true

# 5. Overrides para Flatpak (se o Flatpak estiver instalado)
if command -v flatpak &>/dev/null; then
    log_info "Aplicando permissões de tema para Flatpaks..."
    flatpak override --user --filesystem=/usr/share/themes:ro
    flatpak override --user --filesystem=/usr/share/icons:ro
    flatpak override --user --env=GTK_THEME="$THEME_NAME"
    log_success "Flatpaks configurados."
fi

log_success "Tema $THEME_NAME aplicado com sucesso em apps GTK3, GTK4 e Libadwaita!"
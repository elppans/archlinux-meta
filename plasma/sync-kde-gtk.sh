#!/usr/bin/env bash

set -euo pipefail

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 1. Instalação de dependências no Arch Linux
log_info "Verificando e instalando pacotes de integração..."
REQUIRED_PKGS=(
    kde-gtk-config
    breeze-gtk
    xdg-desktop-portal
    xdg-desktop-portal-kde
    xdg-desktop-portal-gtk
    adw-gtk-theme
)

MISSING_PKGS=()
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    log_info "Instalando pacotes ausentes via pacman: ${MISSING_PKGS[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
else
    log_success "Todas as dependências do pacman já estão instaladas."
fi

# 2. Configuração de arquivos de tema GTK3 e GTK4 do usuário
log_info "Configurando arquivos de tema em ~/.config..."

mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

# Define Breeze-Dark por padrão (altere para 'Breeze' se usar modo claro)
GTK_THEME_NAME="Breeze-Dark"

# GTK 3.0 settings.ini
cat <<EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=$GTK_THEME_NAME
gtk-icon-theme-name=breeze-dark
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=breeze_cursors
gtk-application-prefer-dark-theme=1
EOF

# GTK 4.0 settings.ini
cat <<EOF > ~/.config/gtk-4.0/settings.ini
[Settings]
gtk-theme-name=$GTK_THEME_NAME
gtk-icon-theme-name=breeze-dark
gtk-font-name=Noto Sans 10
gtk-cursor-theme-name=breeze_cursors
gtk-application-prefer-dark-theme=1
EOF

log_success "Configurações GTK3 e GTK4 gravadas."

# 3. Aplicar esquema de cores escuro via xdg-desktop-portal (Libadwaita / FreeDesktop)
log_info "Definindo a preferência de sistema para escuro (org.freedesktop.appearance.color-scheme)..."
dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'" 2>/dev/null || true
dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME_NAME'" 2>/dev/null || true

# 4. Configuração de Flatpaks (se instalado)
if command -v flatpak &>/dev/null; then
    log_info "Flatpak detectado. Aplicando overrides de arquivos de sistema e temas..."
    
    # Permissão para ler temas globais do SO
    flatpak override --user --filesystem=/usr/share/themes:ro
    flatpak override --user --filesystem=/usr/share/icons:ro
    flatpak override --user --filesystem="$HOME"/.themes:ro
    
    # Variável de ambiente para o Flatpak respeitar o tema
    flatpak override --user --env=GTK_THEME=$GTK_THEME_NAME
    
    # Instalação do tema Breeze GTK para Flatpaks (runtime)
    log_info "Garantindo suporte ao tema Breeze nos runtimes Flatpak..."
    flatpak install -y flathub org.gtk.Gtk3theme.Breeze-dark 2>/dev/null || true
    
    log_success "Configurações de Flatpak concluídas."
fi

# 5. Reiniciar Portais XDG para aplicar as mudanças
log_info "Reiniciando serviços do xdg-desktop-portal..."
systemctl --user restart xdg-desktop-portal-kde xdg-desktop-portal-gtk xdg-desktop-portal 2>/dev/null || true

log_success "Sincronização do tema GTK com o Plasma finalizada com sucesso!"
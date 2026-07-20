#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="/etc/skel/.local/share/desktop-directories"
HOME_DIR="$HOME/.local/share/desktop-directories"

export TARGET_DIR
export HOME_DIR

sudo mkdir -p "$TARGET_DIR"

declare -A DIRECTORIES=(
    ["AudioVideo.directory"]="Áudio e Vídeo|Audio & Video|applications-multimedia"
    ["Development.directory"]="Desenvolvimento|Development|applications-development"
    ["Education.directory"]="Educação|Education|applications-science"
    ["Game.directory"]="Jogos|Games|applications-games"
    ["Graphics.directory"]="Gráficos|Graphics|applications-graphics"
    ["Network.directory"]="Internet|Internet|applications-internet"
    ["Office.directory"]="Escritório|Office|applications-office"
    ["System-Tools.directory"]="Ferramentas do Sistema|System Tools|applications-system"
    ["Utility-Accessibility.directory"]="Acessibilidade|Accessibility|preferences-desktop-accessibility"
    ["Utility.directory"]="Utilitários|Utilities|applications-utilities"
    ["X-GNOME-Menu-Applications.directory"]="Aplicações|Applications|applications-other"
    ["X-GNOME-Other.directory"]="Outros|Other|applications-other"
    ["X-GNOME-Shell-System.directory"]="Sistema|System|emblem-system"
    ["X-GNOME-Shell-Utilities.directory"]="Utilitários|Utilities|applications-utilities"
    ["X-GNOME-Sundry.directory"]="Diversos|Sundry|applications-other"
    ["X-GNOME-SystemSettings.directory"]="Configurações|Settings|preferences-system"
    ["X-GNOME-Utilities.directory"]="Utilitários|Utilities|applications-utilities"
    ["X-GNOME-WebApplications.directory"]="Aplicativos Web|Web Applications|applications-internet"
)

echo "Criando arquivos .directory em: $TARGET_DIR"

for FILE in "${!DIRECTORIES[@]}"; do
    IFS="|" read -r NAME_PT NAME_EN ICON <<< "${DIRECTORIES[$FILE]}"
    
    FILE_PATH="$TARGET_DIR/$FILE"
    
echo -e "[Desktop Entry]
Type=Directory
Name=$NAME_PT
Name[en]=$NAME_EN
Icon=$ICON" | sudo tee "$FILE_PATH" &>>/dev/null


    echo " + Criado: $FILE"
done

echo "Sincronizando arquivos .directory em: $HOME_DIR"
rsync -ah /etc/skel/ "$HOME/"

echo "Atualizando o cache do ambiente gráfico..."

if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME_DIR"
fi

echo "Faça logoff/login para o GNOME Shell recarregar os metadados."

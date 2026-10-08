#!/bin/bash

COLOR_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme | tr -d "'")

# Atualização dos arquivos ini (GTK3 e compatibilidade GTK4)
update_gtk_dark_ini() {
    local file="$1"
    local key="gtk-application-prefer-dark-theme"
    local val="true"

    mkdir -p "$(dirname "$file")"
    
    if [ ! -f "$file" ]; then
        echo -e "[Settings]\n${key}=${val}" > "$file"
        return
    fi

    if grep -q "^\[Settings\]" "$file"; then
        if grep -q "^${key}=" "$file"; then
            sed -i "s/^${key}=.*/${key}=${val}/" "$file"
        else
            sed -i "/^\[Settings\]/a ${key}=${val}" "$file"
        fi
    else
        echo -e "\n[Settings]\n${key}=${val}" >> "$file"
    fi
}
update_gtk_light_ini() {
    local file="$1"
    local key="gtk-application-prefer-dark-theme"
    local val="false"

    mkdir -p "$(dirname "$file")"
    
    if [ ! -f "$file" ]; then
        echo -e "[Settings]\n${key}=${val}" > "$file"
        return
    fi

    if grep -q "^\[Settings\]" "$file"; then
        if grep -q "^${key}=" "$file"; then
            sed -i "s/^${key}=.*/${key}=${val}/" "$file"
        else
            sed -i "/^\[Settings\]/a ${key}=${val}" "$file"
        fi
    else
        echo -e "\n[Settings]\n${key}=${val}" >> "$file"
    fi
}

if [ "$COLOR_SCHEME" = "prefer-dark" ]; then
	update_gtk_dark_ini "$HOME/.config/gtk-3.0/settings.ini"
	update_gtk_dark_ini "$HOME/.config/gtk-4.0/settings.ini"
else
	update_gtk_light_ini "$HOME/.config/gtk-3.0/settings.ini"
	update_gtk_light_ini "$HOME/.config/gtk-4.0/settings.ini"
fi



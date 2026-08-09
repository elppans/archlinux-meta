#!/usr/bin/env bash

GNOMESHELLCMD="$0"
GNOMESHELLDIR="$(dirname "$GNOMESHELLCMD")"
export GNOMESHELLDIR

# ==========================================
# Temas nativos em aplicativos de terceiros:
# ==========================================

# sudo pacman -Sy --needed kvantum qt5ct qt6ct gsettings-qt5 gsettings-qt6 adw-gtk-theme xdg-desktop-portal-gnome xdg-desktop-portal gnome-themes-extra
# yay -Sy --needed kvantum-theme-libadwaita-git
# Ps.: Adicionado pacotes na Sessão "pacotes/pacman.list"

# gsettings set org.gnome.desktop.interface gtk-theme 'adwaita' # 'adw-gtk3-dark'
# gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' # 'prefer-light' 'default'
# Ps.: Adicionado parâmetros na Sessão "config/Gnome-Shell/gnome-shell-set.sh"

# KVantum
if command -v kvantummanager &>/dev/null; then
	grep -q 'QT_STYLE_OVERRIDE=kvantum' /etc/environment || echo -e 'QT_STYLE_OVERRIDE=kvantum' | sudo tee -a /etc/environment

	# if [ -f "$GNOMESHELLDIR/gnome-shell-themes-kvantum.sh" ]; then
	# 	"$GNOMESHELLDIR/gnome-shell-themes-kvantum.sh"
	# else
	# 	echo "Arquivo gnome-shell-themes-kvantum.sh não encontrado!"
	# 	exit 1
	# fi

	# flatpak install flathub org.kde.KStyle.Kvantum//5.15
	# flatpak install flathub org.kde.KStyle.Kvantum//6.10
	flatpak override --user --filesystem=xdg-config/Kvantum:ro
	flatpak override --user --env=QT_STYLE_OVERRIDE=kvantum

	# Fazer o Flatpak enxergar os temas globais do sistema
	# flatpak override --user --filesystem=/usr/share/Kvantum:ro

	# Bloquear a configuração do Flatpak para enxergar os temas globais do sistema
	# flatpak override --user --nofilesystem=/usr/share/Kvantum

	# Remover a configuração do Flatpak para enxergar os temas globais do sistema
	# Ao rodar este comando, deve configurar novamente as variáveis e acesso do Flatpak
	# flatpak override --user --reset --filesystem=/usr/share/Kvantum

	# Tema atual do KVantum no sistema
	KVTHEME="$(sed -n 's/^theme=\(.*\)/\1/p' "$HOME"/.config/Kvantum/kvantum.kvconfig)"
	echo "$KVTHEME"

	# Forçar o tema via variável de ambiente global no Flatpak
	flatpak override --user --env=KVANTUM_THEME="$KVTHEME"

	# Auditar configurão do KVantum em Flatpak de dentro do sandbox
	# flatpak run --command=cat org.kde.gwenview "$HOME"/.config/Kvantum/kvantum.kvconfig | grep -i '^theme='

	# Auditar configurão do KVantum em Flatpak da variável de ambiente
	# flatpak run --command=env org.kde.gwenview | grep -E 'QT_|KVANTUM_'

	# Diretórios de temas KVantum
	# ls /usr/share/Kvantum

	# Comando para testar se o Flatpak enxerga o diretório KVantum Global
	# flatpak run --command=ls org.kde.gwenview /usr/share/Kvantum

	# Cria o diretorio para o tema KvLibadwaita no espaço do usuário
	mkdir -p "$HOME"/.config/Kvantum/KvLibadwaita

	if [ -d "/usr/share/Kvantum/KvLibadwaita" ]; then
		# Copia os arquivos de definição do tema KvLibadwaita do host para o novo diretorio
		sudo curl -fsSL "https://raw.githubusercontent.com/elppans/KvLibadwaita/refs/heads/main/src/KvLibadwaita/KvLibadwaitaDark.svg" -o "/usr/share/Kvantum/KvLibadwaita/KvLibadwaitaDark.svg"
		sudo curl -fsSL "https://raw.githubusercontent.com/elppans/KvLibadwaita/refs/heads/main/src/KvLibadwaita/KvLibadwaita.svg" -o "/usr/share/Kvantum/KvLibadwaita/KvLibadwaita.svg"
		rsync -ah /usr/share/Kvantum/KvLibadwaita/ "$HOME"/.config/Kvantum/KvLibadwaita/
	fi

# Teste do Flatpak para listar o conteúdo do diretorio local mapeada dentro do sandbox
# flatpak run --command=ls org.kde.gwenview "$HOME"/.config/Kvantum/KvLibadwaita
fi

# qt5ct/qt6ct
if pacman -Qs '^(qt5ct|qt6ct)$' &>/dev/null; then
	grep -q 'QT_QPA_PLATFORMTHEME=qt5ct' /etc/environment || echo -e 'QT_QPA_PLATFORMTHEME=qt5ct' | sudo tee -a /etc/environment
	# Fornecer acesso aos arquivos de configuração do Kvantum/Qt5ct
	flatpak override --user --filesystem=xdg-config/qt5ct:ro
	flatpak override --user --filesystem=xdg-config/qt6ct:ro

	# Forçar as Variáveis de Ambiente Globais para o Flatpak
	flatpak override --user --env=QT_QPA_PLATFORMTHEME=qt5ct
fi

# xdg-desktop-portal-gnome xdg-desktop-portal
if pacman -Qs '^(xdg-desktop-portal|xdg-desktop-portal-gnome)$' &>/dev/null; then
	grep -q 'QT_QPA_PLATFORM="wayland;xcb"' /etc/environment || echo -e 'QT_QPA_PLATFORM="wayland;xcb"' | sudo tee -a /etc/environment
	# Permite que os Flatpaks herdem as configurações de fontes e ícones do sistema
	flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
	flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi

# Verificação tecnica do environment via Flatpak
# flatpak override --user --show

# if [ -f "$GNOMESHELLDIR/gnome-shell-themes-flatpak.sh" ]; then
# 	sudo cp -a "$GNOMESHELLDIR/gnome-shell-themes-flatpak.sh" /etc/profile.d/
# 	sudo chmod +x /etc/profile.d/gnome-shell-themes-flatpak.sh
# else
# 	echo "Arquivo gnome-shell-themes-flatpak.sh não encontrado!"
# 	exit 1
# fi

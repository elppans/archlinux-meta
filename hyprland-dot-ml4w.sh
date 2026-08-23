#!/bin/bash
# shellcheck disable=SC2329,SC2016,SC2317,SC2027,SC2046

# https://www.ml4w.com/
# https://ml4w.com/os/
# https://github.com/mylinuxforwork/dotfiles/wiki
# https://github.com/mylinuxforwork/dotfiles?tab=readme-ov-file
# https://github.com/mylinuxforwork/dotfiles/wiki/Installation
# https://github.com/mylinuxforwork/dotfiles/wiki/Troubleshooting
# https://github.com/mylinuxforwork/dotfiles/wiki/Monitor-Configuration
# https://wiki.hypr.land/Configuring/Monitors/
# https://wiki.hypr.land/Configuring/Keywords/

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
	echo "Erro: Este script não deve ser executado como superusuário (root)."
	echo "Por favor, execute como um usuário normal."
	echo "Quando necessário, será pedido a senha administrativa!"
	exit 1
fi

# LOG
COMMAND="$0"
BASECMD="$(basename "$COMMAND")"
LOGDIR="$HOME/.$BASECMD"
mkdir -p "$LOGDIR"

LOGFILE="$LOGDIR/$BASECMD.log"
LOGFILEERROR="$LOGDIR/${BASECMD}_error.log"

# separador + timestamp de início, útil pra achar cada execução no log
{
	printf '\n==== %s | PID %s | %s ====\n' "$(date '+%F %T')" "$$" "$COMMAND"
} | tee -a "$LOGFILE" "$LOGFILEERROR" >/dev/null

# stdout COM timestamp por linha
# exec 1> >(stdbuf -oL awk '{ print strftime("%F %T"), $0; fflush() }' | tee -a "$LOGFILE")
# stderr COM timestamp por linha (grava nos dois arquivos e continua mostrando na tela)
# exec 2> >(stdbuf -oL awk '{ print strftime("%F %T"), $0; fflush() }' | tee -a "$LOGFILEERROR" | tee -a "$LOGFILE" >&2)

# stdout SEM timestamp
exec 1> >(stdbuf -oL tee -a "$LOGFILE")
# stderr SEM timestamp (grava nos dois arquivos e continua mostrando na tela)
exec 2> >(stdbuf -oL tee -a "$LOGFILEERROR" | tee -a "$LOGFILE" >&2)

# garante que os subprocessos do tee/awk terminem de escrever antes do script sair
trap 'wait' EXIT
# LOG

locdir="$(pwd)"
install="$locdir"
export install

detectar_vm() {
	# Verificar se a máquina é virtual e instalar pacotes se necessário
	echo "Verificando se o Host é real ou virtual..."
	sleep 5
	if [ -d "$install"/pacotes ]; then
		cd "$install"/pacotes/ || exit 1
		./detect-vm.sh
		cd "$install" || exit 1
	else
		bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/pacotes/detect-vm.sh')
	fi
}
verificar_repositorios() {
	# Verificar repositórios
	echo "Verificando repositórios existentes..."
	sleep 5
	if [ -d "$install"/helper ]; then
		cd "$install"/helper/ || exit 1
		./multilib-check.sh                                # Repositório MULTILIB
		pacman -Qqs chaotic-mirrorlist || ./chaotic-aur.sh # Repositório CHAOTIC-AUR
		cd "$install" || exit 1
	else
		bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/helper/multilib-check.sh')
		pacman -Qqs chaotic-mirrorlist || bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/helper/chaotic-aur.sh')
	fi
}
verificar_kernel_hooks() {
	if ! pacman -Qq kernel-modules-hook &>/dev/null; then
		# Sincroniza a base de dados E atualiza o sistema para evitar parcial upgrade
		sudo pacman -Syu --needed --noconfirm kernel-modules-hook

		# Ativa e inicia o serviço para limpar módulos antigos
		# liberando espaço e evitando possíveis conflitos com módulos desnecessários.
		sudo systemctl enable --now linux-modules-cleanup.service
	fi
}
verificar_helper() {
	# Verificando Helper e instalando, caso necessário
	if [ -d "$install"/helper ]; then
		cd "$install"/helper/ || exit 1
		# shellcheck source=/dev/null
		source helper_install.sh # Wrappers do pacman (AUR Helper)
		cd "$install" || exit 1
	else
		bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/helper/helper_install.sh')
	fi
}
instalar_sddm_silent_theme() {
	# SDDM Customizado, "sddm-silent-theme" (Lembrar de sempre usar "Hyprland UWSM")
	# Mais informações: https://github.com/uiriansan/SilentSDDM
	echo "Instalando tema para SDDM..."
	sleep 5
	# Ativação do Display manager (Gerenciador de Login)
	cd "$install"/display-manager/ || exit 1
	chmod +x display-manager-sddm_silent-theme.sh
	./display-manager-sddm_silent-theme.sh
	cd "$install" || exit 1
}
pacotes_essenciais() {
	# Pacotes essenciais para desenvolvimento (Garantindo que estejam instalados)
	echo "Garantindo que pacotes essenciais estejam instalados..."
	sleep 5
	sudo pacman --needed --noconfirm -S git base-devel
}
pacotes_recomendados() {
	# Utilitários Recomendados (Garantindo que estejam instalados)
	echo "Garantindo que pacotes recomendados estejam instalados..."
	sleep 5
	local recomendados=(
		# hyprutils
		# nwg-displays
		# xdg-user-dirs
		# swappy
		pinta
		hyprshot
		satty
		wl-clipboard
		ttf-font-awesome
		ttf-nerd-fonts-symbols
		noto-fonts-emoji
	)

	if command -v pacman &>/dev/null; then
		sudo pacman --needed --noconfirm -S "${recomendados[@]}"
	elif command -v dnf &>/dev/null; then
		sudo dnf install -y "${recomendados[@]}"
	elif command -v zypper &>/dev/null; then
		sudo zypper install -y "${recomendados[@]}"
	fi
}
ml4w_lista_de_dependências_oficiais() {
	# Baixa a lista de dependências oficiais e armazena em uma variá1vel
	echo "Baixando lista de dependências oficial do github e instalando pacotes..."
	sleep 5
	mapfile -t PACKAGES < <(curl -fsSL https://raw.githubusercontent.com/mylinuxforwork/dotfiles/refs/heads/main/setup/dependencies/packages-arch | sed '/^#/d')
	# Executa o instalador Helper usando o array de forma segura
	"$HELPER" -Sy --needed "${PACKAGES[@]}"
}
ml4w_os_install() {
	echo "Instalando ML4W..."
	sleep 5
	bash <(curl -s https://ml4w.com/os/stable)
}
ml4w_configuracoes_customizadas() {
	# **CUSTOMIZAÇÃO**

	echo "Adicionando configurações customizadas..."
	sleep 5
	cd "$install/config" || exit 1
	./ml4w_config_install.sh
	cd "$install" || exit 1
}
ml4w_dotfiles_install() {
	# **The ML4W Dotfiles for Hyprland**
	echo "Iniciando instalação do ML4W Dotfiles para Hyprland..."
	sleep 5
	# ml4w_lista_de_dependências_oficiais
	ml4w_os_install
	ml4w_configuracoes_customizadas
}
command_hyprland() {
	if [ "$(command -v hyprland)" ]; then
		echo "Hyprland instalado, continuando operação..."
		sleep 5
	else
		echo "Deve instalar a base Hyprland primeiro!"
		exit 1
	fi
}
remover_pacotes() {
	local pacotes=(
		hyprsysteminfo
		hyprsysteminfo-debug
		python-screeninfo
		python-pywalfox
	)

	if command -v pacman &>/dev/null; then
		sudo pacman -Rns --noconfirm "${pacotes[@]}"
	elif command -v dnf &>/dev/null; then
		sudo dnf remove -y "${pacotes[@]}"
	elif command -v zypper &>/dev/null; then
		sudo zypper remove -y "${pacotes[@]}"
	fi
}
if [ "$(command -v pacman)" ]; then
	command_hyprland
	verificar_repositorios
	pacotes_essenciais
	verificar_kernel_hooks
	verificar_helper
	detectar_vm
	pacotes_recomendados
	# instalar_sddm_silent_theme
	ml4w_dotfiles_install
	remover_pacotes
else
	command_hyprland
	ml4w_dotfiles_install
	remover_pacotes
fi
fc-cache -f
cd "$install" || exit 1

echo "Instalação finalizada..."
echo "Reinicie o computador para que as configurações surtam efeito!"
exit 0

# ==============================================================================
# CONFIGURAÇÕES OPCIONAIS — REPOSITÓRIO COMPLETO
# ==============================================================================
# Use esta seção caso o repositório tenha sido baixado/clonado por completo.
#
# Os comandos abaixo estão comentados de propósito. Descomente somente o que
# deseja executar.
# ==============================================================================

# ------------------------------------------------------------------------------
# Ativar o Chaotic AUR
# ------------------------------------------------------------------------------
# Ativa o repositório Chaotic AUR
#
# OBSERVAÇÃO:
# A execução do Script pergunta por padrão se quer ativar o repositório ou não.
# Então não há necessidade de ativar a linha deste Script
#
# ./helper/chaotic-aur_hyde.sh --install


# ------------------------------------------------------------------------------
# Instalar a lista de pacotes Pacman — SEM pacotes GNOME
# ------------------------------------------------------------------------------
# Lê a lista em ./pacotes/pacman.list, ignora comentários, linhas vazias e
# pacotes que começam com "gnome", e instala os pacotes restantes.
#
# IMPORTANTE:
# O pacman não aceita este formato de instalação a partir da entrada padrão.
# Para este tipo de instalação, é necessário utilizar um AUR Helper.
#
# Substitua "$HELPER" por "yay" ou "paru".
#
# Exemplos de Helper:
#   yay
#   paru
#
# ./pacotes/pacman.list
# grep -v -E '^#|^$|^gnome' ./pacotes/pacman.list | awk '{print $1}' | "$HELPER" --needed --noconfirm -S -
# ./pacotes/pacman.ini


# ------------------------------------------------------------------------------
# Instalar a lista de pacotes Flatpak
# ------------------------------------------------------------------------------
# Lê os IDs dos aplicativos no arquivo ./pacotes/flatpak.list e instala cada
# pacote individualmente através do Flatpak.
#
# ./pacotes/flatpak.list
# mapfile -t pacotes < <(sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^$/d' "./pacotes/flatpak.list" | awk '{print $2}') && for pacote in "${pacotes[@]}"; do sudo flatpak install -y --noninteractive "$pacote"; done
# ./pacotes/flatpak.ini


# ------------------------------------------------------------------------------
# Executar Scripts do diretório "custom"
# ------------------------------------------------------------------------------
# Executa todos os scripts .sh que possuem permissão de execução dentro de
# ./custom.
#
# ATENÇÃO:
# O comando abaixo com "chmod -x" remove a permissão de execução do script
# shell-minimalista.sh. Mantenha-o comentado caso não queira alterar essa
# permissão.
#
# chmod -x ./custom/shell-minimalista.sh
# find ./custom -type f -name "*.sh" -executable -exec {} \;


# ------------------------------------------------------------------------------
# Executar Scripts do GNOME — Ícones e Temas
# ------------------------------------------------------------------------------
# Scripts opcionais para configurar temas, ícones e aparência relacionados
# ao GNOME Shell.
#
# ./config/Gnome-Shell/gnome-shell-set.sh
# ./config/Gnome-Shell/gnome-shell-themes-orchis.sh


# ==============================================================================
# CONFIGURAÇÕES OPCIONAIS — LINK DIRETO
# ==============================================================================
# Use esta seção caso você tenha executado o script sem baixar/clonar o
# repositório completo.
#
# Os arquivos são baixados diretamente do GitHub conforme a necessidade,
# portanto não é necessário ter o repositório presente no computador.
#
# Os comandos abaixo estão comentados de propósito. Descomente somente o que
# deseja executar.
# ==============================================================================

# ------------------------------------------------------------------------------
# Ativar o Chaotic AUR
# ------------------------------------------------------------------------------
# Baixa o script diretamente do GitHub, executa a instalação e remove o arquivo
# temporário utilizado durante o processo.
#
# OBSERVAÇÃO:
# A execução do Script pergunta por padrão se quer ativar o repositório ou não.
# Então não há necessidade de ativar a linha deste Script
#
# tmp=$(mktemp) && wget -qO "$tmp" 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/helper/chaotic-aur_hyde.sh' && sudo bash "$tmp" --install; rm -f "$tmp"


# ------------------------------------------------------------------------------
# Instalar a lista de pacotes Pacman — SEM pacotes GNOME
# ------------------------------------------------------------------------------
# Baixa a lista de pacotes diretamente do GitHub, ignora comentários, linhas
# vazias e pacotes que começam com "gnome", e instala os demais pacotes.
#
# IMPORTANTE:
# O pacman não aceita este formato de instalação a partir da entrada padrão.
# É necessário utilizar um AUR Helper.
#
# Neste exemplo, o Helper utilizado é o "yay". Também é possível utilizar
# o "paru" no lugar dele.
#
# Lista de pacotes:
# curl -fsSL 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/pacotes/pacman.list' | grep -v -E '^#|^$|^gnome' | awk '{print $1}' | yay --needed --noconfirm -S -
#
# Configuração adicional:
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/pacotes/pacman.ini')


# ------------------------------------------------------------------------------
# Instalar a lista de pacotes Flatpak
# ------------------------------------------------------------------------------
# Baixa a lista diretamente do GitHub, processa os IDs dos aplicativos e
# instala cada pacote utilizando o Flatpak.
#
# Lista de pacotes:
# mapfile -t pacotes < <(curl -fsSL 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/pacotes/flatpak.list' | sed 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^$/d' | awk '{print $2}') && for pacote in "${pacotes[@]}"; do sudo flatpak install -y --noninteractive "$pacote"; done
#
# Configuração adicional:
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/pacotes/flatpak.ini')


# ------------------------------------------------------------------------------
# Executar Scripts do diretório "custom"
# ------------------------------------------------------------------------------
# Baixa somente o diretório "custom" do repositório para um diretório
# temporário, remove os scripts que não devem ser executados e, em seguida,
# executa todos os scripts .sh restantes que possuem permissão de execução.
#
# O diretório temporário é removido ao final do processo.
#
# tmpdir=$(mktemp -d)
# mkdir -p "$tmpdir/custom"
# curl -sSL https://github.com/elppans/archlinux-meta/archive/refs/heads/main.tar.gz | tar -xz -C "$tmpdir/custom" --strip-components=2 archlinux-meta-main/custom
# rm -f "$tmpdir/custom"/{shell-minimalista.sh,bin.sh}
# find "$tmpdir/custom" -type f -name "*.sh" -executable -exec {} \;
# rm -rf "$tmpdir"


# ------------------------------------------------------------------------------
# Executar Scripts de configuração do GNOME
# ------------------------------------------------------------------------------
# Scripts opcionais para configurar o ambiente GNOME, principalmente para
# utilização do Nautilus e de outros aplicativos baseados no GNOME.
#
# Os scripts são baixados e executados diretamente do GitHub.
#
# Configuração do GNOME:
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/Gnome-Shell/gnome-shell-set.sh')
#
# Tema Orchis (+ kora_icons + bibata-cursor-theme):
# bash <(wget -qO- 'https://raw.githubusercontent.com/elppans/archlinux-meta/refs/heads/main/config/Gnome-Shell/gnome-shell-themes-orchis.sh')
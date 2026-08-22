#!/bin/bash
# shellcheck disable=SC2329,SC2016

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
	cd "$install"/pacotes/ || exit 1
	./detect-vm.sh
	cd "$install" || exit 1
}
verificar_repositorios() {
	# Verificar repositórios
	echo "Verificando repositórios existentes..."
	sleep 5
	# Verificação do repositório MULTILIB
	cd "$install"/helper/ || exit 1
	./multilib-check.sh
	# Verificação do repositório CHAOTIC-AUR
	pacman -Qqs chaotic-mirrorlist || ./chaotic-aur.sh
	cd "$install" || exit 1

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
# Gerenciamento de pacotes e manutenção do sistema
cd "$install"/helper/ || exit 1
chmod +x helper_install.sh
# shellcheck disable=SC1091
source helper_install.sh # Wrappers do pacman (AUR Helper)
cd "$install" || exit 1
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
	sudo pacman --needed --noconfirm -S hyprutils nwg-displays xdg-user-dirs swappy satty pinta
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
ml4w_dotfiles_install(){
	# **The ML4W Dotfiles for Hyprland**
	echo "Iniciando instalação do ML4W Dotfiles para Hyprland..."
	sleep 5
	# ml4w_lista_de_dependências_oficiais
	ml4w_os_install
	ml4w_configuracoes_customizadas
}
command_hyprland(){
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
	verificar_kernel_hooks
	verificar_helper 
	detectar_vm 
	# pacotes_essenciais
	# pacotes_recomendados
	# instalar_sddm_silent_theme 
	ml4w_dotfiles_install
	remover_pacotes
else
	command_hyprland
	ml4w_dotfiles_install
	remover_pacotes
fi

	echo "Instalação finalizada..."
	echo "Reinicie o computador para que as configurações surtam efeito!"
	exit 0


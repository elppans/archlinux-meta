#!/bin/bash
# shellcheck disable=SC2010,SC2027,SC2046,SC2002,SC2016,SC2086,SC2317,SC1091
#
# Script "gnome-shell-extensions_manager.sh" está dando erro em tty, então foi desativado.

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
	echo "Erro: Este script não deve ser executado como superusuário (root)."
	echo "Por favor, execute como um usuário normal."
	exit 1
fi

locdir="$(pwd)"
install="$locdir"
export install
base_install="$(basename $install)"
export base_install

PACOTES=(
	# Pacotes Dev
	base-devel # Meta-pacote com ferramentas essenciais de compilação (gcc, make, autoconf, etc.)
	curl       # Ferramenta para transferência de dados via URLs com suporte a múltiplos protocolos
	git        # Sistema de controle de versão distribuído
	expac      # Utilitário de extração de dados do banco de dados do pacman
	pkgfile    # Ferramenta para buscar qual pacote provê determinado arquivo/binário
)

# Gnome Shell Meta Packages
for pkg in gnome gdm; do
	if ! pacman -Qs "$pkg" >/dev/null; then
		echo -e "O pacote '$pkg' não está instalado...\n\
Utilize o script \"gnome-shell-meta.sh\" e reinicie o sistema.\n\
Após logar, abra o terminal e execute novamente a instalação!" >&2
		exit 1
	fi
done

clear
echo -e "\nIniciando a configuração do ambiente GNOME...

Este processo irá preparar os componentes necessários do sistema.
Ao final da instalação, o sistema será reiniciado automaticamente para aplicar as mudanças.

Por favor, aguarde enquanto tudo é configurado..."

# Função para definir um Loop/Tempo
sleeping() {
	local time
	time="$1"
	for i in $(seq "$time" -1 1); do
		echo -ne "$i Seg.\r"
		sleep 1
	done
}
sleeping 5

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

pacotes_essenciais() {
	# Pacotes essenciais para desenvolvimento (Garantindo que estejam instalados)
	# Atualização completa do sistema e instalação de pacotes excenciais para a base e gerenciador de pacotes
	echo "Garantindo que pacotes essenciais estejam instalados..."
	sleep 5sudo pacman --needed --noconfirm -Syu "${PACOTES[@]}"
	sudo pkgfile -u
}

pacotes_pacman() {
	# Instalação de pacotes
	cd "$install"/pacotes/ || exit 1
	echo "Efetuando instalação de pacotes \"pacman\" e \"AUR\"..."
	sleeping 6
	./pacman.sh
	./pacman.ini
}

pacotes_flatpak() {
	echo "Efetuando instalação de pacotes Flatpak..."
	sleeping 6
	./flatpak.sh
	./flatpak.ini
}

config_gnome_shell() {
	# Configurações do sistema
	echo "Efetuando configurações do Gnome Shell..."
	sleeping 6
	# cd "$install"/config/Gnome-Shell || exit 1
	# ./gnome-shell-build-xdg-directories.sh # Configuração e sincronização dos arquivos de diretórios XDG
	# ./gnome-shell-extensions.sh            # Extensões do Gnome Shell
	# ./gnome-shell-headerbar.sh             # Define o estilo CSS para reduzir o tamanho da barra
	# ./gnome-shell-keyboard.sh              # Configurações de atalhos do Gnome Shell+
	# ./gnome-shell-set.sh                   # Configurações do Gnome Shell+
	# ./gnome-shell-themes-orchis.sh         # Instalação e configuração de temas (Orchis)
	# ./gnome-shell-themes.sh                # Configurações de temas para aplicativos externos do Gnome Shell+
	find "$install"/config/Gnome-Shell -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "config/Gnome-Shell", desde que tenham permissão de execução
}

config_custom() {
	# Customizações do sistema com Scripts
	echo "Efetuando execução de Customizações do sistema via Scripts"
	sleeping 6
	find "$install"/custom -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "custom", desde que tenham permissão de execução
}

sincronizacao_diretorios() {
	# Sincroniza estrutura de meta-dir para a raiz do sistema
	echo "Efetuando sincronização da Sessão Meta-dir..."
	sleeping 6
	sudo tar -c -C "$install/meta-dir" . | sudo tar -x --skip-old-files -p -f - -C /

	echo "Efetuando sincronização da Sessão Skel para $HOME..."
	sleeping 6
	tar -c -C /etc/skel . | tar -x --skip-old-files -f - -C "$HOME"
	sudo chown -Rf "$USER":"$USER" "$HOME"
}

# Executando as funções
verificar_repositorios
pacotes_essenciais
verificar_kernel_hooks
verificar_helper
detectar_vm
pacotes_pacman
pacotes_flatpak
config_gnome_shell
config_custom
sincronizacao_diretorios

echo "Ocultando $base_install no diretório $HOME..."
sleeping 6
echo "${base_install}" >>"$HOME/.hidden"

# Mensagem final
echo -e "\nInstalação concluída com sucesso!"
sleeping 6

echo -e "\nReiniciando o sistema para aplicar as mudanças..."
sleeping 15
sudo systemctl reboot -i

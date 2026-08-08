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

# Verificação do repositório MULTILIB
cd "$install"/helper/ || exit 1
source multilib-check.sh
cd "$install" || exit 1

# Atualização completa do sistema e instalação de pacotes excenciais para a base e gerenciador de pacotes
sudo pacman --needed --noconfirm -Syu "${PACOTES[@]}"
sudo pkgfile -u

# Exemplo de uso para a instalação de dependências opcionais:
# sudo pacman --needed -S pacote $(pacman-optdepends -c pacote)

# Gerenciamento de pacotes e manutenção do sistema
cd "$install"/helper/ || exit 1
pacman -Qqs chaotic-mirrorlist || ./chaotic-aur.sh # Adicionar repositório Chaotic-AUR
source helper_install.sh # Wrappers do pacman (AUR Helper)
cd "$install" || exit 1

# Remoção de pacotes:
# sudo pacman --noconfirm -R epiphany gnome-music         # Remove o navegador GNOME Web, o aplicativo de música do GNOME.

# Instalação de pacotes
cd "$install"/pacotes/ || exit 1
./detect-vm.sh # Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários

echo "Efetuando instalação de pacotes \"pacman\" e \"AUR\"..."
sleeping 6
./pacman.sh

echo "Efetuando instalação de pacotes Flatpak..."
sleeping 6
./flatpak.sh

# Configurações do sistema
echo "Efetuando configurações do sistema..."
sleeping 6
cd "$install"/config/Gnome-Shell || exit 1
./gnome-shell-build-xdg-directories.sh # Configuração e sincronização dos arquivos de diretórios XDG 
./gnome-shell-extensions.sh # Extensões do Gnome Shell
./gnome-shell-headerbar.sh # Define o estilo CSS para reduzir o tamanho da barra
./gnome-shell-keyboard.sh # Configurações de atalhos do Gnome Shell+
./gnome-shell-set.sh # Configurações do Gnome Shell+
./gnome-shell-themes-orchis.sh # Instalação e configuração de temas
./gnome-shell-themes.sh # Configurações de temas para aplicativos externos do Gnome Shell+

cd "$install"/config/System || exit 1
./samba-share-set.sh      # Configuração do SAMBA

# Finalizando configurações do sistema e pacotes
cd "$install"/pacotes/ || exit 1
echo "Efetuando configuração baseado em pacotes \"pacman\" e \"AUR\" instalados"
sleeping 6
./pacman.ini

echo "Efetuando configuração baseado em pacotes Flatpak"
sleeping 6
./flatpak.ini

# Customizações do sistema com Scripts
echo "Efetuando execução de Customizações do sistema via Scripts"
sleeping 6
find "$install"/custom -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "custom", desde que tenham permissão de execução


# Mensagem final
echo -e "\nInstalação concluída com sucesso!"

# Verifica se há inibidores ativos
if systemd-inhibit | grep -q 'UID'; then
	echo -e "\nExistem inibidores ativos que podem bloquear o reboot normal.\n\
Executando reinicialização forçada para garantir aplicação das mudanças..."
	sleeping 15
	sudo systemctl reboot -i
else
	echo -e "\nReiniciando o sistema para aplicar as mudanças..."
	sleeping 15
	sudo systemctl reboot
fi

echo "${base_install}" >> "$HOME/.hidden"

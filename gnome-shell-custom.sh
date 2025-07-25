#!/bin/bash
# shellcheck disable=SC2010,SC2027,SC2046,SC2002,SC2016,SC2086,SC2317,SC1091

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
	echo "Erro: Este script não deve ser executado como superusuário (root)."
	echo "Por favor, execute como um usuário normal."
	exit 1
fi

locdir="$(pwd)"
install="$locdir"
export install

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

# Atualização completa do sistema e instalação de pacotes excenciais para a base e gerenciador de pacotes
sudo pacman --needed --noconfirm -Syu base-devel git curl # Atualiza os sistema e instala pacotes essenciais para desenvolvimento junto com o Git.
sudo pacman --needed --noconfirm -Syu expac               # Ferramenta para exibir informações detalhadas sobre pacotes do pacman
sudo pacman --needed --noconfirm -Syu pkgfile             # Utilitário para buscar arquivos pertencentes a pacotes no repositório
sudo pkgfile -u

# Exemplo de uso para a instalação de dependências opcionais:
# sudo pacman --needed -S pacote $(pacman-optdepends -c pacote)

# Gerenciamento de pacotes e manutenção do sistema
cd "$install"/helper/ || exit 1
source chaotic-aur.sh    # Adicionar repositório Chaotic-AUR
source helper_install.sh # Wrappers do pacman (AUR Helper)

# Customizações do sistema com Scripts
cd "$install" || exit 1
find "$install"/custom -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "custom", desde que tenham permissão de execução

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
cd "$install"/config/ || exit 1
./Gnome-Shell/gnome-shell-set.sh # Configurações do Gnome Shell+
./System/samba-share-set.sh      # Configuração do SAMBA

# Finalizando configurações do sistema e pacotes
cd "$install"/pacotes/ || exit 1
echo "Efetuando configuração baseado em pacotes \"pacman\" e \"AUR\" instalados"
sleeping 6
./pacman.ini

echo "Efetuando configuração baseado em pacotes Flatpak"
sleeping 6
./flatpak.ini

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

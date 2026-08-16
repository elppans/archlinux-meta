#!/bin/bash

# Gnome Meta Install

PACOTES=(
	# Pacotes Meta
	gnome          # Meta-pacote com o ambiente de trabalho completo GNOME
	gnome-tweaks   # Ferramenta para ajustes avançados de interface e comportamento do GNOME
	htop           # Visualizador de processos interativo em modo texto
	nano           # Editor de texto simples para terminal
	openssh        # Cliente e servidor para shell remoto seguro (SSH)
	smartmontools  # Utilitários para monitoramento de saúde de HDs e SSDs via S.M.A.R.T.
	vim            # Editor de texto avançado e altamente customizável
	wget           # Utilitário para download de arquivos via HTTP, HTTPS e FTP
	xdg-utils      # Ferramentas de integração com o desktop (como xdg-open)
	iwd            # Daemon moderno para gerenciamento de conexões Wi-Fi
	wireless_tools # Ferramentas legadas para configuração de interfaces wireless (iwconfig)
	wpa_supplicant # Daemon de autenticação para redes Wi-Fi com WPA/WPA2/WPA3

	# Pacotes Dev
	base-devel # Meta-pacote com ferramentas essenciais de compilação (gcc, make, autoconf, etc.)
	curl       # Ferramenta para transferência de dados via URLs com suporte a múltiplos protocolos
	git        # Sistema de controle de versão distribuído
	expac      # Utilitário de extração de dados do banco de dados do pacman
	pkgfile    # Ferramenta para buscar qual pacote provê determinado arquivo/binário
)

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
	echo "Erro: Este script não deve ser executado como superusuário (root)."
	echo "Por favor, execute como um usuário normal."
	exit 1
fi
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

# Obtém a versão do kernel em execução
kernel_version=$(uname -r)

# Obtém a versão do diretório em /lib/modules
# shellcheck disable=SC2010
module_version=$(ls /lib/modules | grep "^$kernel_version$")

if [ "$kernel_version" == "$module_version" ]; then
	echo
	# echo "OK: A versão do kernel ($kernel_version) e o diretório em /lib/modules correspondem."
	# exit 0
else
	echo "ERRO: A versão do kernel ($kernel_version) e o diretório em /lib/modules não correspondem."
	echo "Por favor, reinicie o sistema para aplicar as configurações corretamente."
	exit 1
fi

# Adiciona a linha "ILoveCandy" em /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf

# Descomenta "Color" se ele estiver comentado
sudo sed -i 's/^#\s*Color/Color/' /etc/pacman.conf

# Atualização da lista de pacotes
sudo pacman -Syy

if ! pacman -Qq kernel-modules-hook &>/dev/null; then
    # Sincroniza a base de dados E atualiza o sistema para evitar parcial upgrade
    sudo pacman -Syu --needed --noconfirm kernel-modules-hook

    # Ativa e inicia o serviço para limpar módulos antigos
	# liberando espaço e evitando possíveis conflitos com módulos desnecessários.
    sudo systemctl enable --now linux-modules-cleanup.service
fi

# Instalando Gnome Shell (Meta)
sudo pacman --needed --noconfirm -Syu "${PACOTES[@]}"
sudo pkgfile -u

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Ativação do Display manager (Gerenciador de Login)
systemctl is-enabled display-manager.service && sudo systemctl disable display-manager.service
systemctl is-enabled gdm.service || sudo systemctl enable gdm.service

echo -e "\nInstalação concluída com sucesso!

O sistema será reiniciado agora para aplicar as mudanças.
Após a reinicialização, faça login normalmente e execute o script \"gnome-shell-custom.sh\" no terminal para finalizar a configuração do GNOME.
"
sleeping 15
sudo systemctl reboot

# Seguir para "META Pós Install"

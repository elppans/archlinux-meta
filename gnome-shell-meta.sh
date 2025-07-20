#!/bin/bash

# Gnome Meta Install

# Instalação do Gnome Shell e Ferramentas

# Atualiza a lista de pacotes e executa uma atualização completa do sistema
# Instalando os seguintes pacotes:
# - gnome: Ambiente gráfico GNOME completo
# - gnome-tweaks: Ferramenta para ajustes adicionais no GNOME
# - htop: Monitor de processos interativo no terminal
# - iwd: Gerenciador de conexões Wi-Fi da Intel
# - nano: Editor de texto simples para terminal
# - openssh: Implementação do protocolo SSH para acesso remoto seguro
# - smartmontools: Ferramentas para monitoramento e diagnóstico de discos rígidos
# - vim: Editor de texto avançado no terminal
# - wget: Ferramenta para download de arquivos via HTTP, HTTPS e FTP
# - wireless_tools: Conjunto de ferramentas para gerenciar conexões Wi-Fi
# - wpa_supplicant: Gerenciador de autenticação Wi-Fi
# - xdg-utils: Ferramentas para integração de aplicativos com o ambiente gráfico

# Para completar o Gnome, deve usar o Script versão "META Pós Install"

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

# Atualização da lista de pacotes
sudo pacman -Syy

# Instala o pacote 'kernel-modules-hook' para garantir que os módulos do kernel
# sejam gerenciados corretamente após a atualização ou mudança do kernel.
sudo pacman --needed --noconfirm -Syu kernel-modules-hook

# Ativa e inicia o serviço 'linux-modules-cleanup' para limpar os módulos antigos
# do kernel, liberando espaço e evitando possíveis conflitos com módulos desnecessários.
systemctl is-enabled linux-modules-cleanup.service || sudo systemctl enable --now linux-modules-cleanup.service

# Instalando Gnome Shell (Meta)
sudo pacman --needed --noconfirm -Syu gnome gnome-tweaks htop iwd nano openssh smartmontools vim wget wireless_tools wpa_supplicant xdg-utils

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

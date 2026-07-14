#!/bin/bash
# shellcheck disable=SC2155,SC2162,SC2046

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
	echo "Quando necessário, será pedido a senha administrativa!"
    exit 1
fi

bindir="$(pwd)"
export bindir

# Define variáveis
USER_REAL="$USER"
HOME_REAL="$HOME"
BKP_NAME="$HOME_REAL.BKP_$(date +%Y%m%d_%H%M)"

# Função para definir um Loop/Tempo
sleeping() {
	local time
	time="$1"
	for i in $(seq "$time" -1 1); do
		echo -ne "$i Seg.\r"
		sleep 1
	done
}

# Verificação do repositório CHAOTIC-AUR
# Se estiver ativo, o Script não reinstala o base-devel e o grub
if [ -d "$bindir/../helper" ]; then
	echo "Verificando se o repositório chaotic-aur está ativo..."
	sleeping 5
	if pacman -Qqs chaotic-mirrorlist ;then
		cd "$bindir/../helper" || exit 1
		chmod +x chaotic-aur-remove.sh
		./chaotic-aur-remove.sh
		cd "$bindir" || exit 1
	fi
fi

echo "Iniciando reset do ambiente de usuário para: $USER_REAL"
sleeping 5

# 1. Move o diretório atual (Backup)
# Usamos sudo mas garantimos que o caminho seja absoluto
sudo mv "$HOME_REAL" "$BKP_NAME"

# 2. Cria o novo HOME
sudo mkdir -p "$HOME_REAL"

# 3. Copia TUDO do skel (não apenas .bash*)
# O ponto '.' ao final de /etc/skel/. garante que arquivos ocultos sejam copiados
sudo cp -ra /etc/skel/. "$HOME_REAL/"

# 4. Ajusta permissões de forma recursiva
# Garante que o usuário e o grupo principal do usuário sejam donos
sudo chown -R "$USER_REAL":"$(id -gn "$USER_REAL")" "$HOME_REAL"

echo "Processo concluído. O backup está em: $BKP_NAME"

echo -e "Removendo aplicativos Flatpak"
sleeping 5
command -v flatpak &>/dev/null && sudo flatpak uninstall --system --all -y && flatpak uninstall --user --all -y

echo -e "Removendo aplicativos Snap"
sleeping 5
command -v snap &>/dev/null && snap list 2>/dev/null | tail -n +2 | awk '{print $1}' | xargs -r -n 1 sudo snap remove

echo -e 'Redefinindo o Shell do usuário'
sleeping 5
sudo chsh -s /bin/bash "$USER"

# Pause para verificar se as respostas estão corretas.
# Se OK, apertar ENTER para continuar, senão, CTRL+C para cancelar
read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo de instalação de TODOS os pacotes instalados "como Explicitamente" para "como dependência"'
sleeping 5
# Opção "-n" significa apenas "pacotes nativos", então é melhor ser mais Hardcore e remover para exatamente TODOS os pacotes, independente de qual seja.
sudo pacman -D --asdeps $(pacman -Qq)

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Alterando o motivo da instalação para "como explicitamente" apenas os PACOTES ESSENCIAIS. Aqueles que você NÃO deseja remover'
sleeping 5
sudo pacman -D --asexplicit $(pacman -Qqs ucode) base linux linux-firmware btrfs-progs git nano networkmanager pipewire wpa_supplicant wireless_tools sudo wget

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Remover os pacotes, menos os configurados como "Instalados Explicitamente"'
sleeping 5
sudo pacman -Rsunc $(pacman -Qttdq)

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Retornando alguns pacotes de compilação'
sleeping 5
sudo pacman --needed --noconfirm -S base-devel

read -p "Aperte ENTER para continuar, ou CTRL+C para cancelar" ;

echo -e 'Garantindo o GRUB'
sleeping 5
sudo pacman -S --needed --noconfirm grub-efi-x86_64 efibootmgr dosfstools os-prober mtools
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Remove arquivos customizados de "/etc/profile.d"
{
sudo rm -rf /etc/profile.d/gnome-shell-extensions_manager.sh
sudo rm -rf /etc/profile.d/gnome-shell-themes-flatpak.sh
sudo rm -rf /etc/profile.d/silent-sddm-switch_theme.sh
sudo unlink /usr/local/bin/silent-sddm-switch_theme
}  &>>/dev/null

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


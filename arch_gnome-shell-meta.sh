# Instalação do Gnome Shell e Ferramentas
# Atualização do sistema e instalação dos pacotes
sudo pacman --needed --noconfirm -Syyu gnome \
gnome-tweaks \
htop \
iwd \
nano \
openssh \
smartmontools \
vim \
wget \
wireless_tools \
wpa_supplicant \
xdg-utils

# Criação/Atualização dos Diretórios Padrões de Usuário
xdg-user-dirs-update

# Configurações da Barra Superior
# Para mostrar a data e os segundos na barra superior
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Display manager, gerenciador de login
# ./display-manager-gdm_instalar.sh
sudo pacman --needed --noconfirm -Syyu gdm
sudo systemctl disable $(systemctl status display-manager.service | head -n1 | awk '{print $2}')
sudo systemctl enable gdm.service

# Pós install


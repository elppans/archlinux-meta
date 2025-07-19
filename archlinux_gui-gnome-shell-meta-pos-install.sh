#!/bin/bash
# shellcheck disable=SC2010,SC2027,SC2046,SC2002,SC2016,SC2086,SC2317

# Verifica se o script está sendo executado como root
if [ "$EUID" -eq 0 ]; then
    echo "Erro: Este script não deve ser executado como superusuário (root)."
    echo "Por favor, execute como um usuário normal."
    exit 1
fi

locdir="$(pwd)"
install="$locdir"
export install

# Obtém a versão do kernel em execução
kernel_version=$(uname -r)

# Verifica se a versão do kernel em execução existe em /lib/modules
if ls /lib/modules | grep -q "^$kernel_version$"; then
    echo
    # echo "OK: A versão do kernel ($kernel_version) está presente em /lib/modules."
    # exit 0
else
    echo "ERRO: A versão do kernel ($kernel_version) não está presente em /lib/modules."
    echo "Por favor, reinicie o sistema para aplicar as configurações corretamente."
    exit 1
fi

# Adiciona a linha "ILoveCandy" em /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sudo sed -i '/# Misc options/a ILoveCandy' /etc/pacman.conf

# Atualização completa do sistema e instalação de pacotes excenciais para a base e gerenciador de pacotes

sudo pacman --needed --noconfirm -Syyu base-devel git         # Atualiza os sistema e instala pacotes essenciais para desenvolvimento junto com o Git.
sudo pacman --needed --noconfirm -S expac                     # Ferramenta para exibir informações detalhadas sobre pacotes do pacman  
sudo pacman --needed --noconfirm -S pkgfile                   # Utilitário para buscar arquivos pertencentes a pacotes no repositório  
sudo pkgfile -u

# Exemplo de uso para a instalação de dependências opcionais:
# sudo pacman --needed -S pacote $(pacman-optdepends -c pacote)

# Gerenciamento de pacotes e manutenção do sistema
cd "$install"/helper/ || exit 1
./helper/pacote-helper-paru_instalar.sh              # Wrappers do pacman (AUR Helper) - paru
./pacote-helper-yay_instalar.sh             # Wrappers do pacman (AUR Helper) - yay
"$install"/pacotes/repositorio-chaotic-aur.sh              # Adicionar repositório Chaotic-AUR

# Remoção de pacotes:

sudo pacman --noconfirm -R epiphany gnome-music         # Remove o navegador GNOME Web, o aplicativo de música do GNOME.

# Instalação de pacotes

"$install"/pacotes/detect-vm.sh                      # Detecta se o sistema está rodando em uma máquina virtual (VM) e instala os pacotes necessários
"$install"/pacotes/pacman.sh

# Configurações do sistema

"$install"/config/Gnome-Shell/gnome-shell-set.sh              # Configurações do Gnome Shell+
"$install"/config/System/samba-share-set.sh                   # Configuração do SAMBA

# Customizações do sistema com Scripts
cd "$install" || exit 1
find "$install"/custom -type f -name "*.sh" -executable -exec {} \; # Executa todos os Scripts do diretório "custom", desde que tenham permissão de execução

# Mensagem final
echo -e '\n\nReinicie o computador para aplicar as configurações!\n\n'

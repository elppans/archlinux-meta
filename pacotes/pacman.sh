#!/bin/bash
# shellcheck disable=SC2145,SC1091

pacman_lo="$(pwd)"
export pacman_lo

cd ../helper/ || exit 1
source helper_install.sh
cd "$pacman_lo" || exit 1

if [[ -z "$HELPER" ]]; then
    echo "Erro: A variável HELPER não está definida!"
    echo "$HELPER"
    exit 1
elif ! command -v "$HELPER" &> /dev/null; then
    echo "Erro: '$HELPER' não é um helper válido ou não está instalado!"
    exit 1
fi

# Verifica se o arquivo pacman.list existe
if [[ ! -f "pacman.list" ]]; then
    echo "Arquivo 'pacman.list' não encontrado. Certifique-se de que ele existe no mesmo diretório do script."
    exit 1
fi

#-----------------------------#
# remove blacklisted packages #
#-----------------------------#
if [ -f "pacman_black.list" ]; then
    grep -v -f <(grep -v '^#' "pacman_black.list" | sed 's/#.*//;s/ //g;/^$/d') <(sed 's/#.*//;s/ //g;/^$/d' "pacman.list") > "/tmp/install_pkg_filtered.lst"
fi

# Cria uma lista de pacotes a partir do arquivo, ignorando linhas comentadas ou vazias
pacotes=()
while IFS= read -r linha; do
    # Ignora linhas comentadas ou vazias
    if [[ "$linha" =~ ^#.*$ || -z "$linha" ]]; then
        continue
    fi
    pacotes+=("$linha")
done < "/tmp/install_pkg_filtered.lst"

# Verifica se há pacotes a serem instalados
if [[ ${#pacotes[@]} -eq 0 ]]; then
    echo "Nenhum pacote válido foi encontrado no arquivo."
    exit 1
fi

# Instala todos os pacotes em um único comando usando pacman
echo -e "Instalando os seguintes pacotes:"
for pacote in "${pacotes[@]}"; do
    echo "- $pacote"
done
sleep 5
"${HELPER}" -Syu --needed "${pacotes[@]}" || echo "Erro ao instalar alguns pacotes."

echo "Processo concluído!"

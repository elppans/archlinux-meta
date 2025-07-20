#!/bin/bash
# shellcheck disable=SC2145,SC2068

# Verifica se o arquivo flatpak.list existe
if [[ ! -f "flatpak.list" ]]; then
    echo "Arquivo 'flatpak.list' não encontrado. Certifique-se de que ele existe no mesmo diretório do script."
    exit 1
fi

#-----------------------------#
# remove blacklisted packages #
#-----------------------------#
if [ -f "flatpak_black.list" ]; then
    grep -v -f <(grep -v '^#' "flatpak_black.list" | sed 's/#.*//;s/\n //g;/^$/d') <(sed 's/#.*//;s/\n //g;/^$/d' "flatpak.list") > "/tmp/install_flatpak_filtered.list"
fi

# Cria uma lista de pacotes a partir do arquivo, ignorando linhas comentadas ou vazias
pacotes=()
while IFS= read -r linha; do
    # Ignora linhas comentadas ou vazias
    if [[ "$linha" =~ ^#.*$ || -z "$linha" ]]; then
        continue
    fi
    pacotes+=("$linha")
done < "/tmp/install_flatpak_filtered.list"

# Verifica se há pacotes a serem instalados
if [[ ${#pacotes[@]} -eq 0 ]]; then
    echo "Nenhum pacote válido foi encontrado no arquivo."
    exit 1
fi

# Instala todos os pacotes em um único comando

echo -e "Instalando os seguintes pacotes Flatpak:"
for pacote in "${pacotes[@]}"; do
    echo "- $pacote"
done
sleep 5
sudo flatpak -y install ${pacotes[@]} || echo "Erro ao instalar alguns pacotes."

echo "Processo concluído!"

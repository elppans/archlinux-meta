#!/bin/bash
# shellcheck disable=SC2145

# Verifica se o arquivo pacman.lst existe
if [[ ! -f "pacman.lst" ]]; then
    echo "Arquivo 'pacman.lst' não encontrado. Certifique-se de que ele existe no mesmo diretório do script."
    exit 1
fi

# Cria uma lista de pacotes a partir do arquivo, ignorando linhas comentadas ou vazias
pacotes=()
while IFS= read -r linha; do
    # Ignora linhas comentadas ou vazias
    if [[ "$linha" =~ ^#.*$ || -z "$linha" ]]; then
        continue
    fi
    pacotes+=("$linha")
done < "pacman.lst"

# Verifica se há pacotes a serem instalados
if [[ ${#pacotes[@]} -eq 0 ]]; then
    echo "Nenhum pacote válido foi encontrado no arquivo."
    exit 1
fi

# Instala todos os pacotes em um único comando usando pacman

echo "Instalando os seguintes pacotes: ${pacotes[@]}"
sudo pacman -S --noconfirm "${pacotes[@]}" || echo "Erro ao instalar alguns pacotes."

echo "Processo concluído!"

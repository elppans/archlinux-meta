#!/usr/bin/env bash

if [ ! -f "$HOME/.config/Kvantum/kvantum.kvconfig" ]; then
	echo "Arquivo \"$HOME/.config/Kvantum/kvantum.kvconfig\" não existe!"
	exit 1
fi

# Cria o diretorio para o tema KvLibadwaita no espaço do usuário
mkdir -p "$HOME"/.config/Kvantum/KvLibadwaita

# Copia os arquivos de definição do tema KvLibadwaita do host para o novo diretorio
rsync -ah /usr/share/Kvantum/KvLibadwaita/ "$HOME"/.config/Kvantum/KvLibadwaita/

# Tema atual do KVantum no sistema
KVTHEME="$(sed -n 's/^theme=\(.*\)/\1/p' "$HOME"/.config/Kvantum/kvantum.kvconfig)"
export KVTHEME

# Configurações esperadas (Sintaxe idêntica à saída do flatpak override --show)
EXPECTED_FILESYSTEMS=(
    "xdg-config/Kvantum:ro"
    "xdg-config/qt5ct:ro"
    "xdg-config/qt6ct:ro"
    "xdg-config/gtk-3.0:ro"
    "xdg-config/gtk-4.0:ro"
)

EXPECTED_ENVS=(
    "QT_QPA_PLATFORMTHEME=qt5ct"
    "QT_STYLE_OVERRIDE=kvantum"
    "KVANTUM_THEME=$KVTHEME"
)

# Captura a configuração atual global do usuário
CURRENT_OVERRIDE=$(flatpak override --user --show 2>/dev/null)

# Arrays para armazenar o que precisa ser aplicado
TO_APPLY_FS=()
TO_APPLY_ENV=()

# 1. Validar Filesystems
for fs in "${EXPECTED_FILESYSTEMS[@]}"; do
    if ! echo "$CURRENT_OVERRIDE" | grep -qF "$fs"; then
        TO_APPLY_FS+=("--filesystem=$fs")
    fi
done

# 2. Validar Variáveis de Ambiente
for env in "${EXPECTED_ENVS[@]}"; do
    if ! echo "$CURRENT_OVERRIDE" | grep -qF "$env"; then
        TO_APPLY_ENV+=("--env=$env")
    fi
done

# 3. Execução condicional
if [ ${#TO_APPLY_FS[@]} -eq 0 ] && [ ${#TO_APPLY_ENV[@]} -eq 0 ]; then
    # echo "Configuração do Flatpak já está íntegra e consistente. Nada a fazer."
    exit 0
fi

# echo "Inconsistências encontradas. Aplicando correções..."

# Aplica overrides de sistema de arquivos faltantes
if [ ${#TO_APPLY_FS[@]} -gt 0 ]; then
    # echo "Aplicando permissões de diretório: ${TO_APPLY_FS[*]}"
    flatpak override --user "${TO_APPLY_FS[@]}"
fi

# Aplica overrides de variáveis de ambiente faltantes
if [ ${#TO_APPLY_ENV[@]} -gt 0 ]; then
    # echo "Aplicando variáveis de ambiente: ${TO_APPLY_ENV[*]}"
    flatpak override --user "${TO_APPLY_ENV[@]}"
fi

# echo "Configuração atualizada com sucesso."
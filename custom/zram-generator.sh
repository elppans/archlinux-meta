#!/usr/bin/env bash

CONF_FILE="/etc/systemd/zram-generator.conf"

DESIRED_CONF="$(cat <<'EOF'
[zram0]
# Algoritmo de compressão idêntico ao archinstall
compression-algorithm = zstd

# Tamanho do dispositivo ZRAM em relação à RAM total (ex: 100% da RAM = ram / 1)
# O padrão do archinstall aloca até 100% da RAM para a pool de ZRAM.
zram-size = ram / 1

# Prioridade máxima de Swap para garantir priorização em relação a discos
swap-priority = 100
EOF
)"

zram_generator_config() {
if ! pacman -Qq zram-generator &>>/dev/null; then
	sudo pacman -Syu zram-generator
fi

if [ -f "$CONF_FILE" ]; then
	sudo cp -av "$CONF_FILE" "${CONF_FILE}.BKP_$(date +%Y%m%d_%H%M%S)"
fi

sudo tee "$CONF_FILE" <<'EOF'
[zram0]
# Algoritmo de compressão idêntico ao archinstall
compression-algorithm = zstd

# Tamanho do dispositivo ZRAM em relação à RAM total (ex: 100% da RAM = ram / 1)
# O padrão do archinstall aloca até 100% da RAM para a pool de ZRAM.
zram-size = ram / 1

# Prioridade máxima de Swap para garantir priorização em relação a discos
swap-priority = 100
EOF
}

# Se o arquivo já existe e o conteúdo é idêntico ao desejado, não faz nada.
if [ -f "$CONF_FILE" ] && [ "$(cat "$CONF_FILE")" == "$DESIRED_CONF" ]; then
	echo "zram-generator já está configurado corretamente. Nada a fazer."
else
	zram_generator_config
fi


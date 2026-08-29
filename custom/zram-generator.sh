#!/usr/bin/env bash

if ! pacman -Qq zram-generator  &>>/dev/null ;then
	sudo pacman -Syu zram-generator
fi

if [ -f /etc/systemd/zram-generator.conf ]; then
	sudo cp -av /etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf.BKP_"$(date +%Y%m%d_%H%M)"
fi

sudo tee /etc/systemd/zram-generator.conf <<'EOF'
[zram0]
# Algoritmo de compressão idêntico ao archinstall
compression-algorithm = zstd

# Tamanho do dispositivo ZRAM em relação à RAM total (ex: 100% da RAM = ram / 1)
# O padrão do archinstall aloca até 100% da RAM para a pool de ZRAM.
zram-size = ram / 1

# Prioridade máxima de Swap para garantir priorização em relação a discos
swap-priority = 100
EOF

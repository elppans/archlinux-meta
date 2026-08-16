#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo
mkdir -p "$HOME/.backup_dotfiles"
tar -czf "$HOME/.backup_dotfiles/config_$(date +%Y%m%d%H%M).tar.gz" -C "$HOME" .config

# Restaurar este backup se necessário no futuro:
# Extrair preservando permissões estritas:
# tar -xzpf "$HOME/.backup_dotfiles/config_NOME.tar.gz" -C "$HOME"

# Proposito de cópia como um "/etc/skel"

# Cenário 1: "Apenas adicione o que NÃO existe" (Ignorar completamente o que já está no destino)
# rsync -ahvz --keep-dirlinks --copy-unsafe-links --ignore-existing "$mk4wlo/ML4W/.config/." "$HOME/.config/" && export RCP="1"
# cp -aL -n "$mk4wlo/ML4W/." "$HOME/" && export RCP="1"

# Cenário 2: "Adicione o que não existe OU atualize apenas se for DIFERENTE"
# rsync -ahvz --keep-dirlinks --copy-unsafe-links "$mk4wlo/ML4W/.config/." "$HOME/.config/" && RCP="1"
# cp -aL -u "$mk4wlo/ML4W/.config/." "$HOME/.config/" && RCP="1"

# Usando tar:
# -k (--keep-old-files): 
# Trata a presença de um arquivo no destino como um erro de extração, emitindo o aviso de falha e retornando status code 2 (erro não fatal no término).
# --skip-old-files: 
# Ignora silenciosamente qualquer arquivo que já exista no destino, sem emitir mensagens no stderr e terminando a execução com código de saída limpo (0).

tar -c -C "$mk4wlo/ML4W" . | tar -x --skip-old-files -f - -C "$HOME"


#!/bin/bash

mk4wlo="$(pwd)"
export mk4wlo
mkdir -p "$HOME"/.backup_dotfiles
rsync -ah "$HOME"/.config "$HOME/.backup_dotfiles/.config_$(date +%Y%m%d%H%M)"

# Cenário 1: "Apenas adicione o que NÃO existe" (Ignorar completamente o que já está no destino)
rsync -ahvz --keep-dirlinks --copy-unsafe-links --ignore-existing "$mk4wlo/ML4W/.config/." "$HOME/.config/" && export RCP="1"

# Cenário 2: "Adicione o que não existe OU atualize apenas se for DIFERENTE"
rsync -ahvz --keep-dirlinks --copy-unsafe-links "$mk4wlo/ML4W/.config/." "$HOME/.config/" && RCP="1"

	if [ "$RCP" == "1" ]; then
		echo "Copiado .config para $HOME/.config!"
	else
		echo "Não foi possível copiar .config para $HOME/.config!" &&
			exit 1
	fi

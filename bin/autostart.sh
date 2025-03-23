#!/bin/bash

# Configurar a última linha em $HOME/.config/hypr/conf/autostart.conf:
# Autostart
# exec-once = /usr/local/bin/autostart.sh

# Diretório onde estão os arquivos .desktop do autostart
AUTOSTART_DIR="$HOME/.config/autostart"

# Verifica se o diretório existe
if [ -d "$AUTOSTART_DIR" ]; then
  # Itera por cada arquivo .desktop no diretório
  for desktop_file in "$AUTOSTART_DIR"/*.desktop; do
    # Verifica se o arquivo realmente existe
    [ -e "$desktop_file" ] || continue

    # Lê a linha que começa com "Exec="
    exec_line=$(grep '^Exec=' "$desktop_file")

    if [ -n "$exec_line" ]; then
      # Remove o prefixo "Exec="
      command=${exec_line#Exec=}

      # Executa o comando
      echo "Executando: $command"
      eval "$command" &
    fi
  done
else
  echo "O diretório $AUTOSTART_DIR não existe."
fi

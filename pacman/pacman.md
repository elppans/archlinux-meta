# Instalação de pacotes em lista

Você pode instalar todos os pacotes listados usando `pacman` diretamente, ignorando os comentários. Uma maneira simples de fazer isso é extrair apenas os nomes dos pacotes e passar para o comando `pacman -S`. Aqui está como você pode fazer isso:

```bash
awk '{print $1}' pacman.lst | grep -v '^#' | grep -v '^$' | xargs sudo pacman -S --needed
```

Explicação:
- `awk '{print $1}' lista.txt`: Extrai a primeira coluna de cada linha (que contém os nomes dos pacotes).
- `grep -v '^#'`: Remove linhas que começam com `#` (comentários).
- `grep -v '^$'`: Remove linhas vazias no resultado
- `xargs sudo pacman -S --needed`: Passa os nomes dos pacotes para `pacman`, garantindo que ele instale apenas os que não estão já instalados.

## Comentários dos pacotes

Os comentários não atrapalham porque o comando `grep -v '^#'` remove todas as linhas que começam com `#`, garantindo que apenas os nomes dos pacotes sejam passados para `pacman`. Isso evita que qualquer texto explicativo interfira no processo de instalação.

Se quiser testar antes de executar o comando, você pode rodar apenas esta parte:

```bash
awk '{print $1}' pacman.lst | grep -v '^#' | grep -v '^$'
```

Isso vai mostrar apenas os nomes dos pacotes, sem os comentários, para garantir que a lista esteja correta antes de instalar.


# Arch Linux Meta Pós-Instalação

Este repositório contém uma coleção de scripts criados para automatizar e facilitar o pós-instalação do **Arch Linux**. Ele foi desenvolvido para uso pessoal, mas está disponível para quem desejar utilizá-lo. **Use-o por sua própria conta e risco.**

**⚠️ Aviso Importante:** Este repositório foi projetado exclusivamente para o Arch Linux **puro**. Não foi testado ou garantido que funcione em distribuições derivadas (como Manjaro ou EndeavourOS). O autor **não se responsabiliza** por quaisquer danos causados ao sistema ou perda de dados resultante do uso destes scripts.

---

## 📋 Scripts Disponíveis

O repositório contém diversos scripts para facilitar a configuração e manutenção do Arch Linux. Aqui estão os principais:

- **`archlinux_gui-gnome-shell-meta.sh`**: Instala e configura o GNOME Shell com seus componentes principais.
- **`archlinux_gui-gnome-shell-meta_pos-install.sh`**: Realiza ajustes e automações no GNOME Shell após sua instalação.
- **`archlinux_clean-to-base.sh`**: Um script especial que limpa completamente o Arch Linux, removendo pacotes extras e deixando apenas a instalação base, como se tivesse sido recém-instalada. **Use com extrema cautela, pois ele pode apagar dados importantes.**
- **Scripts para gerenciadores de login** (como GDM, LightDM e SDDM): Automatizam a configuração de diferentes *display managers*.
- **Instalação e configuração do GRUB**: Scripts para configurar o carregador de inicialização GRUB.
- Outros scripts para tarefas específicas, ajustes no sistema e otimizações.

**Nota:** A lista completa de scripts pode ser encontrada diretamente no repositório.

---

## 🚀 Como Usar

### 1. Clone este repositório
Baixe os arquivos para o seu sistema:
```bash
git clone https://github.com/elppans/archlinux-meta-posinstall.git
cd archlinux-meta-posinstall
```

### 2. Revise e personalize os scripts
Cada sistema é único. Leia os scripts disponíveis e ajuste-os conforme suas necessidades antes de executá-los. Este repositório foi feito para uso pessoal, então personalizações podem ser necessárias.

### 3. Execute os scripts
Certifique-se de que os scripts têm permissão de execução:
```bash
chmod +x script1.sh
chmod +x script2.sh
# Adicione outros scripts que precisar
```

Execute os scripts conforme necessário:
```bash
./script1.sh
./script2.sh
```

**Importante:** Sempre revise os scripts antes de executá-los para entender os comandos e verificar se são apropriados para o seu sistema.

---

## ⚠️ Aviso Legal

Os scripts deste repositório foram criados para uso pessoal com foco no Arch Linux puro. O autor:
- **Não se responsabiliza** por quaisquer problemas, danos ao sistema ou perda de dados resultantes do uso.
- **Recomenda** que cada script seja revisado antes de ser executado.
- Salienta que o uso deste repositório deve ser feito **por sua própria conta e risco**.

---

## 📂 Estrutura do Repositório

O repositório contém scripts para diferentes tarefas de pós-instalação, incluindo:

- Configuração do GNOME Shell e extensões.
- Gerenciamento de gerenciadores de login (GDM, LightDM, SDDM).
- Instalação e configuração do GRUB.
- **Limpeza completa do sistema**: O script `archlinux_clean-to-base.sh` é especialmente projetado para deixar o Arch Linux com sua base mínima instalada, similar a uma instalação recém-concluída.

**A lista completa e a descrição dos scripts podem ser visualizadas no próprio repositório.**

---

## 🛠️ Requisitos

- Arch Linux (somente a versão oficial).
- Permissões de superusuário (root) para executar alguns scripts.
- Compreensão básica de comandos do Linux e do shell.

---

## 📋 Contribuições

Este repositório foi desenvolvido para uso pessoal, mas contribuições são bem-vindas! Caso você tenha sugestões, melhorias ou encontre problemas, sinta-se à vontade para abrir uma *issue* ou enviar um *pull request*.

---


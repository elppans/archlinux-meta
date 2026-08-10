# Usando paru com Arch chroot

## TL;DR
```bash
sudo pacman -Sy --needed --noconfirm devtools
sudo mkdir -p /var/lib/aurbuild/x86_64
sudo mkarchroot /var/lib/aurbuild/x86_64/root base-devel git
paru --removemake --sudoloop --nokeepsrc --needed --chroot -Sy PACOTE
paru --removemake --sudoloop --nokeepsrc --needed --noconfirm --chroot -Bi .
```

---

## Passo a passo detalhado

### 1) Instalar dependência
```bash
sudo pacman -Sy --needed --noconfirm devtools
```

### 2) Criar diretório do chroot
```bash
sudo mkdir -p /var/lib/aurbuild/x86_64
```

### 3) Gerar a base do Arch chroot
```bash
sudo mkarchroot /var/lib/aurbuild/x86_64/root base-devel git
```

### 4) Instalar pacotes com paru
```bash
paru --removemake --sudoloop --nokeepsrc --needed --chroot -Sy PACOTE
```

### 5) Instalar via PKGBUILD local com paru
```bash
paru --removemake --sudoloop --nokeepsrc --needed --noconfirm --chroot -Bi .
```

---

### Observações importantes

- Os passos **4** e **5** assumem que o `git` (ou outra dependência de build) já foi incluído no `mkarchroot` do passo **3**.  
- Se um PKGBUILD futuro precisar de outra ferramenta de VCS (ex.: `svn`, `bzr`, `hg` — listadas em `DevelSuffixes` do seu `paru.conf`), será necessário:
  - Recriar a base do chroot **ou**
  - Instalar manualmente via `arch-nspawn`, por exemplo:
    ```bash
    sudo arch-nspawn /var/lib/aurbuild/x86_64/root pacman -S <pacote>
    ```

---

## Links úteis

- **Man Pages: [devtools](https://man.archlinux.org/man/extra/devtools/devtools.7.en)**  
- **Arch Wiki: [chroot](https://wiki.archlinux.org/title/Chroot)**  
- [**Paru GitHub**](https://github.com/Morganamilo/paru)  
- **Arch Wiki: [AUR helpers](https://wiki.archlinux.org/title/AUR_helpers)**  
- **Arch Wiki: [Systemd-nspawn](https://wiki.archlinux.org/title/Systemd-nspawn)**  
- **Man Pages: [Devtools/arch-nspawn](https://man.archlinux.org/man/extra/devtools/arch-nspawn.1.en)**  
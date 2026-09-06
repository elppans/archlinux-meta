# Plasma Meta + Custom

- **`plasma-meta.sh`**: Instala e configura o KDE Plasma com seus componentes principais.  
>Ps.: Script baseado na sessão Plasma do Archinstall, utilizando plasma-desktop e aplicativos escolhidos manualmente para a instalação.  
>-- Para instalar via link direto, sem baixar o repositório, execute:  

```bash
bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/plasma-meta.sh')
```
- **`plasma-meta-custom.sh`**: Realiza ajustes e automações no Plasma após sua instalação.  
>Ps.: Deve utilizar este Script apenas após a instalação do Plasma (Meta).  
>O Meta pode ser instalado tanto via `Archinstall` quanto via `plasma-meta.sh`.  
>-- Para instalar via link direto, sem baixar o repositório, execute:  

```bash
bash <(wget -qO- 'https://elppans.github.io/archlinux-meta/plasma-meta-custom.sh')
```

---

**Capturas de tela** do ambiente **KDE Plasma** recém-instalado em uma VM **Arch Linux** (QEMU/KVM), usando o meta-pacote `plasma-meta-custom`.

<img width="1920" height="1080" alt="Captura de tela de 2026-09-06 01-14-25" src="https://github.com/user-attachments/assets/2e138823-3c5e-4244-b49e-422224660f35" />
  

*Saída do `fastfetch` no Konsole mostrando as informações do sistema: Arch Linux, kernel 7.2.3, KDE Plasma 6.7.4 rodando sob KWin (Wayland), tema Breeze Dark e hardware da VM (AMD Ryzen 5 4500, 4 GiB de RAM).*
___

<img width="1920" height="1080" alt="Captura de tela de 2026-09-06 01-15-05" src="https://github.com/user-attachments/assets/7648b2b2-b9ac-456b-99a4-c9c5b7ae542d" />  

*Gerenciador de arquivos Dolphin exibindo a pasta pessoal (Início) com as pastas padrão do sistema: Área de trabalho, Documentos, Downloads, Imagens, Modelos, Músicas, Projetos, Público e Vídeos.*  
___

<img width="1920" height="1080" alt="Captura de tela de 2026-09-06 01-15-51" src="https://github.com/user-attachments/assets/2ab8090c-b1b9-4d57-bac1-daef192cc3e2" />  

*Centro de Informações do Plasma, seção "Sobre este sistema", detalhando as versões instaladas (Plasma 6.7.4, Frameworks 6.29.0, Qt 6.11.2, kernel 7.2.3-arch1-2) e o hardware virtual (QEMU, 2 CPUs Ryzen 5 4500, 4 GiB de RAM).*  
___

<img width="1920" height="1080" alt="Captura de tela de 2026-09-06 01-16-22" src="https://github.com/user-attachments/assets/73e3d1d5-5203-4068-9c50-218ad9a92c78" />  

*Área de trabalho limpa, sem ícones, exibindo o papel de parede com o logotipo do Arch Linux sobre fundo azul escuro.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-16-54" src="https://github.com/user-attachments/assets/f226a3bc-a9d7-454b-9285-2882a430cfc6" />  

*Menu de aplicativos (Kickoff) com a categoria "Ajuda" selecionada, mostrando o atalho para o Centro de Informações.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-03" src="https://github.com/user-attachments/assets/7151cff5-1329-464b-aa73-e7de6b7c6e84" />  

*Menu de aplicativos na categoria "Desenvolvimento", listando DBeaver CE, Kate, Kompare e VSCodium instalados.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-09" src="https://github.com/user-attachments/assets/fadaa237-860a-4289-8908-4b6118b33cbd" />  

*Menu de aplicativos na categoria "Escritório", com Apostrophe, Editor do Sieve, KMail, KTnef, Merkuro Calendar, Merkuro Contacts, Merkuro Mail e Okular.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-16" src="https://github.com/user-attachments/assets/4bfb30cb-890d-4ecf-94c7-d122810c0175" />  

*Menu de aplicativos na categoria "Gráficos", exibindo Flameshot, Gwenview e Okular.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-23" src="https://github.com/user-attachments/assets/abaef84a-c2b3-44c5-a30c-103efc2f4de9" />  

*Menu de aplicativos na categoria "Internet", com Discord, Editor do Sieve, Exportador de dados PIM, Firefox, KMail, KTnef, Steam, Telegram e ZapZap.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-32" src="https://github.com/user-attachments/assets/be43b977-f1d6-461d-88e0-2a833f22f949" />  

*Menu de aplicativos na categoria "Jogos", listando Heroic Games Launcher, Lutris, ProtonPlus e Steam.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-42" src="https://github.com/user-attachments/assets/d4c53c45-ee3f-4d0f-8ea7-9a711c21d93a" />  

*Menu de aplicativos na categoria "Sistema", com btop++, Centro de Informações, Configurações do sistema, Dolphin, Editor de menus, Htop, Konsole e Monitor do sistema.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-17-50" src="https://github.com/user-attachments/assets/9118a526-ad92-40a7-9b93-3f71c3a20f89" />  

*Menu de aplicativos na categoria "Utilitários" (topo da lista), com Ark, Assistente de importação do KMail, Filelight, Flatseal, Gear Lever, Kate, KTnef, KWrite, Protontricks e Seletor de emoji.*  
___

<img width="675" height="591" alt="Captura de tela de 2026-09-06 01-18-00" src="https://github.com/user-attachments/assets/109d6775-8275-466f-920b-1632e282d7cf" />  

*Menu de aplicativos na categoria "Utilitários" (rolado para baixo), mostrando Flatseal, Gear Lever, Kate, KTnef, KWrite, Protontricks, Seletor de emoji, Spectacle, Vim e VSCodium.*  
___

---


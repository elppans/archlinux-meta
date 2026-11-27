#!/bin/bash

# libva-mesa-driver: em versões recentes do Arch, esse suporte a VA-API foi incorporado ao próprio mesa. Se o pacman reclamar que o pacote não existe, é por isso e basta removê-lo da lista. Dá para conferir com pacman -Si libva-mesa-driver.
# xf86-video-amdgpu e xf86-video-ati: na maioria dos casos nenhum dos dois é necessário. Se você usa GNOME ou KDE, especialmente em Wayland, pode tirá-los. Se for manter um, o amdgpu serve para placas modernas e o ati só para as bem antigas, então não precisa dos dois juntos.
# lib32-opencl-mesa é opcional, pois é o único dessa lista que dá para dispensar sem perda na maioria dos casos. Jogos e aplicativos 32 bits que dependem de OpenCL são bem raros.

pacotes=(
    # libva-mesa-driver   # Aceleração de decodificação/codificação de vídeo por hardware (VA-API) na GPU AMD; usado por navegadores, mpv, VLC, etc.
    mesa                  # Implementação open source de OpenGL (e base dos drivers de GPU); essencial para qualquer desktop gráfico
	lib32-mesa
    vulkan-radeon         # Driver Vulkan (RADV) para GPUs AMD Radeon; necessário para jogos via Proton/DXVK/VKD3D
    lib32-vulkan-radeon   # Driver Vulkan (RADV) de 32 bits para AMD; necessário para jogos 32 bits no Steam/Proton/Wine (requer o repositório multilib ativo)
    opencl-mesa           # Implementação OpenCL (Rusticl) do Mesa; permite usar a GPU AMD para computação em Blender, GIMP, Darktable, etc.
    lib32-opencl-mesa     # OpenCL de 32 bits; só é útil para programas 32 bits que usem OpenCL, então é opcional e raramente necessário
    xf86-video-amdgpu     # Driver DDX do Xorg para AMD moderna (GCN em diante); opcional, pois o driver "modesetting" embutido no Xorg já funciona bem
    xf86-video-ati        # Driver DDX do Xorg para Radeon antigas (pré-GCN); desnecessário em placas modernas
    xorg-server           # Servidor gráfico X11; necessário para sessões Xorg (não é preciso em sessão Wayland pura)
    xorg-xinit            # Fornece startx/xinit para iniciar o Xorg manualmente, sem gerenciador de login
)

sudo pacman --needed --noconfirm -S "${pacotes[@]}" --overwrite \*


#!/bin/bash

# Função para detectar se o sistema está em uma VM
detect_vm() {
    if command -v systemd-detect-virt &> /dev/null; then
        VM_TYPE=$(systemd-detect-virt)
        if [ "$VM_TYPE" != "none" ]; then
            echo "VM detectada: $VM_TYPE"
            return 0
        else
            echo "Nenhuma VM detectada (systemd-detect-virt)."
            return 1
        fi
    fi

    if command -v lscpu &> /dev/null; then
        if lscpu | grep -i -q hypervisor; then
            echo "VM detectada (lscpu)."
            return 0
        else
            echo "Nenhuma VM detectada (lscpu)."
            return 1
        fi
    fi

    if grep -i -q hypervisor /proc/cpuinfo; then
        echo "VM detectada (/proc/cpuinfo)."
        return 0
    else
        echo "Nenhuma VM detectada (/proc/cpuinfo)."
        return 1
    fi
}

# Função para detectar se o sistema usa NVIDIA
detect_nvidia() {
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA detectada."
        return 0
    else
        echo "NVIDIA não detectada."
        return 1
    fi
}

# Função para detectar se o sistema usa AMD
detect_amd() {
    if lspci | grep -i -q "VGA.*AMD"; then
        echo "AMD detectada."
        return 0
    else
        echo "AMD não detectada."
        return 1
    fi
}

# Função para detectar o ambiente gráfico (Plasma ou GNOME)
detect_desktop_environment() {
    if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "KDE Plasma" ]; then
        echo "Plasma detectado."
        return 0
    elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
        echo "GNOME detectado."
        return 1
    else
        echo "Ambiente gráfico não reconhecido."
        return 2
    fi
}

# Configurações gerais
export MOZ_ENABLE_WAYLAND=1 # Para Firefox no Wayland (suporte nativo ao Wayland)
export __GL_ExperimentalPerfStrategy=1 # Habilita estratégias experimentais de desempenho (geral)
export __GL_MaxFramesAllowed=1 # Limita o número de quadros renderizados (otimização de desempenho)
export GLX_SGI_video_sync=1 # Habilita sincronização de vídeo SGI (para OpenGL)
export GLX_OML_sync_control=1 # Habilita controle de sincronização OML (para OpenGL)

# Configurações para NVIDIA
if detect_nvidia; then
    export QT_QPA_PLATFORMTHEME=qt6ct # Define o tema da plataforma Qt para qt6ct (customização de temas)
    export QT_IM_MODULE=ibus # Usar IBus como módulo de entrada para Qt (suporte a métodos de entrada)
    export QT_AUTO_SCREEN_SCALE_FACTOR=1 # Habilita o ajuste automático de escala para telas de alta resolução
    export __GL_SYNC_TO_VBLANK=0 # Desativa a sincronização vertical (VSync) para melhorar desempenho
    export NV_PRIME_RENDER_OFFLOAD=1 # Habilita o offload de renderização para GPUs NVidia (otimização para laptops)
    export __GL_ExperimentalPerfStrategy=1 # Habilita estratégias experimentais de desempenho da NVidia
    export QSG_RENDERER_LOOP=basic # Necessário para evitar alto uso de CPU (renderização básica)
    export VK_LAYER_NV_optimus=NVIDIA_only # Força o uso da GPU NVidia em sistemas com Optimus
fi

# Configurações para AMD
if detect_amd; then
    export CLUTTER_BACKEND=wayland # Define o backend do Clutter como Wayland (para GPUs AMD)
    export SDL_VIDEODRIVER=wayland # Define o driver de vídeo SDL como Wayland (para GPUs AMD)
    export QT_QPA_PLATFORM=wayland # Define a plataforma Qt como Wayland (para GPUs AMD)
    export GBM_BACKEND=radeonsi # Define o backend GBM como radeonsi (para GPUs AMD)
    export LIBGL_ALWAYS_SOFTWARE=0 # Desativa a renderização por software (usa hardware AMD)
fi

# Configurações para KDE Plasma (Wayland)
if detect_desktop_environment; then
    export KWIN_DRM_FORM_EGL_STREAMS=1 # Melhora a compatibilidade com drivers EGL no Wayland
    # export KWIN_COMPOSE=0 # Desativado: causa problemas com Spectacle
fi

# Configurações para GNOME (Wayland)
if ! detect_desktop_environment; then
    export GDK_BACKEND=wayland # Usar o Wayland puro (para aplicativos GTK)
    # export __GL_SYNC_TO_VBLANK=0 # Desative o "Modo de Repouso" (VSync) para melhorar desempenho (Usar apenas se estiver enfrentando problemas específicos)
fi

# Configurações para máquinas virtuais
if detect_vm; then
    export QSG_RENDER_LOOP=basic # Evitar problemas de renderização em ambientes virtuais (renderização básica)
    export QT_QPA_PLATFORM=xcb # Usar XCB como backend gráfico (mais estável em VMs)

    case "$VM_TYPE" in
        "kvm" | "qemu")
            export QEMU_AUDIO_DRV=pa # Usar PipeWire (compatível com PulseAudio) (melhor compatibilidade)
            export QEMU_VGA=qxl # Usar driver QXL para gráficos (recomendado para SPICE)
            export SPICE_DEBUG_ALLOW_MC=1 # Permitir múltiplos clientes SPICE (para virtualização)
            export MESA_GL_VERSION_OVERRIDE=4.5 # Forçar versão do OpenGL (útil para compatibilidade)
            ;;
        "vmware")
            export VMWARE_USE_SHIPPED_GTK=1 # Usar GTK fornecido pelo VMWare (melhor integração)
            export SVGA_VGPU10=0 # Desativar aceleração 3D (útil para evitar bugs gráficos)
            export MESA_GL_VERSION_OVERRIDE=3.3 # Forçar versão do OpenGL (compatibilidade)
            ;;
        "oracle")
            export VBOX_GRAPHICS=1 # Habilitar aceleração gráfica (requer Guest Additions instalado)
            export VBOX_3D=1 # Habilitar suporte a 3D (requer Guest Additions e drivers corretos)
            export VBOX_VGA=std # Usar driver gráfico padrão (recomendado para compatibilidade)
            export MESA_GL_VERSION_OVERRIDE=3.1 # Forçar versão do OpenGL (compatibilidade)
            ;;
    esac

    # Configurações para renderização por software em VMs
    export LIBGL_ALWAYS_SOFTWARE=1 # Forçar renderização por software (útil para compatibilidade)
    export GALLIUM_DRIVER=llvmpipe # Usar o driver Gallium LLVMpipe (renderização por software)
    export CLUTTER_PAINT=disable-clipped-redraws:disable-culling # Desativar otimizações de renderização no Clutter
    export CLUTTER_VBLANK=none # Desativar sincronização vertical no Clutter
    export MOZ_ACCELERATED=0 # Desativar aceleração de hardware no Firefox (útil para evitar bugs)
    export MOZ_WEBRENDER=0 # Desativar o WebRender no Firefox (renderização por software)
    export QT_XCB_FORCE_SOFTWARE_OPENGL=1 # Forçar o uso de OpenGL por software no Qt (compatibilidade)
    export GNOME_DISABLE_HW_ACCEL=1 # Desativar aceleração de hardware no Gnome (útil para evitar problemas gráficos)
    # export GDK_BACKEND=wayland,x11 # Usar Wayland com fallback para Xwayland (útil para compatibilidade em VMs)
    export __GL_SYNC_TO_VBLANK=0 # Desative o "Modo de Repouso" (VSync) para melhorar desempenho
fi

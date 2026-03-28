function purge-karabiner
    # Primero matar kanata para evitar que el teclado se quede trabado
    echo "Deteniendo kanata..."
    sudo pkill kanata 2>/dev/null || echo "  kanata no estaba corriendo"

    echo "Desactivando driver de Karabiner-VirtualHIDDevice..."
    bash '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/deactivate_driver.sh' 2>/dev/null || echo "  Driver no activo o ya desactivado"

    echo "Eliminando archivos de Karabiner-VirtualHIDDevice..."
    sudo bash '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/scripts/uninstall/remove_files.sh'

    echo "Deteniendo daemon..."
    sudo killall Karabiner-VirtualHIDDevice-Daemon 2>/dev/null || echo "  Daemon no estaba corriendo"

    # Detener y eliminar servicio launchd
    set PLIST "/Library/LaunchDaemons/org.pqrs.karabiner.virtualhiddevice-daemon.plist"
    if test -f $PLIST
        echo "Deteniendo servicio launchd..."
        sudo launchctl unload $PLIST 2>/dev/null || true
        sudo rm -f $PLIST
    end

    # También eliminar sudoers si existe
    set SUDOERS_FILE "/etc/sudoers.d/kanata-"(whoami)
    if test -f $SUDOERS_FILE
        echo "Eliminando configuración sudoers..."
        sudo rm -f $SUDOERS_FILE
    end

    # Limpiar script de chezmoi si existe
    set CHEZMOI_SCRIPT "$HOME/.local/share/chezmoi/.chezmoiscripts/run_after_10_setup-kanata-launchd.sh.tmpl"
    if test -f $CHEZMOI_SCRIPT
        echo "Eliminando script de configuración de chezmoi..."
        rm -f $CHEZMOI_SCRIPT
    end

    # Limpiar directorios temporales y caché
    echo "Limpiando directorios temporales..."
    sudo rm -rf "/Library/Application Support/org.pqrs/tmp" 2>/dev/null || true
    sudo rm -rf "/Library/Caches/org.pqrs.Karabiner-DriverKit-VirtualHIDDevice" 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/org.pqrs.Karabiner-DriverKit-VirtualHIDDevice" 2>/dev/null || true

    echo "✓ Karabiner-VirtualHIDDevice desinstalado"
end

#!/bin/bash
#
# Script para limpiar DATOS, CONFIGURACIONES y CACHES de aplicaciones
# NO desinstala las apps, solo limpia su data para "resetearlas"
#
# Útil para:
# - Resetear configuraciones de una app sin reinstalarla
# - Limpiar caches y liberar espacio
# - Resolver problemas de apps que se comportan mal
#

# ============================================================
# LIMPIAR DATA DE UNA APP ESPECÍFICA
# ============================================================
clean-app-data() {
    if [ -z "$1" ]; then
        echo -e "\n\033[1;31mERROR:\033[0m Debes proporcionar el nombre de la aplicación."
        echo "Uso: clean-app-data \"NombreApp\""
        echo "Ejemplo: clean-app-data \"Discord\"
        return 1
    fi

    local APP_NAME="$1"
    local APP_PATH="/Applications/${APP_NAME}.app"
    
    echo -e "\n\033[1;33m⚠️  ADVERTENCIA:\033[0m Esto eliminará TODA la data de '${APP_NAME}'."
    echo "Esto incluye:"
    echo "  • ❌ Configuraciones y preferencias"
    echo "  • ❌ Caches y datos locales"
    echo "  • ❌ Datos guardados y sesiones"
    echo "  • ❌ Logs"
    echo "  • ✅ La app NO se desinstala (solo se limpia)"
    echo ""
    echo "💡 Es como 'resetear a valores de fábrica' la app."
    echo ""
    echo -n "¿Continuar? (escribe 'yes' para confirmar): "
    read CONFIRM

    if [[ "$CONFIRM" != "yes" ]]; then
        echo -e "\n\033[1;32m✅ Operación cancelada.\033[0m"
        return 0
    fi

    echo -e "\n\033[1;34m🧹 Limpiando data de '${APP_NAME}'...\033[0m"

    # Cerrar la aplicación si está corriendo
    echo "   → Cerrando la aplicación..."
    pkill -9 "${APP_NAME}" 2>/dev/null || true
    osascript -e "quit app \"${APP_NAME}\"" 2>/dev/null || true
    sleep 1

    # Obtener Bundle ID si existe
    local APP_BUNDLE_ID=""
    if [ -d "$APP_PATH" ]; then
        APP_BUNDLE_ID=$(defaults read "${APP_PATH}/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "")
    fi

    # Patrones de búsqueda
    local SEARCH_PATTERN="${APP_NAME// /}"
    local SEARCH_PATTERN_LOWER=$(echo "$SEARCH_PATTERN" | tr '[:upper:]' '[:lower:]')

    echo "   → Limpiando archivos en ~/Library..."

    # Directorios a limpiar
    local DIRS_TO_CLEAN=(
        "$HOME/Library/Application Support"
        "$HOME/Library/Caches"
        "$HOME/Library/Preferences"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/Logs"
        "$HOME/Library/WebKit"
        "$HOME/Library/Cookies"
        "$HOME/Library/HTTPStorages"
        "$HOME/Library/Group Containers"
        "$HOME/Library/Containers"
    )

    local FILES_DELETED=0

    # Buscar y eliminar archivos relacionados
    for DIR in "${DIRS_TO_CLEAN[@]}"; do
        if [ -d "$DIR" ]; then
            # Por nombre de app
            while IFS= read -r file; do
                if [ -n "$file" ]; then
                    echo "      • Eliminando: $(basename "$file")"
                    rm -rf "$file"
                    ((FILES_DELETED++))
                fi
            done < <(find "$DIR" -maxdepth 1 -iname "*${SEARCH_PATTERN_LOWER}*" 2>/dev/null)
            
            # Por Bundle ID
            if [ -n "$APP_BUNDLE_ID" ]; then
                while IFS= read -r file; do
                    if [ -n "$file" ]; then
                        echo "      • Eliminando: $(basename "$file")"
                        rm -rf "$file"
                        ((FILES_DELETED++))
                    fi
                done < <(find "$DIR" -maxdepth 1 -iname "*${APP_BUNDLE_ID}*" 2>/dev/null)
            fi
        fi
    done

    echo -e "\n\033[1;32m✅ Data de '${APP_NAME}' limpiada.\033[0m"
    echo "   📊 Archivos/carpetas eliminados: $FILES_DELETED"
    echo ""
    echo "💡 La próxima vez que abras la app, iniciará con configuración limpia."
}

# ============================================================
# LIMPIAR DATA DE TODAS LAS APPS (NUCLEAR)
# ============================================================
clean-all-app-data() {
    echo -e "\n\033[1;31m🚨 LIMPIEZA NUCLEAR DE DATA 🚨\033[0m"
    echo -e "\033[1;31m═══════════════════════════════════════════════════════════\033[0m"
    echo ""
    echo "Esto eliminará TODA la data de TODAS las aplicaciones:"
    echo ""
    echo "  🗑️  Todos los archivos en ~/Library/Application Support/"
    echo "  🗑️  Todos los archivos en ~/Library/Caches/"
    echo "  🗑️  Todas las preferencias en ~/Library/Preferences/"
    echo "  🗑️  Todos los estados guardados"
    echo "  🗑️  Todos los logs"
    echo "  🗑️  Todos los containers"
    echo ""
    echo -e "\033[1;33m⚠️  Las APLICACIONES NO se desinstalan\033[0m"
    echo "Solo se limpia su data. Es como 'resetear a fábrica' todas las apps."
    echo ""
    echo -e "\033[1;31m═══════════════════════════════════════════════════════════\033[0m"
    echo ""
    echo -n "Para continuar, escribe 'CLEAN ALL DATA': "
    read CONFIRM

    if [[ "$CONFIRM" != "CLEAN ALL DATA" ]]; then
        echo -e "\n\033[1;32m✅ Operación cancelada.\033[0m"
        return 0
    fi

    echo -e "\n\033[1;34m🧹 Limpiando toda la data de aplicaciones...\033[0m"

    # Cerrar todas las apps
    echo "   → Cerrando todas las aplicaciones..."
    osascript -e 'tell application "System Events" to set quitApps to name of every application process whose visible is true and name is not "Finder" and name is not "Terminal" and name is not "iTerm"' 2>/dev/null
    osascript -e 'repeat with appName in quitApps
        try
            tell application appName to quit
        end try
    end repeat' 2>/dev/null || true
    
    sleep 2

    # Directorios a limpiar COMPLETAMENTE
    local DIRS_TO_NUKE=(
        "$HOME/Library/Application Support"
        "$HOME/Library/Caches"
        "$HOME/Library/Preferences"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/Logs"
        "$HOME/Library/WebKit"
        "$HOME/Library/Cookies"
        "$HOME/Library/HTTPStorages"
        "$HOME/Library/Group Containers"
        "$HOME/Library/Containers"
    )

    local TOTAL_SIZE_BEFORE=0
    local TOTAL_SIZE_AFTER=0

    # Calcular tamaño antes
    for DIR in "${DIRS_TO_NUKE[@]}"; do
        if [ -d "$DIR" ]; then
            SIZE=$(du -sh "$DIR" 2>/dev/null | awk '{print $1}')
            echo "   📊 $DIR: $SIZE"
        fi
    done

    echo ""
    echo -n "¿REALMENTE quieres limpiar TODO? Última oportunidad (yes/no): "
    read FINAL_CONFIRM

    if [[ "$FINAL_CONFIRM" != "yes" ]]; then
        echo -e "\n\033[1;32m✅ Operación cancelada.\033[0m"
        return 0
    fi

    # Limpiar todo (excepto archivos de Apple)
    for DIR in "${DIRS_TO_NUKE[@]}"; do
        if [ -d "$DIR" ]; then
            echo "   → Limpiando: $DIR"
            # Eliminar todo EXCEPTO archivos que empiecen con "com.apple."
            find "$DIR" -mindepth 1 -maxdepth 1 -not -iname "com.apple.*" -exec rm -rf {} \; 2>/dev/null || true
        fi
    done

    echo -e "\n\033[1;32m═══════════════════════════════════════════════════════════\033[0m"
    echo -e "\033[1;32m✅ LIMPIEZA COMPLETADA\033[0m"
    echo -e "\033[1;32m═══════════════════════════════════════════════════════════\033[0m"
    echo ""
    echo "Todas las apps han sido 'reseteadas a fábrica'."
    echo "Las aplicaciones siguen instaladas, pero sin data."
    echo ""
    echo "💡 Al abrir cada app, pedirán configuración inicial."
}

# ============================================================
# VER DATA DE UNA APP (sin eliminar)
# ============================================================
show-app-data() {
    if [ -z "$1" ]; then
        echo "Uso: show-app-data \"NombreApp\""
        return 1
    fi

    local APP_NAME="$1"
    local SEARCH_PATTERN=$(echo "${APP_NAME// /}" | tr '[:upper:]' '[:lower:]')

    echo -e "\n\033[1;34m🔍 Data de '${APP_NAME}':\033[0m\n"

    # Directorios a buscar
    local DIRS=(
        "$HOME/Library/Application Support"
        "$HOME/Library/Caches"
        "$HOME/Library/Preferences"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/Logs"
        "$HOME/Library/Containers"
    )

    local TOTAL_SIZE=0
    local FILES_FOUND=0

    for DIR in "${DIRS[@]}"; do
        if [ -d "$DIR" ]; then
            echo "📂 $(basename "$DIR"):"
            
            while IFS= read -r file; do
                if [ -n "$file" ]; then
                    SIZE=$(du -sh "$file" 2>/dev/null | awk '{print $1}')
                    echo "   • $(basename "$file") - $SIZE"
                    ((FILES_FOUND++))
                fi
            done < <(find "$DIR" -maxdepth 1 -iname "*${SEARCH_PATTERN}*" 2>/dev/null)
            
            echo ""
        fi
    done

    if [ $FILES_FOUND -eq 0 ]; then
        echo "   (No se encontró data para esta app)"
    else
        echo "✅ Total de archivos/carpetas encontrados: $FILES_FOUND"
    fi
}

# ============================================================
# CALCULAR ESPACIO OCUPADO POR DATA DE APPS
# ============================================================
calculate-app-data-size() {
    echo -e "\n\033[1;34m📊 Calculando espacio ocupado por data de apps...\033[0m\n"

    local DIRS=(
        "$HOME/Library/Application Support"
        "$HOME/Library/Caches"
        "$HOME/Library/Preferences"
        "$HOME/Library/Saved Application State"
        "$HOME/Library/Logs"
        "$HOME/Library/Containers"
        "$HOME/Library/Group Containers"
    )

    local TOTAL=0

    for DIR in "${DIRS[@]}"; do
        if [ -d "$DIR" ]; then
            SIZE=$(du -sh "$DIR" 2>/dev/null | awk '{print $1}')
            echo "   $(basename "$DIR"): $SIZE"
        fi
    done

    echo ""
    TOTAL=$(du -sh "$HOME/Library" 2>/dev/null | awk '{print $1}')
    echo "📦 Total en ~/Library: $TOTAL"
    echo ""
    echo "💡 Para limpiar todo: clean-all-app-data"
}

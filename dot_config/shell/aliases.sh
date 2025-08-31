alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias v="nvim"
alias zsource='source ~/.zshrc'
alias gdu='gdu-go'

alias ls="eza -l --icons=always -m -n -l"
alias l="eza -l --icons=always -m -n -l -a"
alias ll="eza -l --icons=always -m -n -l"

alias dbb="flutter clean && dart run build_runner build -d"
alias dbw="flutter clean && dart run build_runner watch -d"

alias mkdir='mkdir -pv'

alias Applications='cd $HOME/Applications'
alias Cloud='cd $HOME/Cloud'
alias Config='cd $HOME/.config'
alias Desktop='cd $HOME/Desktop'
alias Downloads='cd $HOME/Downloads'
alias Library='cd $HOME/Library'
alias Local='cd $HOME/.local'
alias Movies='cd $HOME/Movies'
alias Music='cd $HOME/Music'
alias Pictures='cd $HOME/Pictures'
alias Public='cd $HOME/Public'

dgrep() {
	als | grep "$@"
}

purge-all-mobile-dev-cache() {
	echo -e "\n\033[1;33mINFO:\033[0m Esta acción eliminará directamente las carpetas de caché de desarrollo nativo y de frameworks."
	echo "Se limpiarán carpetas de Android (Gradle), iOS (Xcode), Node.js (npm/yarn), React Native, Expo y Flutter."
	echo "Tus proyectos, SDKs y configuraciones principales NO serán eliminados."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nEliminando carpetas de caché de desarrollo móvil..."

		# --- Limpieza de Caché Nativa ANDROID ---
		echo "Limpiando carpetas de caché de Gradle y Android Studio..."
		rm -rf ~/.gradle/caches
		rm -rf ~/.gradle/wrapper/dists
		rm -rf ~/.cache/Google/AndroidStudio*

		# --- Limpieza de Caché Nativa iOS/Xcode (solo en macOS) ---
		if [[ "$(uname)" == "Darwin" ]]; then
			echo "Limpiando carpetas de caché de Xcode (DerivedData, Archives)..."
			rm -rf ~/Library/Developer/Xcode/DerivedData/
			rm -rf ~/Library/Developer/Xcode/Archives/
			rm -rf ~/Library/Caches/com.apple.dt.Xcode/
			rm -rf ~/Library/Caches/org.swift.swiftpm/
		fi

		# --- Limpieza de Carpetas de Caché de Frameworks ---

		# Caché de Node.js (npm y Yarn)
		echo "Eliminando carpetas de caché de npm y Yarn..."
		rm -rf ~/.npm/_cacache
		rm -rf ~/.npm/_logs
		if [[ "$(uname)" == "Darwin" ]]; then
			rm -rf ~/Library/Caches/Yarn
		else # Asumiendo Linux
			rm -rf ~/.cache/yarn
		fi

		# Caché específica de React Native
		echo "Eliminando carpetas de caché de React Native (Metro)..."
		rm -rf $TMPDIR/react-*
		rm -rf $TMPDIR/metro-*
		rm -rf $TMPDIR/haste-map-*

		# --- NUEVO: Caché específica de Expo ---
		echo "Eliminando carpetas de caché de Expo y EAS CLI..."
		rm -rf ~/.expo           # Caché principal de Expo CLI, logs y datos de sesión
		rm -rf ~/.cache/expo     # Ubicación de caché común en sistemas Linux
		rm -rf ~/.config/eas-cli # Caché y configuración de EAS CLI

		# Caché específica de Flutter
		echo "Eliminando carpetas de caché de Flutter..."
		if [[ "$(uname)" == "Darwin" ]]; then # macOS
			rm -rf ~/.pub-cache
		else # Linux
			rm -rf ~/.cache/dart
			rm -rf ~/.pub-cache
		fi

		echo -e "\n\033[1;32m¡Limpieza de carpetas de caché completada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

purge-config() {
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará completamente la carpeta ~/.config, así como los archivos ~/.zshrc, ~/.bashrc, ~/.tmux y ~/.tmux.conf."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nEliminando la carpeta ~/.config y archivos de configuración..."
		rm -rf ~/.config ~/.zshrc ~/.bashrc ~/.tmux ~/.tmux.conf ~/.oh-my-zsh ~/.zprofile ~/.zsh_history
		echo -e "\n\033[1;32m¡Carpeta ~/.config y archivos de configuración eliminados!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

mise-purge-all() {
	echo -e "\n\033[1;31mADVERTENCIA:\033[0m Esta acción eliminará todas las herramientas gestionadas por mise y la carpeta ~/.local/share/mise."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo -e "\nProcediendo con la eliminación de herramientas gestionadas por mise..."
		if command -v mise &>/dev/null && command -v jq &>/dev/null; then
			TOOLS_JSON=$(mise list --json 2>/dev/null)
			if [[ $? -eq 0 ]]; then
				TOOLS=$(echo "$TOOLS_JSON" | jq -r '.[] | .plugin + "/" + .version' 2>/dev/null)
				if [[ $? -eq 0 && -n "$TOOLS" ]]; then
					echo -e "\nHerramientas instaladas con mise:"
					echo "$TOOLS"
				else
					echo "No hay herramientas instaladas con mise."
				fi
			else
				echo "No hay herramientas instaladas con mise."
			fi
		else
			echo "No se pudo verificar herramientas instaladas (falta 'mise' o 'jq')."
		fi
		echo -e "\nEliminando la carpeta ~/.local/share/mise..."
		rm -rf ~/.local/share/mise
		echo -e "\n\033[1;32m¡Carpeta eliminada!\033[0m"
	else
		echo -e "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

brew-purge-formula() {
	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las fórmulas (paquetes) instaladas con Homebrew."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de fórmulas..."
		echo "\n\033[1;33m=> Desinstalando Fórmulas...\033[0m"
		if brew list --formula &>/dev/null; then
			brew remove --force --ignore-dependencies $(brew list --formula)
		else
			echo "No hay fórmulas para desinstalar."
		fi
		echo "\n\033[1;32m¡Proceso completado!\033[0m"
		echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

brew-purge-cask() {
	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODOS los casks (aplicaciones) instalados con Homebrew."
	echo "Esta acción no se puede deshacer."
	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM
	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de casks..."
		echo "\n\033[1;33m=> Desinstalando Casks (Aplicaciones)...\033[0m"
		if brew list --cask &>/dev/null; then
			brew uninstall --cask --force --ignore-dependencies $(brew list --cask)
		else
			echo "No hay casks para desinstalar."
		fi
		echo "\n\033[1;32m¡Proceso completado!\033[0m"
		echo "Se recomienda ejecutar 'brew cleanup' para borrar archivos en caché."
	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado nada."
	fi
}

mas-purge-all() {
	if ! command -v mas &>/dev/null; then
		echo "\n\033[1;31mError:\033[0m El comando 'mas' no está instalado."
		echo "Por favor, instálalo con 'brew install mas' y vuelve a intentarlo."
		return 1
	fi

	echo "\n\033[1;31mADVERTENCIA:\033[0m Estás a punto de eliminar TODAS las aplicaciones instaladas desde la Mac App Store (Pages, Numbers, etc.)."
	echo "Esta acción no se puede deshacer."

	echo -n "¿Estás seguro de que quieres continuar? (escribe 'si' para confirmar): "
	read CONFIRM

	if [[ "$CONFIRM" == "si" ]]; then
		echo "\nProcediendo con la eliminación de aplicaciones de la App Store..."

		if mas list &>/dev/null; then
			mas list | awk '{print $1}' | xargs -n 1 mas uninstall
			echo "\n\033[1;32m¡Proceso completado!\033[0m"
		else
			echo "No hay aplicaciones de la Mac App Store para desinstalar."
		fi

	else
		echo "\n\033[1;32mOperación cancelada.\033[0m No se ha eliminado ninguna aplicación."
	fi
}

create-emulator() {
    # Check if SDK tools exist
    if ! command -v sdkmanager &>/dev/null || ! command -v avdmanager &>/dev/null; then
        echo "❌ Error: Android SDK command-line tools not found."
        echo "   Make sure the tools are in your \$PATH."
        return 1
    fi

    # --- STEP 1: SELECT SYSTEM IMAGE ---
    echo "➡️  Step 1: Choose a system image."
    local -a system_images
    system_images=(${(f)"$(sdkmanager --list | grep system-images | cut -d'|' -f1 | sed 's/^[ \t]*//;s/[ \t]*$//' | uniq)"})
    if [ ${#system_images[@]} -eq 0 ]; then
        echo "❌ No system images found."
        return 1
    fi
    PS3="   Please choose a number: "
    select selected_image in "${system_images[@]}"; do
        if [[ -n "$selected_image" ]]; then
            echo "   You selected: $selected_image"
            break
        else
            echo "   Invalid option."
        fi
    done
    echo "   Installing '$selected_image' if necessary..."
    sdkmanager "$selected_image"
    echo "---"

    # --- STEP 2: SELECT DEVICE (USING ID) ---
    echo "➡️  Step 2: Choose a device profile."
    local -a device_ids device_names
    while IFS= read -r line; do
        if [[ "$line" =~ 'id: '([0-9]+)' or "'(.*)'"' ]]; then
            device_ids+=("$match[1]")
        elif [[ "$line" =~ 'Name: '(.*) ]]; then
            device_names+=("$match[1]")
        fi
    done < <(avdmanager list device)
    if [ ${#device_names[@]} -eq 0 ]; then
        echo "❌ No device profiles found."
        return 1
    fi
    local selected_device_id
    select device_display_name in "${device_names[@]}"; do
        if [[ -n "$device_display_name" ]]; then
            selected_device_id=${device_ids[$REPLY]}
            echo "   You selected: $device_display_name (ID: $selected_device_id)"
            break
        else
            echo "   Invalid option."
        fi
    done
    echo "---"

    # --- STEP 3: NAME THE EMULATOR ---
    local avd_name
    echo "➡️  Step 3: Give your new emulator a name."
    read "avd_name?   Name (e.g., Pixel_Test_API31): "
    while [[ -z "$avd_name" ]]; do
        echo "   The name cannot be empty."
        read "avd_name?   Name (e.g., Pixel_Test_API31): "
    done
    echo "---"

    # --- STEP 4: CREATE AND LAUNCH ---
    echo "⏳ Creating emulator '$avd_name' with device ID '$selected_device_id'..."
    echo "no" | avdmanager create avd --name "$avd_name" --package "$selected_image" --device "$selected_device_id" --force
    
    if [ $? -eq 0 ]; then
        echo "✅ Emulator '$avd_name' created successfully!"
        read "launch_now?   Do you want to launch it now? (y/n): "
        if [[ "$launch_now" =~ ^[Yy]$ ]]; then
            echo "🚀 Launching '$avd_name' in the background..."
            nohup emulator @"$avd_name" > /dev/null 2>&1 &
        else
            echo "👍 Okay. You can launch it later with: launch-emulator"
        fi
    else
        echo "❌ An error occurred while creating the emulator."
    fi

    return 0
}

launch-emulator() {
    # Check if 'emulator' command exists
    if ! command -v emulator &>/dev/null; then
        echo "❌ Error: 'emulator' command not found."
        echo "   Make sure the Android SDK tools are in your \$PATH."
        return 1
    fi
    
    echo "➡️  Looking for available emulators..."
    
    # Get the list of AVDs and store it in an array
    local -a avds
    avds=(${(f)"$(emulator -list-avds)"})
    
    # Check if any emulators exist
    if [ ${#avds[@]} -eq 0 ]; then
        echo "❌ No emulators found."
        echo "   You can create a new one with the 'create-emulator' command."
        return 1
    fi
    
    # Create the interactive selection menu
    local avd_name
    PS3="   Choose the emulator you want to launch: "
    select avd_name in "${avds[@]}"; do
        if [[ -n "$avd_name" ]]; then
            echo "🚀 Launching '$avd_name' in the background..."
            # Execute in the background, detached from the terminal
            nohup emulator @"$avd_name" > /dev/null 2>&1 &
            break
        else
            echo "   Invalid option. Please try again."
        fi
    done

    return 0
}

delete-emulator() {
    if ! command -v emulator &>/dev/null; then
        echo "❌ Error: 'emulator' command not found."
        return 1
    fi

    echo "➡️  Looking for available emulators..."
    local -a avds
    avds=(${(f)"$(emulator -list-avds)"})

    if [ ${#avds[@]} -eq 0 ]; then
        echo "❌ No emulators found to delete."
        return 1
    fi

    local avd_name
    PS3="   Choose the emulator you want to DELETE: "
    select avd_name in "${avds[@]}"; do
        if [[ -n "$avd_name" ]]; then
            echo "⚠️  Warning! You are about to permanently delete the emulator '$avd_name'."
            local confirm
            read "confirm?Are you sure? This action cannot be undone. (yes/no): "

            if [[ "$confirm" =~ ^[Yy]([Ee][Ss])?$ ]]; then
                echo "🗑️  Deleting '$avd_name'..."
                avdmanager delete avd -n "$avd_name"
                echo "✅ Emulator '$avd_name' successfully deleted."
            else
                echo "👍 Deletion aborted."
            fi
            break
        else
            echo "   Invalid option. Please try again."
        fi
    done

    return 0
}

# ==========================================================
#  FUNCTION TO UNINSTALL INSTALLED SYSTEM-IMAGES
# ==========================================================
delete-system-image() {
    if ! command -v sdkmanager &>/dev/null; then
        echo "❌ Error: 'sdkmanager' command not found."
        return 1
    fi
    
    echo "➡️  Looking for installed system-images..."
    local -a installed_images
    # We use --list_installed to see only the ones we already have
    installed_images=(${(f)"$(sdkmanager --list_installed | grep system-images | cut -d'|' -f1 | sed 's/^[ \t]*//;s/[ \t]*$//')"})
    
    if [ ${#installed_images[@]} -eq 0 ]; then
        echo "✅ No installed system-images found."
        return 0
    fi
    
    local image_path
    PS3="   Choose the system-image you want to UNINSTALL: "
    select image_path in "${installed_images[@]}"; do
        if [[ -n "$image_path" ]]; then
            echo "⚠️  Warning! You are about to uninstall the image '$image_path'."
            local confirm
            read "confirm?Are you sure? (yes/no): "
            
            if [[ "$confirm" =~ ^[Yy]([Ee][Ss])?$ ]]; then
                echo "🗑️  Uninstalling '$image_path'..."
                sdkmanager --uninstall "$image_path"
                echo "✅ Image successfully uninstalled."
            else
                echo "👍 Uninstall aborted."
            fi
            break
        else
            echo "   Invalid option. Please try again."
        fi
    done

    return 0
}

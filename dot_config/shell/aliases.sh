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
        echo "    Make sure the tools are in your \$PATH."
        return 1
    fi

    # --- STEP 0: PRE-CONFIGURATION ---
    local arch_filter device_type_filter

    echo "➡️  Step 0: Let's configure your new emulator."
    PS3="    Please choose the CPU architecture (Intel is faster on most PCs): "
    select arch_choice in "Intel (x86_64)" "ARM (arm64-v8a)"; do
        if [[ "$arch_choice" == "Intel (x86_64)" ]]; then
            arch_filter="x86_64"
            break
        elif [[ "$arch_choice" == "ARM (arm64-v8a)" ]]; then
            arch_filter="arm64-v8a"
            break
        else
            echo "    Invalid option. Try again."
        fi
    done

    PS3="    What type of device do you want to create? "
    select device_type_choice in "Phone" "Tablet"; do
        if [[ -n "$device_type_choice" ]]; then
            device_type_filter="$device_type_choice"
            break
        else
            echo "    Invalid option. Try again."
        fi
    done
    echo "---"

    # --- STEP 1: SELECT SYSTEM IMAGE (FILTERED & SEPARATED) ---
    echo "➡️  Step 1: Choose a system image (filtered for '$arch_filter' and '$device_type_filter')."
    
    local sdk_list_output
    sdk_list_output=$(sdkmanager --list --verbose 2>/dev/null)
    local installed_block=$(echo "$sdk_list_output" | sed -n '/Installed packages:/,/Available Packages:/p')
    local available_block=$(echo "$sdk_list_output" | sed -n '/Available Packages:/,$p')

    filter_image_list() {
        local input_list=$1
        echo "$input_list" | awk '/^[[:space:]]*system-images;/ && /google_apis_playstore/ && !/ext/ && !/Baklava/ && !/ps16k/ {print $1}' \
            | grep "$arch_filter" \
            | if [[ "$device_type_filter" == "Tablet" ]]; then grep "tablet"; else grep -v "tablet"; fi \
            | sort -Vr | uniq
    }

    local -a installed_images=(${(f)"$(filter_image_list "$installed_block")"})
    local -a available_images=(${(f)"$(filter_image_list "$available_block")"})

    # ✅ --- NUEVO FILTRO PARA ELIMINAR DUPLICADOS ---
    # Crea una nueva lista de "disponibles" que excluye las que ya están instaladas.
    local -a unique_available_images
    for img in "${available_images[@]}"; do
        # El operador (Ie) de Zsh busca si el elemento existe en el array.
        # Si no (!) existe, lo añadimos a la lista de únicos.
        if (( ! ${installed_images[(Ie)$img]} )); then
            unique_available_images+=("$img")
        fi
    done
    # Reemplaza la lista original de disponibles con la lista ya filtrada.
    available_images=("${unique_available_images[@]}")
    # ✅ --- FIN DEL FILTRO ---

    format_image_name_zsh() {
        local path=$1
        local temp=${path#*android-}
        echo "Android API ${temp%%;*} (${path##*;})"
    }

    local -a all_images=("${installed_images[@]}" "${available_images[@]}")

    if [ ${#all_images[@]} -eq 0 ]; then
        echo "❌ No system images found with the selected criteria."
        return 1
    fi

    local counter=1
    if [ ${#installed_images[@]} -gt 0 ]; then
        echo "--- INSTALLED (Ready to use) ---"
        for img in "${installed_images[@]}"; do
            echo "  $counter) $(format_image_name_zsh "$img")"
            ((counter++))
        done
    fi
    if [ ${#available_images[@]} -gt 0 ]; then
        echo "--- AVAILABLE (Will be downloaded) ---"
        for img in "${available_images[@]}"; do
            echo "  $counter) $(format_image_name_zsh "$img")"
            ((counter++))
        done
    fi

    local choice
    local selected_image
    while true; do
        read "choice?    Please choose a number: "
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#all_images[@]} )); then
            selected_image=${all_images[$choice]}
            echo "    You selected: $(format_image_name_zsh "$selected_image") ($selected_image)"
            break
        else
            echo "    Invalid option. Please enter a number between 1 and ${#all_images[@]}."
        fi
    done
    
    echo "    Installing '$selected_image' if necessary..."
    yes | sdkmanager "$selected_image" > /dev/null
    echo "---"

    # --- STEP 2: SELECT DEVICE (FILTERED) ---
    echo "➡️  Step 2: Choose a device profile (filtered for '$device_type_filter')."
    local -a device_ids device_names
    local current_id current_name

    while IFS= read -r line; do
        if [[ "$line" =~ 'id: '([0-9]+)' or "'(.*)'"' ]]; then
            current_id=$match[1]
            current_name=""
        elif [[ "$line" =~ 'Name: '(.*) ]]; then
            current_name=$match[1]
            local is_match=0
            if [[ "$device_type_filter" == "Tablet" ]]; then
                if [[ "$current_name" == *"Tablet"* || "$current_name" == *"Fold"* ]]; then
                    is_match=1
                fi
            else
                if [[ "$current_name" != *"Tablet"* && "$current_name" != *"Fold"* && "$current_name" != *"TV"* && "$current_name" != *"Wear"* && "$current_name" != *"Automotive"* ]]; then
                    is_match=1
                fi
            fi
            if [[ $is_match -eq 1 ]]; then
                device_ids+=("$current_id")
                device_names+=("$current_name")
            fi
        fi
    done < <(avdmanager list device)

    if [ ${#device_names[@]} -eq 0 ]; then
        echo "❌ No device profiles found for the selected type."
        return 1
    fi

    local selected_device_id device_display_name
    select device_display_name in "${device_names[@]}"; do
        if [[ -n "$device_display_name" ]]; then
            selected_device_id=${device_ids[$REPLY]}
            echo "    You selected: $device_display_name (ID: $selected_device_id)"
            break
        else
            echo "    Invalid option."
        fi
    done
    echo "---"

    # --- STEP 3: NAME THE EMULATOR (WITH SUGGESTION) ---
    local avd_name
    echo "➡️  Step 3: Give your new emulator a name."

    local temp_api=${selected_image#*android-}
    local api_level=${temp_api%%;*}
    
    local device_name_sanitized=$(echo "$device_display_name" | tr ' ' '_')
    local suggested_name="${device_name_sanitized}_API${api_level}_${arch_filter}"
    echo "    Suggested name: $suggested_name"

    read "avd_name?    Name: "
    if [[ -z "$avd_name" ]]; then
        avd_name="$suggested_name"
        echo "    Using suggested name: $avd_name"
    fi
    echo "---"

    # --- STEP 4: CREATE AND LAUNCH ---
    echo "⏳ Creating emulator '$avd_name'..."
    echo "no" | avdmanager create avd --name "$avd_name" --package "$selected_image" --device "$selected_device_id" --force
    
    if [ $? -eq 0 ]; then
        echo "✅ Emulator '$avd_name' created successfully!"
        read "launch_now?    Do you want to launch it now? (y/n): "
        if [[ "$launch_now" =~ ^[Yy]$ ]]; then
            echo "🚀 Launching '$avd_name' in the background..."
            nohup emulator @"$avd_name" > /dev/null 2>&1 &
        else
            echo "👍 Okay. You can launch it later with 'emulator @$avd_name'"
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

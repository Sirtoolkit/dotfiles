new-avd() {
	  # Check if SDK tools exist
    if ! command -v sdkmanager &>/dev/null || ! command -v avdmanager &>/dev/null; then
        echo "❌ Error: Android SDK command-line tools not found."
        echo "    Make sure: tools are in your \$PATH."
        return 1
    fi

    # Check if fzf command exists
    if ! command -v fzf &>/dev/null; then
        echo "❌ Error: 'fzf' command not found."
        echo "   Make sure fzf is installed and in your \$PATH."
        echo "   Install with: brew install fzf"
        return 1
    fi

    # --- STEP 0: PRE-CONFIGURATION ---
    local arch_filter device_type_filter

    echo "➡️  Step 0: Let\'s configure your new emulator."
    
    # Use fzf to select CPU architecture
    local arch_choice
    arch_choice=$(printf "Intel (x86_64)\nARM (arm64-v8a)\n" | fzf --prompt="Select CPU architecture (Intel is faster on most PCs): " --height=8 --border)
    
    if [[ -z "$arch_choice" ]]; then
        echo "❌ No architecture selected."
        return 1
    fi
    
    if [[ "$arch_choice" == "Intel (x86_64)" ]]; then
        arch_filter="x86_64"
    elif [[ "$arch_choice" == "ARM (arm64-v8a)" ]]; then
        arch_filter="arm64-v8a"
    fi

    # Use fzf to select device type
    local device_type_choice
    device_type_choice=$(printf "Phone\nTablet\n" | fzf --prompt="What type of device do you want to create? " --height=8 --border)
    
    if [[ -z "$device_type_choice" ]]; then
        echo "❌ No device type selected."
        return 1
    fi
    
    device_type_filter="$device_type_choice"
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
            | ( if [[ "$device_type_filter" == "Tablet" ]]; then grep "tablet"; else grep -v "tablet"; fi ) \
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

    # Create fzf options with status indicators
    local -a fzf_options
    if [ ${#installed_images[@]} -gt 0 ]; then
        for img in "${installed_images[@]}"; do
            fzf_options+=("✅ $(format_image_name_zsh "$img")|$img")
        done
    fi
    if [ ${#available_images[@]} -gt 0 ]; then
        for img in "${available_images[@]}"; do
            fzf_options+=("⬇️  $(format_image_name_zsh "$img")|$img")
        done
    fi

    local selected_option
    selected_option=$(printf '%s\n' "${fzf_options[@]}" | fzf --prompt="Select system image: " --height=15 --border --with-nth=1 --delimiter='|')
    
    if [[ -z "$selected_option" ]]; then
        echo "❌ No system image selected."
        return 1
    fi
    
    local selected_image
    selected_image=$(echo "$selected_option" | cut -d'|' -f2-)
    echo "    You selected: $(format_image_name_zsh "$selected_image") ($selected_image)"

    echo "    Installing '$selected_image' if necessary..."
    yes | sdkmanager "$selected_image" > /dev/null
    echo "---"

    # --- STEP 2: SELECT DEVICE (FILTERED) ---
    echo "➡️  Step 2: Choose a device profile (filtered for '$device_type_filter')."
    local -a device_ids device_names
    local current_id current_name

    while IFS= read -r line; do
        if [[ "$line" =~ "id: ([0-9]+) or \"(.*)\"" ]]; then
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
    
    # Create fzf options with device names and IDs
    local -a fzf_device_options
    for i in {1..${#device_names[@]}}; do
        local idx=$((i-1))
        fzf_device_options+=("${device_names[$idx]}|${device_ids[$idx]}")
    done
    
    local selected_device_option
    selected_device_option=$(printf '%s\n' "${fzf_device_options[@]}" | fzf --prompt="Select device profile: " --height=15 --border --with-nth=1 --delimiter='|')
    
    if [[ -z "$selected_device_option" ]]; then
        echo "❌ No device profile selected."
        return 1
    fi
    
    device_display_name=$(echo "$selected_device_option" | cut -d'|' -f1)
    selected_device_id=$(echo "$selected_device_option" | cut -d'|' -f2)
    echo "    You selected: $device_display_name (ID: $selected_device_id)"
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

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi


create-emulator() {
	  # Check if SDK tools exist
    if ! command -v sdkmanager &>/dev/null || ! command -v avdmanager &>/dev/null; then
        echo "❌ Error: Android SDK command-line tools not found."
        echo "    Make sure the tools are in your \$PATH."
        return 1
    fi

    # --- STEP 0: PRE-CONFIGURATION ---
    local arch_filter device_type_filter

    echo "➡️  Step 0: Let\'s configure your new emulator."
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
            echo "    Invalid option. Please enter a number between 1 and ${#all_images[@]}. "
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

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi


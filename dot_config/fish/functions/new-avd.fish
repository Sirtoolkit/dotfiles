function new-avd
    # Check if SDK tools exist
    if not command -v sdkmanager &>/dev/null; or not command -v avdmanager &>/dev/null
        echo "❌ Error: Android SDK command-line tools not found."
        echo "    Make sure: tools are in your \$PATH."
        return 1
    end

    # Check if fzf command exists
    if not command -v fzf &>/dev/null
        echo "❌ Error: 'fzf' command not found."
        echo "   Make sure fzf is installed and in your \$PATH."
        echo "   Install with: brew install fzf"
        return 1
    end

    # --- STEP 0: PRE-CONFIGURATION ---
    set -l arch_filter
    set -l device_type_filter

    echo "➡️  Step 0: Let's configure your new emulator."

    # Use fzf to select CPU architecture
    set -l arch_choice (printf "Intel (x86_64)\nARM (arm64-v8a)\n" | fzf --prompt="Select CPU architecture (Intel is faster on most PCs): " --height=8 --border)

    if test -z "$arch_choice"
        echo "❌ No architecture selected."
        return 1
    end

    if test "$arch_choice" = "Intel (x86_64)"
        set arch_filter "x86_64"
    else if test "$arch_choice" = "ARM (arm64-v8a)"
        set arch_filter "arm64-v8a"
    end

    # Use fzf to select device type
    set -l device_type_choice (printf "Phone\nTablet\n" | fzf --prompt="What type of device do you want to create? " --height=8 --border)

    if test -z "$device_type_choice"
        echo "❌ No device type selected."
        return 1
    end

    set device_type_filter "$device_type_choice"
    echo "---"

    # --- STEP 1: SELECT SYSTEM IMAGE (FILTERED & SEPARATED) ---
    echo "➡️  Step 1: Choose a system image (filtered for '$arch_filter' and '$device_type_filter')."

    set -l sdk_list_output (sdkmanager --list --verbose 2>/dev/null)
    set -l installed_block (echo "$sdk_list_output" | sed -n '/Installed packages:/,/Available Packages:/p')
    set -l available_block (echo "$sdk_list_output" | sed -n '/Available Packages:/,$p')

    function _filter_image_list
        set -l input_list $argv[1]
        set -l arch $argv[2]
        set -l device_type $argv[3]
        echo "$input_list" | awk '/^[[:space:]]*system-images;/ && /google_apis_playstore/ && !/ext/ && !/Baklava/ && !/ps16k/ {print $1}' \
            | grep "$arch" \
            | if test "$device_type" = "Tablet"
                grep "tablet"
            else
                grep -v "tablet"
            end \
            | sort -Vr | uniq
    end

    set -l installed_images (_filter_image_list "$installed_block" "$arch_filter" "$device_type_filter" | string split '\n')
    set -l available_images (_filter_image_list "$available_block" "$arch_filter" "$device_type_filter" | string split '\n')

    # Filter out already installed images from available
    set -l unique_available_images
    for img in $available_images
        if not contains "$img" $installed_images
            set -a unique_available_images "$img"
        end
    end
    set available_images $unique_available_images

    function _format_image_name
        set -l path $argv[1]
        set -l temp (string replace -r '.*android-' '' "$path")
        set -l api_level (string split ';' "$temp")[1]
        set -l img_type (string split ';' "$path")[-1]
        echo "Android API $api_level ($img_type)"
    end

    set -l all_images $installed_images $available_images

    if test (count $all_images) -eq 0
        echo "❌ No system images found with the selected criteria."
        return 1
    end

    # Create fzf options with status indicators
    set -l fzf_options
    for img in $installed_images
        set -a fzf_options "✅ "(_format_image_name "$img")"|$img"
    end
    for img in $available_images
        set -a fzf_options "⬇️  "(_format_image_name "$img")"|$img"
    end

    set -l selected_option (printf '%s\n' $fzf_options | fzf --prompt="Select system image: " --height=15 --border --with-nth=1 --delimiter='|')

    if test -z "$selected_option"
        echo "❌ No system image selected."
        return 1
    end

    set -l selected_image (echo "$selected_option" | cut -d'|' -f2-)
    echo "    You selected: "(_format_image_name "$selected_image")" ($selected_image)"

    echo "    Installing '$selected_image' if necessary..."
    yes | sdkmanager "$selected_image" > /dev/null
    echo "---"

    # --- STEP 2: SELECT DEVICE (FILTERED) ---
    echo "➡️  Step 2: Choose a device profile (filtered for '$device_type_filter')."
    set -l device_ids
    set -l device_names
    set -l current_id
    set -l current_name

    for line in (avdmanager list device | string split '\n')
        if string match -r 'id: ([0-9]+) or "(.*)"' "$line" > /dev/null
            set current_id (string match -r 'id: ([0-9]+) or "(.*)"' "$line")[2]
            set current_name ""
        else if string match -rq 'Name: (.*)' "$line"
            set current_name (string match -r 'Name: (.*)' "$line")[2]
            set -l is_match 0
            if test "$device_type_filter" = "Tablet"
                if string match -q "*Tablet*" "$current_name"; or string match -q "*Fold*" "$current_name"
                    set is_match 1
                end
            else
                if not string match -q "*Tablet*" "$current_name"; and not string match -q "*Fold*" "$current_name"; and not string match -q "*TV*" "$current_name"; and not string match -q "*Wear*" "$current_name"; and not string match -q "*Automotive*" "$current_name"
                    set is_match 1
                end
            end
            if test $is_match -eq 1
                set -a device_ids "$current_id"
                set -a device_names "$current_name"
            end
        end
    end

    if test (count $device_names) -eq 0
        echo "❌ No device profiles found for the selected type."
        return 1
    end

    # Create fzf options with device names and IDs
    set -l fzf_device_options
    for i in (seq (count $device_names))
        set -a fzf_device_options "$device_names[$i]|$device_ids[$i]"
    end

    set -l selected_device_option (printf '%s\n' $fzf_device_options | fzf --prompt="Select device profile: " --height=15 --border --with-nth=1 --delimiter='|')

    if test -z "$selected_device_option"
        echo "❌ No device profile selected."
        return 1
    end

    set -l device_display_name (echo "$selected_device_option" | cut -d'|' -f1)
    set -l selected_device_id (echo "$selected_device_option" | cut -d'|' -f2)
    echo "    You selected: $device_display_name (ID: $selected_device_id)"
    echo "---"

    # --- STEP 3: NAME THE EMULATOR (WITH SUGGESTION) ---
    set -l avd_name
    echo "➡️  Step 3: Give your new emulator a name."

    set -l temp_api (string replace -r '.*android-' '' "$selected_image")
    set -l api_level (string split ';' "$temp_api")[1]

    set -l device_name_sanitized (echo "$device_display_name" | tr ' ' '_')
    set -l suggested_name "{$device_name_sanitized}_API{$api_level}_{$arch_filter}"
    echo "    Suggested name: $suggested_name"

    echo -n "    Name: "
    read avd_name
    if test -z "$avd_name"
        set avd_name "$suggested_name"
        echo "    Using suggested name: $avd_name"
    end
    echo "---"

    # --- STEP 4: CREATE AND LAUNCH ---
    echo "⏳ Creating emulator '$avd_name'..."
    echo "no" | avdmanager create avd --name "$avd_name" --package "$selected_image" --device "$selected_device_id" --force

    if test $status -eq 0
        echo "✅ Emulator '$avd_name' created successfully!"
        echo -n "    Do you want to launch it now? (y/n): "
        read launch_now
        if string match -r '^[Yy]$' "$launch_now"
            echo "🚀 Launching '$avd_name' in the background..."
            nohup emulator @$avd_name > /dev/null 2>&1 &
        else
            echo "👍 Okay. You can launch it later with 'emulator @$avd_name'"
        end
    else
        echo "❌ An error occurred while creating the emulator."
    end

    return 0
end

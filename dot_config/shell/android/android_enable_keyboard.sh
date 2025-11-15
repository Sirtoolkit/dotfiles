enable-keyboard() {
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
        return 1
    fi
    
    # Create the interactive selection menu
    local avd_name
    PS3="   Choose the emulator to enable keyboard: "
    select avd_name in "${avds[@]}"; do
        if [[ -n "$avd_name" ]]; then
            # Use ANDROID_AVD_HOME if set, otherwise default to ~/.android/avd
            local avd_home="${ANDROID_AVD_HOME:-$HOME/.android/avd}"
            local config_file="$avd_home/${avd_name}.avd/config.ini"
            if [ -f "$config_file" ]; then
                # Remove existing hw.keyboard line if present
                sed -i '' '/^hw.keyboard=/d' "$config_file"
                # Add hw.keyboard=yes
                echo "hw.keyboard=yes" >> "$config_file"
                echo "✅ Hardware keyboard enabled for '$avd_name'"
                echo "   Launch the emulator to test: emulator @$avd_name"
            else
                echo "❌ Config file not found: $config_file"
            fi
            break
        else
            echo "   Invalid option. Please try again."
        fi
    done

    return 0
}

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

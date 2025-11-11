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

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

launch-emulator() {
    # Check if 'emulator' command exists
    if ! command -v emulator &>/dev/null; then
        echo "❌ Error: 'emulator' command not found."
        echo "   Make sure the Android SDK tools are in your \$PATH."
        return 1
    fi

    # Check if 'fzf' command exists
    if ! command -v fzf &>/dev/null; then
        echo "❌ Error: 'fzf' command not found."
        echo "   Please install fzf to use this script (e.g., brew install fzf)."
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

    # Use fzf to select the emulator
    local avd_name
    avd_name=$(printf "%s\n" "${avds[@]}" | fzf --prompt="   Choose the emulator you want to launch: ")

    # Check if an emulator was selected
    if [[ -z "$avd_name" ]]; then
        echo "   Emulator selection cancelled."
        return 0
    fi

    echo "🚀 Launching '$avd_name' in the background..."
    # Execute in the background, detached from the terminal
    nohup emulator @"$avd_name" > /dev/null 2>&1 &

    return 0
}

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

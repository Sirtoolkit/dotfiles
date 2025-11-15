delete-emulator() {
    if ! command -v emulator &>/dev/null; then
        echo "❌ Error: 'emulator' command not found."
        return 1
    fi

    # Add fzf existence check
    if ! command -v fzf &>/dev/null; then
        echo "❌ Error: 'fzf' command not found."
        echo "   Please install fzf to use this script (e.g., brew install fzf)."
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
    # Replace select with fzf
    avd_name=$(printf "%s\n" "${avds[@]}" | fzf --prompt="   Choose the emulator you want to DELETE: ")

    # Handle fzf cancellation
    if [[ -z "$avd_name" ]]; then
        echo "   Emulator selection cancelled."
        return 0
    fi

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

    return 0
}

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

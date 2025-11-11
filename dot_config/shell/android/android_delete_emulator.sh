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

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

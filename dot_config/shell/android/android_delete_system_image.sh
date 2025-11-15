delete-system-image() {
    if ! command -v sdkmanager &>/dev/null; then
        echo "❌ Error: 'sdkmanager' command not found."
        return 1
    fi

    # Add fzf existence check
    if ! command -v fzf &>/dev/null; then
        echo "❌ Error: 'fzf' command not found."
        echo "   Please install fzf to use this script (e.g., brew install fzf)."
        return 1
    fi
    
    echo "➡️  Looking for installed system-images..."
    local -a installed_images
    # We use --list_installed to see only the ones we already have
    installed_images=(${(f)"$(sdkmanager --list_installed | grep system-images | cut -d'|' -f1 | sed 's/^[ 	]*//;s/[ 	]*$//')"})
    
    if [ ${#installed_images[@]} -eq 0 ]; then
        echo "✅ No installed system-images found."
        return 0
    fi
    
    local image_path
    # Replace select with fzf
    image_path=$(printf "%s\n" "${installed_images[@]}" | fzf --prompt="   Choose the system-image you want to UNINSTALL: ")

    # Handle fzf cancellation
    if [[ -z "$image_path" ]]; then
        echo "   System image selection cancelled."
        return 0
    fi
            
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

    return 0
}

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^android_//' | sed 's/_/-/g')
  $func_name
fi

function delete-system-image
	if not command -v sdkmanager &>/dev/null
		echo "❌ Error: 'sdkmanager' command not found."
		return 1
	end

	# Add fzf existence check
	if not command -v fzf &>/dev/null
		echo "❌ Error: 'fzf' command not found."
		echo "   Please install fzf to use this script (e.g., brew install fzf)."
		return 1
	end

	echo "➡️  Looking for installed system-images..."
	# We use --list_installed to see only the ones we already have
	set installed_images (sdkmanager --list_installed | grep system-images | cut -d'|' -f1 | sed 's/^[ \t]*//;s/[ \t]*$//')

	if test (count $installed_images) -eq 0
		echo "✅ No installed system-images found."
		return 0
	end

	# Replace select with fzf
	set image_path (printf "%s\n" $installed_images | fzf --prompt="   Choose the system-image you want to UNINSTALL: ")

	# Handle fzf cancellation
	if test -z "$image_path"
		echo "   System image selection cancelled."
		return 0
	end

	echo "⚠️  Warning! You are about to uninstall the image '$image_path'."
	echo -n "Are you sure? (yes/no): "
	read confirm

	if string match -r '^[Yy]([Ee][Ss])?$' "$confirm"
		echo "🗑️  Uninstalling '$image_path'..."
		sdkmanager --uninstall "$image_path"
		echo "✅ Image successfully uninstalled."
	else
		echo "👍 Uninstall aborted."
	end

	return 0
end

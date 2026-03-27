function avd-del
	if not command -v emulator &>/dev/null
		echo "❌ Error: 'emulator' command not found."
		return 1
	end

	# Add fzf existence check
	if not command -v fzf &>/dev/null
		echo "❌ Error: 'fzf' command not found."
		echo "   Please install fzf to use this script (e.g., brew install fzf)."
		return 1
	end

	echo "➡️  Looking for available emulators..."
	set avds (emulator -list-avds)

	if test (count $avds) -eq 0
		echo "❌ No emulators found to delete."
		return 1
	end

	# Replace select with fzf
	set avd_name (printf "%s\n" $avds | fzf --prompt="   Choose the emulator you want to DELETE: ")

	# Handle fzf cancellation
	if test -z "$avd_name"
		echo "   Emulator selection cancelled."
		return 0
	end

	echo "⚠️  Warning! You are about to permanently delete the emulator '$avd_name'."
	echo -n "Are you sure? This action cannot be undone. (yes/no): "
	read confirm

	if string match -r '^[Yy]([Ee][Ss])?$' "$confirm"
		echo "🗑️  Deleting '$avd_name'..."
		avdmanager delete avd -n "$avd_name"
		echo "✅ Emulator '$avd_name' successfully deleted."
	else
		echo "👍 Deletion aborted."
	end

	return 0
end

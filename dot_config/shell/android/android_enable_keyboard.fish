function enable-keyboard
	# Check if 'emulator' command exists
	if not command -v emulator &>/dev/null
		echo "❌ Error: 'emulator' command not found."
		echo "   Make sure the Android SDK tools are in your \$PATH."
		return 1
	end

	# Add fzf existence check
	if not command -v fzf &>/dev/null
		echo "❌ Error: 'fzf' command not found."
		echo "   Please install fzf to use this script (e.g., brew install fzf)."
		return 1
	end

	echo "➡️  Looking for available emulators..."

	# Get the list of AVDs and store it
	set avds (emulator -list-avds)

	# Check if any emulators exist
	if test (count $avds) -eq 0
		echo "❌ No emulators found."
		return 1
	end

	# Create the interactive selection menu
	# Replace select with fzf
	set avd_name (printf "%s\n" $avds | fzf --prompt="   Choose the emulator to enable keyboard: ")

	# Handle fzf cancellation
	if test -z "$avd_name"
		echo "   Emulator selection cancelled."
		return 0
	end

	if test -n "$avd_name"
		# Use ANDROID_AVD_HOME if set, otherwise default to ~/.android/avd
		set avd_home "$ANDROID_AVD_HOME"
		if test -z "$avd_home"
			set avd_home "$HOME/.android/avd"
		end
		set config_file "$avd_home/$avd_name.avd/config.ini"
		if test -f "$config_file"
			# Remove existing hw.keyboard line if present
			sed -i '' '/^hw.keyboard=/d' "$config_file"
			# Add hw.keyboard=yes
			echo "hw.keyboard=yes" >> "$config_file"
			echo "✅ Hardware keyboard enabled for '$avd_name'"
			echo "   Launch the emulator to test: emulator @$avd_name"
		else
			echo "❌ Config file not found: $config_file"
		end
	end

	return 0
end

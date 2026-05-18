function avd-run
	# Check if 'emulator' command exists
	if not command -v emulator &>/dev/null
		echo "❌ Error: 'emulator' command not found."
		echo "   Make sure the Android SDK tools are in your \$PATH."
		return 1
	end

	# Check if 'fzf' command exists
	if not command -v fzf &>/dev/null
		echo "❌ Error: 'fzf' command not found."
		echo "   Please install fzf to use this script (e.g., brew install fzf)."
		return 1
	end

	echo "➡️  Looking for available emulators..."

	# Get the list of AVDs and store it in a list
	set avds (emulator -list-avds)

	# Check if any emulators exist
	if test (count $avds) -eq 0
		echo "❌ No emulators found."
		echo "   You can create a new one with the 'create-emulator' command."
		return 1
	end

	# Use fzf to select the emulator
	set avd_name (printf "%s\n" $avds | fzf --prompt="   Choose the emulator you want to launch: ")

	# Check if an emulator was selected
	if test -z "$avd_name"
		echo "   Emulator selection cancelled."
		return 0
	end

	# Ensure hardware keyboard is enabled before launch
	set avd_home "$ANDROID_AVD_HOME"
	if test -z "$avd_home"
		set avd_home "$HOME/.android/avd"
	end
	set config_file "$avd_home/$avd_name.avd/config.ini"
	if test -f "$config_file"
		sed -i '' '/^hw.keyboard=/d' "$config_file"
		echo "hw.keyboard=yes" >> "$config_file"
	end

	echo "🚀 Launching '$avd_name' in the background..."
	# Execute in the background, detached from the terminal
	nohup emulator @$avd_name -dns-server 8.8.8.8,8.8.4.4 > /dev/null 2>&1 &

	return 0
end

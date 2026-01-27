#!/usr/bin/env bash

# Function to uninstall Karabiner-DriverKit-VirtualHIDDevice
uninstall_karabiner_driverkit() {
	local support_dir="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
	local app_path="/Applications/.Karabiner-VirtualHIDDevice-Manager.app"

	echo "=========================================="
	echo "Uninstalling Karabiner-DriverKit..."
	echo "=========================================="
	echo ""

	# Check if installed
	if [ ! -d "$support_dir" ] && [ ! -d "$app_path" ]; then
		echo "Karabiner-DriverKit is not installed."
		return 0
	fi

	# Show what will be removed
	echo "The following will be removed:"
	[ -d "$app_path" ] && echo "  - $app_path"
	[ -d "$support_dir" ] && echo "  - $support_dir"
	echo ""

	# Ask for confirmation
	echo -n "Are you sure you want to uninstall Karabiner-DriverKit? (y/N): "
	read -r REPLY
	echo ""

	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "Uninstallation cancelled."
		return 1
	fi

	echo ""

	# Try using official uninstall scripts first
	if [ -f "${support_dir}/scripts/uninstall/deactivate_driver.sh" ]; then
		echo "Deactivating driver using official script..."
		bash "${support_dir}/scripts/uninstall/deactivate_driver.sh"

		if [ -f "${support_dir}/scripts/uninstall/remove_files.sh" ]; then
			echo "Removing files using official script..."
			sudo bash "${support_dir}/scripts/uninstall/remove_files.sh"
		fi
	else
		echo "Official uninstall scripts not found. Using manual uninstall..."

		# Manual uninstall
		echo "Uninstalling system extension..."
		sudo systemextensionsctl uninstall org.pqrs Karabiner-DriverKit-VirtualHIDDevice 2>/dev/null || true

		echo "Removing application files..."
		sudo rm -rf "$app_path" 2>/dev/null || true

		echo "Removing support files..."
		sudo rm -rf "$support_dir" 2>/dev/null || true
		sudo rm -rf "/Library/Application Support/org.pqrs/Karabiner-VirtualHIDDevice" 2>/dev/null || true
	fi

	echo ""
	echo "Verifying uninstallation..."
	if systemextensionsctl list 2>/dev/null | grep -q "Karabiner-DriverKit"; then
		echo "⚠️  Warning: System extension may still be present"
		echo "   Run: systemextensionsctl list | grep Karabiner"
		echo "   You may need to reboot to complete uninstallation"
	else
		echo "✓ Karabiner-DriverKit uninstalled successfully!"
	fi

	echo ""
	echo "=========================================="
	echo "Uninstallation complete!"
	echo "Note: A reboot may be required to fully"
	echo "      remove the system extension."
	echo "=========================================="
}

# Run the function if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
	uninstall_karabiner_driverkit
fi

function purge-all
	echo -e "\n\033[1;31mWARNING:\033[0m This action will execute all purge functions and remove a significant amount of cached data from your system."
	echo "This includes mobile dev caches, configuration files, mise, homebrew, mac app store apps, and various other caches."
	echo "This action cannot be undone."
	echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
	read CONFIRM
	if test "$CONFIRM" = "yes"
		echo -e "\nProceeding with all purge operations..."
		purge-mobile
		purge-config
		purge-mise
		purge-brew-pkgs
		purge-brew-apps
		purge-mas
		purge-logs
		echo -e "\n\033[1;32mAll purge operations completed!\033[0m"
	else
		echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
	end
end

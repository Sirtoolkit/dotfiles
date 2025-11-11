system-log-cleanup() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will remove system and user log files."
    echo "This requires sudo privileges."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nRemoving system and user log files..."
        sudo rm -rf /private/var/log/*
        rm -rf ~/Library/Logs/*
        echo -e "\n\033[1;32mSystem and user log files removed!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

vscode-cache-cleanup() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will remove the VSCode cache directories."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nRemoving VSCode cache..."
        rm -rf ~/Library/Application\ Support/Code/Cache/*
        rm -rf ~/Library/Application\ Support/Code/CachedData/*
        echo -e "\n\033[1;32mVSCode cache removed!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

brew-cleanup() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will remove stale lock files and outdated downloads for all formulae and casks, and remove old versions of installed formulae."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nRunning Homebrew cleanup..."
        brew cleanup
        echo -e "\n\033[1;32mHomebrew cleanup completed!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

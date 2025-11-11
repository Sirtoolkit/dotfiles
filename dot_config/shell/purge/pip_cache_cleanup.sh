pip-cache-cleanup() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will purge the pip cache."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nPurging pip cache..."
        pip cache purge
        echo -e "\n\033[1;32mpip cache purged!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

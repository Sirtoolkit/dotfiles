go-cache-cleanup() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will remove all Go build cache results."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nCleaning Go build cache..."
        go clean -cache
        echo -e "\n\033[1;32mGo build cache cleaned!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

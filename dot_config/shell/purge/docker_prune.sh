docker-prune() {
    echo -e "\n\033[1;33mINFO:\033[0m This action will remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes."
    echo -n "Are you sure you want to continue? (type 'yes' to confirm): "
    read CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
        echo -e "\nRunning Docker system prune..."
        docker system prune -a
        echo -e "\n\033[1;32mDocker system prune completed!\033[0m"
    else
        echo -e "\n\033[1;32mOperation cancelled.\033[0m Nothing has been deleted."
    fi
}

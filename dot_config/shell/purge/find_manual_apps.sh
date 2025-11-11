find-manual-apps() {
    echo -e "\n\033[1;33mINFO:\033[0m This script will help you find applications that were likely installed manually (not via Homebrew or the App Store)."
    echo "It will list applications in /Applications and ~/Applications and you can decide to delete them manually."
    echo "System applications from Apple will be excluded."

    echo -e "\n\033[1;34mSearching for manually installed applications...\033[0m"

    # Get list of brew-installed apps
    BREW_APPS=$(brew list --cask -1 | sed -e 's/$/.app/')

    # Find apps, exclude Apple's, and exclude brew's
    find /Applications ~/Applications -maxdepth 1 -name "*.app" -print0 | while IFS= read -r -d $'\0' app; do
        # Exclude apps signed by Apple
        if codesign -dv --verbose=2 "$app" 2>&1 | grep -q "Authority=Software Signing" && \
           codesign -dv --verbose=2 "$app" 2>&1 | grep -q "Authority=Apple Code Signing Certification Authority" && \
           codesign -dv --verbose=2 "$app" 2>&1 | grep -q "Authority=Apple Root CA"; then
            continue
        fi

        # Exclude apps installed by brew
        app_name=$(basename "$app")
        if echo "$BREW_APPS" | grep -q "^${app_name}$\n"; then
            continue
        fi

        echo "Found manual app: $app"
    done

    echo -e "\n\033[1;32mSearch complete.\033[0m Please review the list above and manually delete any applications you no longer need by dragging them to the Trash."
}

ghclone() {
    # Check if 'gh' command exists
    if ! command -v gh &>/dev/null; then
        echo "❌ Error: 'gh' command not found."
        echo "   Make sure GitHub CLI is installed and in your \$PATH."
        echo "   Install with: brew install gh"
        return 1
    fi
    
    # Check if 'fzf' command exists
    if ! command -v fzf &>/dev/null; then
        echo "❌ Error: 'fzf' command not found."
        echo "   Make sure fzf is installed and in your \$PATH."
        echo "   Install with: brew install fzf"
        return 1
    fi
    
    # Check if user is authenticated
    if ! gh auth status &>/dev/null; then
        echo "❌ Error: Not authenticated with GitHub CLI."
        echo "   Run 'gh auth login' to authenticate."
        return 1
    fi
    
    echo "➡️  Fetching your GitHub organizations..."
    
    # Get the list of organizations and store it in an array
    local -a orgs
    orgs=(${(f)"$(gh org list --limit 100 2>/dev/null)"})
    
    # Add option for personal repositories
    orgs+=("Personal repositories (all your repos)")
    
    # Check if any organizations exist
    if [ ${#orgs[@]} -eq 1 ]; then
        echo "ℹ️  No organizations found, showing your personal repositories..."
        echo ""
        local -a repos
        repos=(${(f)"$(gh repo list --limit 50 --json nameWithOwner --jq '.[].nameWithOwner')"})
        if [ ${#repos[@]} -eq 0 ]; then
            echo "❌ No repositories found."
            return 1
        fi
        clone_selected_repo "${repos[@]}"
        return 0
    fi
    
    echo ""
    echo "📋 Select an organization (or Personal for all repos):"
    
    # Use fzf to select organization
    local selected_org
    selected_org=$(printf '%s\n' "${orgs[@]}" | fzf --prompt="Select organization: " --height=10 --border)
    
    if [[ -z "$selected_org" ]]; then
        echo "❌ No organization selected."
        return 1
    fi
    
    echo ""
    echo "🔍 Fetching repositories from: $selected_org"
    echo ""
    
    local -a repos
    if [[ "$selected_org" == "Personal repositories (all your repos)" ]]; then
        echo "📝 Your personal repositories:"
        repos=(${(f)"$(gh repo list --limit 50 --json nameWithOwner --jq '.[].nameWithOwner')"})
    else
        echo "📝 Repositories in '$selected_org':"
        repos=(${(f)"$(gh repo list "$selected_org" --limit 50 --json nameWithOwner --jq '.[].nameWithOwner')"})
    fi
    
    if [ ${#repos[@]} -eq 0 ]; then
        echo "❌ No repositories found in this organization."
        return 1
    fi
    
    clone_selected_repo "${repos[@]}"
    return 0
}

clone_selected_repo() {
    local -a repos=("$@")
    
    echo ""
    echo "📋 Select a repository to clone:"
    
    # Use fzf to select repository
    local selected_repo
    selected_repo=$(printf '%s\n' "${repos[@]}" | fzf --prompt="Select repository: " --height=15 --border)
    
    if [[ -z "$selected_repo" ]]; then
        echo "❌ No repository selected."
        return 1
    fi
    
    echo ""
    echo "📁 Where would you like to clone the repository?"
    
    # Use fzf to select clone location
    local clone_choice
    clone_choice=$(printf "Current directory ($(pwd))\nCustom directory\n" | fzf --prompt="Select clone location: " --height=8 --border)
    
    case $clone_choice in
        "Current directory"*)
            echo ""
            echo "🚀 Cloning '$selected_repo' to current directory..."
            gh repo clone "$selected_repo"
            ;;
        "Custom directory"*)
            echo ""
            read -p "   Enter directory path: " clone_dir
            if [[ -n "$clone_dir" ]]; then
                echo ""
                echo "🚀 Cloning '$selected_repo' to '$clone_dir'..."
                mkdir -p "$clone_dir"
                cd "$clone_dir"
                gh repo clone "$selected_repo"
            else
                echo "❌ Invalid directory path."
                return 1
            fi
            ;;
        *)
            echo "❌ No location selected."
            return 1
            ;;
    esac
}

# If run directly, execute the function
if [[ $ZSH_EVAL_CONTEXT != *file* ]]; then
  func_name=$(basename "$0" .sh | sed 's/^github_//' | sed 's/_/-/g')
  $func_name
fi

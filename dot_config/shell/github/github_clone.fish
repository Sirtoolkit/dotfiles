function ghclone
    # Check if 'gh' command exists
    if not command -v gh &>/dev/null
        echo "❌ Error: 'gh' command not found."
        echo "   Make sure GitHub CLI is installed and in your \$PATH."
        echo "   Install with: brew install gh"
        return 1
    end

    # Check if 'fzf' command exists
    if not command -v fzf &>/dev/null
        echo "❌ Error: 'fzf' command not found."
        echo "   Make sure fzf is installed and in your \$PATH."
        echo "   Install with: brew install fzf"
        return 1
    end

    # Check if user is authenticated
    if not gh auth status &>/dev/null
        echo "❌ Error: Not authenticated with GitHub CLI."
        echo "   Run 'gh auth login' to authenticate."
        return 1
    end

    echo "➡️  Fetching your GitHub organizations..."

    # Get the list of organizations and store it in a list
    set orgs (gh org list --limit 100 2>/dev/null | string split '\n')

    # Add option for personal repositories
    set -a orgs "Personal repositories (all your repos)"

    # Check if any organizations exist
    if test (count $orgs) -eq 1
        echo "ℹ️  No organizations found, showing your personal repositories..."
        echo ""
        set repos (gh repo list --limit 50 --json nameWithOwner --jq '.[].nameWithOwner' | string split '\n')
        if test (count $repos) -eq 0
            echo "❌ No repositories found."
            return 1
        end
        clone_selected_repo $repos
        return 0
    end

    echo ""
    echo "📋 Select an organization (or Personal for all repos):"

    # Use fzf to select organization
    set selected_org (printf '%s\n' $orgs | fzf --prompt="Select organization: " --height=10 --border)

    if test -z "$selected_org"
        echo "❌ No organization selected."
        return 1
    end

    echo ""
    echo "🔍 Fetching repositories from: $selected_org"
    echo ""

    set repos
    if test "$selected_org" = "Personal repositories (all your repos)"
        echo "📝 Your personal repositories:"
        set repos (gh repo list --limit 50 --json nameWithOwner --jq '.[].nameWithOwner' | string split '\n')
    else
        echo "📝 Repositories in '$selected_org':"
        set repos (gh repo list "$selected_org" --limit 50 --json nameWithOwner --jq '.[].nameWithOwner' | string split '\n')
    end

    if test (count $repos) -eq 0
        echo "❌ No repositories found in this organization."
        return 1
    end

    clone_selected_repo $repos
    return 0
end

function clone_selected_repo
    set repos $argv

    echo ""
    echo "📋 Select a repository to clone:"

    # Use fzf to select repository
    set selected_repo (printf '%s\n' $repos | fzf --prompt="Select repository: " --height=15 --border)

    if test -z "$selected_repo"
        echo "❌ No repository selected."
        return 1
    end

    echo ""
    echo "📁 Where would you like to clone the repository?"

    # Use fzf to select clone location
    set clone_choice (printf "Current directory (%s)\nCustom directory\n" (pwd) | fzf --prompt="Select clone location: " --height=8 --border)

    switch "$clone_choice"
        case "Current directory"*
            echo ""
            echo "🚀 Cloning '$selected_repo' to current directory..."
            gh repo clone "$selected_repo"
        case "Custom directory"*
            echo ""
            echo -n "   Enter directory path: "
            read clone_dir
            if test -n "$clone_dir"
                echo ""
                echo "🚀 Cloning '$selected_repo' to '$clone_dir'..."
                mkdir -p "$clone_dir"
                cd "$clone_dir"
                gh repo clone "$selected_repo"
            else
                echo "❌ Invalid directory path."
                return 1
            end
        case ""
            echo "❌ No location selected."
            return 1
    end
end

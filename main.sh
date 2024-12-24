#!/bin/bash

# Function to get commit emails from a specified GitHub repository
get_commit_emails() {
    local user="$1"
    local repo="$2"
    local page=1
    local commits=""
    local rate_limit_remaining
    local rate_limit_reset

    # Fetch the commits from the GitHub API with pagination
    echo "Fetching commits for $user/$repo..."
    while true; do
        # Make the API request
        response=$(curl -s -w "%{http_code}" -o /tmp/commits.json "https://api.github.com/repos/$user/$repo/commits?page=$page")

        # Get the rate limit info
        rate_limit_remaining=$(curl -s "https://api.github.com/rate_limit" | jq '.resources.core.remaining')
        rate_limit_reset=$(curl -s "https://api.github.com/rate_limit" | jq '.resources.core.reset')

        # Check if rate limit is exceeded
        if [ "$rate_limit_remaining" -eq 0 ]; then
            echo "Rate limit exceeded. Please try again later. Resets at $(date -d @$rate_limit_reset)."
            exit 1
        fi

        # Check if the repository exists
        if echo "$response" | grep -q 'Not Found'; then
            echo "Repository not found. Please check the username and repository name."
            return
        fi

        # Extract emails from the commit data
        emails=$(jq -r '.[].commit.author.email' /tmp/commits.json)

        # If there are no more commits, break the loop
        if [ -z "$emails" ]; then
            break
        fi

        # Accumulate the emails
        commits+="$emails"$'\n'

        # Increment page number
        ((page++))
    done

    # Output the unique list of emails
    echo "Extracting email addresses..."
    echo "$commits" | sort -u
}

# Prompt user for GitHub username (user to look up)
read -r -p "Enter the GitHub username whose commits you want to look up: " username

# Prompt user for repository name
read -r -p "Enter the repository name: " repository

# Call the function with user input
get_commit_emails "$username" "$repository"

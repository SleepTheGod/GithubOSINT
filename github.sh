#!/bin/bash

# Function to get commit emails from a specified GitHub repository
get_commit_emails() {
    local user="$1"
    local repo="$2"

    # Fetch the commits from the GitHub API
    echo "Fetching commits for $user/$repo..."
    commits=$(curl -s "https://api.github.com/repos/$user/$repo/commits")

    # Check if the API request was successful
    if echo "$commits" | grep -q '"message": "Not Found"'; then
        echo "Repository not found. Please check the username and repository name."
        return
    fi

    # Extract emails from the commit data
    echo "Extracting email addresses..."
    echo "$commits" | grep -Eo '"email": "[^"]+"' | sed 's/"email": "//;s/"//g' | sort -u
}

# Prompt user for GitHub username and repository name
read -r -p "Enter GitHub username: " username
read -r -p "Enter repository name: " repository

# Call the function with user input
get_commit_emails "$username" "$repository"

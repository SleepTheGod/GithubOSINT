This script fetches commit email addresses from a specified GitHub repository using the GitHub API. It prompts the user for the GitHub username and repository name they wish to investigate. The script makes an API request to retrieve the commit data, handling pagination to fetch multiple pages of commits if necessary. It also checks the rate limit of the GitHub API to ensure it does not exceed the allowed number of requests. The script extracts the email addresses from the commit author information in the JSON response using jq, accumulating them across multiple pages. Once all commits have been processed, it outputs a unique list of email addresses sorted alphabetically. If the repository is not found or if the rate limit is exceeded, the script informs the user with appropriate messages.

# How To Use This
```bash
git clone https://github.com/SleepTheGod/GithubOSINT
cd GithubOSINT
sudo apt install jq 
for mac users brew install jq
chmod +x main.sh
./main.sh
```

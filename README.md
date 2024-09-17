# GitHub Multi Repository Sync Script

This script allows you to manage multiple GitHub repositories, fetching updates and pushing local changes automatically. The repositories, branches, and directories are configured via a `repos.json` configuration file, making it easy to add and manage as many repositories as you need.

## Features

- Supports multiple GitHub repositories.
- Automatically fetches updates from the remote repository.
- Commits and pushes local changes with a dynamic commit message based on the number of modified files.
- Uses a JSON configuration file to define repositories, directories, and branches.

## Prerequisites

Ensure the following software is installed on your Ubuntu server:

- `git`: for managing repositories.
- `jq`: for parsing JSON configuration.
- SSH keys: Ensure you have SSH keys set up and configured with your GitHub account.

To install `jq` on Ubuntu, run:

```bash
sudo apt-get install jq
```

## Configuration
The configuration file repos.json defines the repositories, directories, and branches. Here's an example of how the file is structured:
```bash
{
  "repositories": [
    {
      "repo_dir": "The local directory where the repository is located.",
      "branch": "The branch that the script should pull from and push to.",
      "github_repo": "The SSH URL of the GitHub repository."
    },
    {
      "repo_dir": "/home/example/www/google",
      "branch": "main",
      "github_repo": "git@github.com:username/reponame.git"
    }
  ]
}
```

## How to Use
Clone this repository to your server or create your own script based on the provided example.

Create a repos.json configuration file in the same directory as the script. Define the repositories you want to manage in the file.

Run the script:

You can run the script manually:

```bash
bash /path/to/your/script.sh
```
Alternatively, you can set it to run at regular intervals using cron to automate the sync process.

## Check SSH keys:
Make sure that SSH keys are configured correctly and added to the GitHub account. Test SSH access with the following command:
```bash
ssh -T git@github.com
```
If your keys are not added to the SSH agent, you can add them with:
```bash
ssh-add ~/.ssh/id_rsa
```
### Script Behavior
Cloning Repositories: If a repository's directory does not exist, the script will automatically clone it from GitHub.

Fetching Updates: The script fetches the latest changes from the configured branch. If remote updates are available, it pulls them to the local directory.

Detecting Local Changes: If local changes are found, the script commits them with a dynamically generated commit message based on the number of files changed.

Pushing Local Changes: After committing, the script pushes changes to the specified branch on GitHub.

## Example Workflow
The script checks the local repository directory.
It fetches updates from the remote branch.
If updates are found, they are pulled locally.
The script checks for local changes (modified, added, or deleted files).
If local changes exist, they are committed with a message like Updated 3 files locally.
The local changes are pushed to the remote repository.

## Error Handling
If the script encounters issues such as missing branches or directories, it will log the error and continue to the next repository. Ensure that each repository in the repos.json file is valid and that you have the correct permissions set up.


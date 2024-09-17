#!/bin/bash


CONFIG_FILE="/home/zroot/www/repos.json"


REPOS=$(jq -c '.repositories[]' "$CONFIG_FILE")


for repo in $REPOS; do
  # Repos
  REPO_DIR=$(echo "$repo" | jq -r '.repo_dir')
  BRANCH=$(echo "$repo" | jq -r '.branch')
  GITHUB_REPO=$(echo "$repo" | jq -r '.github_repo')

  echo "Processing repository: $GITHUB_REPO"

  # Check if repo is fund
  if [ ! -d "$REPO_DIR" ]; then
    echo "Repository directory not found, cloning repository..."
    git clone "$GITHUB_REPO" "$REPO_DIR"
  fi

  # 
  cd "$REPO_DIR"

  # Check new updates in repo
  git fetch origin "$BRANCH"

  # check updates in local and remote repo 
  LOCAL_COMMIT=$(git rev-parse "$BRANCH")
  REMOTE_COMMIT=$(git rev-parse "origin/$BRANCH")

  if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
    echo "Changes detected, pulling updates..."
    git pull origin "$BRANCH"
  else
    echo "No changes detected."
  fi

  # Push changes to github, if local changes fund.
  if git diff-index --quiet HEAD --; then
    echo "No local changes to commit."
  else
    echo "Local changes detected, committing and pushing to GitHub..."

    # count changes in files 
    FILE_COUNT=$(git diff --name-only | wc -l)

    # Valitaan commit-viesti tiedostojen määrän perusteella
    if [ "$FILE_COUNT" -eq 1 ]; then
      COMMIT_MSG="Updated 1 file locally"
    else
      COMMIT_MSG="Updated $FILE_COUNT files locally"
    fi

    git add -A  
    git commit -m "$COMMIT_MSG"
    git push origin "$BRANCH"
  fi

  echo "Finished processing $GITHUB_REPO"
done

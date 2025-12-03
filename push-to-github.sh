#!/bin/bash

# Script to push Pomodoro Timer to GitHub
# Usage: ./push-to-github.sh YOUR_GITHUB_USERNAME

if [ -z "$1" ]; then
    echo "Usage: ./push-to-github.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "Example: ./push-to-github.sh isaac"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME="pomodoro-timer"

echo "🚀 Preparing to push to GitHub..."
echo ""

# Check if remote already exists
if git remote get-url origin &>/dev/null; then
    echo "Remote 'origin' already exists. Removing it..."
    git remote remove origin
fi

# Add remote
echo "Adding remote repository..."
git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

# Rename branch to main if needed
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Renaming branch from $current_branch to main..."
    git branch -M main
fi

echo ""
echo "✅ Repository configured!"
echo ""
echo "⚠️  IMPORTANT: Before pushing, you need to:"
echo "   1. Create the repository on GitHub:"
echo "      Visit: https://github.com/new"
echo "      Repository name: ${REPO_NAME}"
echo "      Visibility: Public or Private"
echo "      DO NOT initialize with README"
echo ""
echo "   2. Then run: git push -u origin main"
echo ""
echo "   You'll be prompted for your GitHub username and"
echo "   Personal Access Token (not password)"
echo ""
read -p "Have you created the repository on GitHub? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing to GitHub..."
    git push -u origin main
else
    echo ""
    echo "Please create the repository first, then run:"
    echo "  git push -u origin main"
fi


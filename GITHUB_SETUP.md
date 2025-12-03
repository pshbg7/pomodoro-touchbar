# Pushing to GitHub - Step by Step Guide

Your code is now ready to push to GitHub! Follow these steps:

## Step 1: Create a GitHub Repository

1. **Go to GitHub:**
   - Visit https://github.com
   - Sign in (or create an account if you don't have one)

2. **Create a new repository:**
   - Click the **"+"** icon in the top right
   - Select **"New repository"**

3. **Configure the repository:**
   - **Repository name:** `pomodoro-timer` (or any name you like)
   - **Description:** "Pomodoro Timer for macOS with Touch Bar support"
   - **Visibility:** Choose **Public** or **Private**
   - **DO NOT** check "Initialize with README" (we already have files)
   - Click **"Create repository"**

## Step 2: Connect Your Local Repository to GitHub

After creating the repository, GitHub will show you commands. Use these:

**If you haven't created the GitHub repo yet, run these commands:**

```bash
cd "/Users/isaac/pomodoro timer"
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-timer.git
git branch -M main
git push -u origin main
```

**Replace `YOUR_USERNAME` with your actual GitHub username!**

## Step 3: Push Your Code

Run these commands in Terminal:

```bash
cd "/Users/isaac/pomodoro timer"
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-timer.git
git branch -M main
git push -u origin main
```

**Note:** You'll be prompted for your GitHub username and password (or personal access token).

## Alternative: Using GitHub CLI (Easier)

If you have GitHub CLI installed:

```bash
cd "/Users/isaac/pomodoro timer"
gh repo create pomodoro-timer --public --source=. --remote=origin --push
```

## Authentication

GitHub no longer accepts passwords for git operations. You'll need:

1. **Personal Access Token:**
   - Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token"
   - Give it a name like "Pomodoro Timer"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - Copy the token (you won't see it again!)
   - Use this token as your password when pushing

2. **Or use SSH:**
   - Set up SSH keys with GitHub
   - Use SSH URL instead: `git@github.com:YOUR_USERNAME/pomodoro-timer.git`

## Quick Commands Summary

```bash
# Navigate to project
cd "/Users/isaac/pomodoro timer"

# Check status
git status

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-timer.git

# Push to GitHub
git push -u origin main
```

## What's Already Done

✅ Git repository initialized  
✅ All files added  
✅ Initial commit created  
✅ .gitignore file created (excludes Xcode build files)

## Next Steps After Pushing

1. Your code will be on GitHub!
2. You can share the repository URL with others
3. You can clone it on other machines
4. You can continue making changes and pushing updates

## Making Future Changes

After making changes to your code:

```bash
git add .
git commit -m "Description of your changes"
git push
```

That's it! Your Pomodoro Timer is now ready to be shared on GitHub! 🚀


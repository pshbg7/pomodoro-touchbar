# Quick Push to GitHub

Your code is ready! Follow these steps:

## Step 1: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `pomodoro-timer`
3. Choose Public or Private
4. **DO NOT** check "Initialize with README"
5. Click "Create repository"

## Step 2: Run This Command

Replace `YOUR_USERNAME` with your actual GitHub username:

```bash
cd "/Users/isaac/pomodoro timer"
git remote add origin https://github.com/YOUR_USERNAME/pomodoro-timer.git
git push -u origin main
```

## Step 3: Authenticate

When prompted:
- **Username:** Your GitHub username
- **Password:** Use a Personal Access Token (not your password)

To create a token:
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name it "Pomodoro Timer"
4. Select `repo` scope
5. Click "Generate token"
6. Copy and use it as your password

## Or Use the Script

Run:
```bash
./push-to-github.sh YOUR_USERNAME
```

Then follow the prompts!


# Fixing GitHub Authentication

You're getting a permission error because GitHub authentication needs to be set up. Here are solutions:

## Solution 1: Use Personal Access Token (Recommended)

1. **Create a Personal Access Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name it: "Pomodoro Timer"
   - Select scope: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. **Push using the token:**
   ```bash
   git push -u origin main
   ```
   - When prompted for username: Enter `pshstarbg`
   - When prompted for password: Paste your Personal Access Token (not your password!)

## Solution 2: Use SSH (Alternative)

1. **Check if you have SSH keys:**
   ```bash
   ls -la ~/.ssh
   ```

2. **If you don't have SSH keys, generate them:**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

3. **Add SSH key to GitHub:**
   - Copy your public key: `cat ~/.ssh/id_ed25519.pub`
   - Go to: https://github.com/settings/keys
   - Click "New SSH key"
   - Paste your key and save

4. **Change remote to SSH:**
   ```bash
   git remote set-url origin git@github.com:pshstarbg/touchbar-pomodoro-timer.git
   git push -u origin main
   ```

## Solution 3: Clear Cached Credentials

If you have wrong credentials cached:

```bash
# Clear cached credentials
git credential-osxkeychain erase
host=github.com
protocol=https
[Press Enter twice]

# Then try pushing again
git push -u origin main
```

## Quick Fix - Try This First

Run this command and use your Personal Access Token when prompted:

```bash
git push -u origin main
```

When prompted:
- **Username:** pshstarbg
- **Password:** [Your Personal Access Token - NOT your GitHub password]


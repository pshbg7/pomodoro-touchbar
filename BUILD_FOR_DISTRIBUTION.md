# Building Your App for Distribution/Sharing

This guide will help you create a shareable version of your Pomodoro Timer app that others can use.

## Method 1: Simple Build (For Personal Sharing)

### Step 1: Build Release Version

1. **Open your Xcode project**

2. **Change to Release configuration:**
   - **Product → Scheme → Edit Scheme...**
   - Under "Run", change **Build Configuration** from "Debug" to **"Release"**
   - Click **"Close"**

3. **Build the app:**
   - Press **⌘ + B** (Command + B)
   - Wait for "Build Succeeded"

4. **Find the built app:**
   - In Xcode left sidebar, expand **"Products"**
   - Right-click on **"Pomodoro Timer.app"**
   - Select **"Show in Finder"**
   - This opens the Release build folder

5. **Copy the app:**
   - The `.app` file is ready to share!
   - You can zip it and send it to others
   - Or copy it to Applications folder

### Step 2: Create a ZIP File (Easier to Share)

1. **Right-click** on `Pomodoro Timer.app` in Finder
2. Select **"Compress"** (or **"Archive"**)
3. This creates `Pomodoro Timer.app.zip`
4. Share this ZIP file!

### Step 3: Share the App

**Ways to share:**
- Email the ZIP file
- Upload to Google Drive/Dropbox and share link
- Upload to GitHub Releases
- Share via AirDrop

## Method 2: Archive and Export (More Professional)

### Step 1: Archive the App

1. **Select "Any Mac" as destination:**
   - At the top of Xcode, next to Play button
   - Select **"Any Mac"** (or "My Mac")

2. **Create Archive:**
   - **Product → Archive**
   - Wait for archive to complete
   - The Organizer window will open automatically

### Step 2: Export from Archive

1. **In Organizer window:**
   - Select your archive
   - Click **"Distribute App"**

2. **Choose distribution method:**
   - **"Copy App"** - Creates a standalone `.app` file (best for sharing)
   - **"Developer ID"** - For distribution outside App Store (requires paid Apple Developer account)
   - **"Mac App Store"** - For App Store distribution (requires paid Apple Developer account)

3. **For simple sharing, choose "Copy App":**
   - Click **"Next"**
   - Choose **"Export"**
   - Click **"Next"**
   - Choose a location to save
   - Click **"Export"**

4. **You'll get:**
   - A folder containing `Pomodoro Timer.app`
   - Ready to share!

## Method 3: Create a DMG (Most Professional)

A DMG (Disk Image) is the standard way macOS apps are distributed.

### Step 1: Build Release App (see Method 1)

### Step 2: Create DMG

1. **Open Disk Utility:**
   - Applications → Utilities → Disk Utility
   - Or press **⌘ + Space** and type "Disk Utility"

2. **Create new image:**
   - **File → New Image → Blank Image**
   - **Name:** `Pomodoro Timer`
   - **Size:** 100 MB (or larger)
   - **Format:** Mac OS Extended (Journaled)
   - **Encryption:** None
   - **Partitions:** Single partition - Apple Partition Map
   - Click **"Create"**

3. **Mount the DMG:**
   - It will appear on your desktop

4. **Add files to DMG:**
   - Open the mounted DMG
   - Drag `Pomodoro Timer.app` into it
   - (Optional) Create a shortcut to Applications folder:
     - Right-click → New Folder → Name it "Applications"
     - Drag Applications folder from Finder sidebar into DMG

5. **Customize DMG window:**
   - Arrange files nicely
   - **View → Show View Options**
   - Set background, icon size, etc.

6. **Eject and convert:**
   - Eject the DMG (drag to Trash or right-click → Eject)
   - In Disk Utility: **Images → Convert**
   - Select your DMG
   - Choose **"compressed"** format
   - Save as `Pomodoro Timer.dmg`

7. **Share the DMG!**

## Important Notes for Sharing

### Code Signing

**For personal sharing (no Apple Developer account):**
- The app will work, but users may see a security warning
- Users need to: Right-click → Open → Open (to bypass Gatekeeper)

**For wider distribution:**
- You need an Apple Developer account ($99/year)
- Sign the app with Developer ID
- Users won't see security warnings

### Security Warnings

When others download your app, they may see:
- **"Pomodoro Timer.app is from an unidentified developer"**

**Solution for users:**
1. Right-click the app → **Open**
2. Click **"Open"** in the security dialog
3. Or: System Preferences → Security & Privacy → Click **"Open Anyway"**

### Remove Quarantine Attribute (Advanced)

If you want to remove the warning for users, they can run:
```bash
xattr -cr "/path/to/Pomodoro Timer.app"
```

## Quick Summary

**Easiest method:**
1. Build Release (⌘ + B with Release config)
2. Right-click `.app` → Compress
3. Share the ZIP file!

**Most professional:**
1. Archive (Product → Archive)
2. Export as "Copy App"
3. Create DMG
4. Share DMG

## Distribution Options

1. **Personal sharing:** ZIP file via email/cloud
2. **GitHub Releases:** Upload ZIP/DMG to GitHub
3. **Website:** Host DMG on your website
4. **Mac App Store:** Requires Apple Developer account ($99/year)

## Testing Before Sharing

Before sharing, test:
- [ ] App launches correctly
- [ ] Touch Bar works
- [ ] Timer functions work
- [ ] Sounds play
- [ ] Menu bar icon appears
- [ ] Control Strip button appears

Your app is ready to share! 🚀


# How to Export Pomodoro Timer as a macOS Application

This guide will walk you through building and exporting your Pomodoro Timer app so you can use it on your Mac.

## Step 1: Build the App in Xcode

1. **Open your project in Xcode**

2. **Select the build target:**
   - At the top of Xcode, next to the Play button
   - Make sure "Pomodoro Timer" and "My Mac" are selected

3. **Build the project:**
   - Press **⌘ + B** (Command + B) or go to **Product → Build**
   - Wait for "Build Succeeded" message

## Step 2: Find the Built App

After building, the app is already created! Here's where to find it:

1. **In Xcode:**
   - Right-click on "Pomodoro Timer" in the Products folder (left sidebar)
   - Select **"Show in Finder"**
   - This opens the folder containing your `.app` file

2. **Or navigate manually:**
   - The app is usually located at:
   ```
   ~/Library/Developer/Xcode/DerivedData/Pomodoro_Timer-[random-string]/Build/Products/Debug/Pomodoro Timer.app
   ```

## Step 3: Copy the App to Applications

1. **Drag the app to Applications:**
   - Find `Pomodoro Timer.app` in Finder
   - Drag it to your **Applications** folder
   - Or copy it anywhere you want (Desktop, Documents, etc.)

2. **Launch the app:**
   - Double-click `Pomodoro Timer.app` to run it
   - The first time, macOS may warn about an unidentified developer
   - Go to **System Preferences → Security & Privacy → General**
   - Click **"Open Anyway"** next to the warning

## Step 4: Create a Release Build (Optional but Recommended)

For a cleaner, optimized version:

1. **Change build configuration:**
   - In Xcode, go to **Product → Scheme → Edit Scheme...**
   - Under "Run", change **Build Configuration** from "Debug" to **"Release"**
   - Click **"Close"**

2. **Build for release:**
   - Press **⌘ + B** to build
   - The Release version will be in:
   ```
   ~/Library/Developer/Xcode/DerivedData/Pomodoro_Timer-[random-string]/Build/Products/Release/Pomodoro Timer.app
   ```

3. **Archive the app (for distribution):**
   - Go to **Product → Archive**
   - Wait for the archive to complete
   - The Organizer window will open
   - You can export the app from there

## Step 5: Export from Archive (Advanced)

If you want to create a distributable version:

1. **In the Organizer window:**
   - Select your archive
   - Click **"Distribute App"**

2. **Choose distribution method:**
   - **"Copy App"** - Creates a standalone `.app` file
   - **"Developer ID"** - For distribution outside App Store (requires paid Apple Developer account)
   - **"Mac App Store"** - For App Store distribution (requires paid Apple Developer account)

3. **For personal use:**
   - Choose **"Copy App"**
   - Click **"Next"** and follow the prompts
   - The app will be saved to your chosen location

## Step 6: Set Up Launch at Login (Automatic)

The app is already configured to launch at login! But you can verify:

1. **System Preferences → Users & Groups → Login Items**
2. You should see "Pomodoro Timer" in the list
3. If not, the app will add itself the first time you run it

## Troubleshooting

### "App is damaged and can't be opened"

This happens because the app isn't code-signed. Fix it:

1. Open **Terminal**
2. Run this command (replace path with your app's location):
   ```bash
   xattr -cr "/Applications/Pomodoro Timer.app"
   ```
3. Try opening the app again

### "Unidentified Developer" Warning

1. Go to **System Preferences → Security & Privacy → General**
2. Click **"Open Anyway"** next to the warning
3. Or right-click the app → **Open** → **Open** (this bypasses the warning)

### App Won't Launch

1. Make sure you're running on macOS 11.0 or later
2. Check Console.app for error messages
3. Try building again in Xcode

## Quick Summary

**Simplest method:**
1. Build in Xcode (⌘ + B)
2. Right-click "Pomodoro Timer" in Products → "Show in Finder"
3. Drag the `.app` file to Applications
4. Double-click to launch!

The app is now ready to use! It will:
- Launch automatically at login
- Show a Control Strip button in your Touch Bar
- Be accessible via ⌘+Shift+P shortcut
- Have a menu bar icon for quick access

Enjoy your Pomodoro Timer! 🍅




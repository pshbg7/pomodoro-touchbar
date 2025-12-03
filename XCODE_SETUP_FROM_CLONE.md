# Setting Up Xcode Project After Cloning

Since you cloned the repository, you have the source files but need to create an Xcode project. Follow these steps:

## Step 1: Create New Xcode Project

1. **Open Xcode**

2. **Create a new project:**
   - **File → New → Project** (or ⌘ + Shift + N)
   - Choose **macOS** → **App**
   - Click **Next**

3. **Configure:**
   - **Product Name:** `Pomodoro Timer`
   - **Team:** Your Apple ID (or "None")
   - **Organization Identifier:** `com.pshbg7` (or your name)
   - **Interface:** **SwiftUI**
   - **Language:** **Swift**
   - **Storage:** **None**
   - **Include Tests:** Uncheck
   - Click **Next**

4. **Save location:**
   - Save it **IN THE SAME FOLDER** where you cloned the repo
   - Or save it anywhere and we'll add the files
   - Click **Create**

## Step 2: Delete Default Files

1. **In Xcode, delete the default files:**
   - Right-click `PomodoroTimerApp.swift` (or `App.swift`) → **Delete → Move to Trash**
   - Right-click `ContentView.swift` → **Delete → Move to Trash**

## Step 3: Add Source Files from Cloned Repo

1. **Add all Swift files:**
   - **File → Add Files to "Pomodoro Timer"...**
   - Navigate to where you cloned the repo
   - Select ALL these `.swift` files:
     - `PomodoroTimerApp.swift`
     - `ContentView.swift`
     - `PomodoroTimerManager.swift`
     - `TouchBarController.swift`
     - `SoundManager.swift`
     - `LaunchAtLoginHelper.swift`
     - `GlobalShortcutManager.swift`
     - `DFRPrivateAPI.swift`
   - **IMPORTANT:** Check **"Copy items if needed"**
   - **IMPORTANT:** Check **"Add to targets: Pomodoro Timer"**
   - Click **Add**

2. **Add Info.plist (optional but recommended):**
   - **File → Add Files to "Pomodoro Timer"...**
   - Select `Info.plist`
   - Check **"Add to targets: Pomodoro Timer"**
   - Click **Add**

## Step 4: Verify Target Membership

**CRITICAL STEP - This fixes greyed out Product menu:**

1. **Select each Swift file** in the left sidebar
2. **Click on the file** to see the File Inspector (right sidebar)
3. **Under "Target Membership"**, make sure **"Pomodoro Timer"** is checked
4. **Do this for ALL Swift files:**
   - PomodoroTimerApp.swift ✓
   - ContentView.swift ✓
   - PomodoroTimerManager.swift ✓
   - TouchBarController.swift ✓
   - SoundManager.swift ✓
   - LaunchAtLoginHelper.swift ✓
   - GlobalShortcutManager.swift ✓
   - DFRPrivateAPI.swift ✓

## Step 5: Configure Project Settings

1. **Select the project** (blue icon at top of left sidebar)

2. **Select "Pomodoro Timer" target** (under TARGETS)

3. **General tab:**
   - **Deployment Target:** macOS 11.0 or later

4. **Signing & Capabilities tab:**
   - Check **"Automatically manage signing"**
   - Select your **Team**

## Step 6: Select Scheme

**This is why Product menu is greyed out!**

1. **At the top of Xcode**, next to the Play button
2. **Click the scheme dropdown** (should say "Pomodoro Timer > My Mac")
3. If it's not there or says "No Scheme":
   - Click **"Pomodoro Timer"** in the dropdown
   - Select **"My Mac"** as the destination
   - If "Pomodoro Timer" scheme doesn't exist:
     - Go to **Product → Scheme → Manage Schemes...**
     - Click **"+"** to add a scheme
     - Name it "Pomodoro Timer"
     - Target: "Pomodoro Timer"
     - Click **OK**

## Step 7: Build and Run

1. **Build:** Press **⌘ + B**
2. **Run:** Press **⌘ + R**

## Common Issues

### Product Menu Still Greyed Out?

1. **Check scheme:** Make sure "Pomodoro Timer" scheme is selected
2. **Check target:** Make sure all files are in the target (Step 4)
3. **Clean build:** **Product → Clean Build Folder** (⌘ + Shift + K)
4. **Restart Xcode**

### "No such module" errors?

- Make sure Deployment Target is macOS 11.0+
- Make sure all files are added to target

### Build errors?

- Check that all 8 Swift files are in the project
- Verify target membership for each file
- Try cleaning build folder (⌘ + Shift + K)

## Quick Fix Checklist

- [ ] Created new Xcode project (macOS App, SwiftUI)
- [ ] Deleted default App.swift and ContentView.swift
- [ ] Added all 8 Swift files from cloned repo
- [ ] Verified ALL files have "Pomodoro Timer" checked in Target Membership
- [ ] Set Deployment Target to macOS 11.0+
- [ ] Selected "Pomodoro Timer" scheme and "My Mac" destination
- [ ] Product menu should now be enabled!

Once the scheme is selected and files are in the target, the Product menu will be enabled and you can build/run!



# Quick Setup Guide for Beginners

This guide will walk you through creating the Xcode project step-by-step.

## Step 1: Install Xcode

1. Open the **App Store** on your Mac
2. Search for "Xcode"
3. Click "Get" or "Install" (it's free but large, ~12GB)
4. Wait for it to download and install

## Step 2: Create New Project

1. **Open Xcode** (it's in your Applications folder)

2. **Welcome Screen:**
   - If you see a welcome screen, click "Create a new Xcode project"
   - If not, go to **File → New → Project**

3. **Choose Template:**
   - Select **macOS** (at the top)
   - Choose **App** (the first option)
   - Click **Next**

4. **Configure Project:**
   - **Product Name:** `Pomodoro Timer`
   - **Team:** Select your Apple ID (or "None" if you don't have one)
   - **Organization Identifier:** `com.yourname` (replace "yourname" with your name)
   - **Bundle Identifier:** This will auto-fill (leave it)
   - **Interface:** Select **SwiftUI**
   - **Language:** Select **Swift**
   - **Storage:** Select **None** (we don't need Core Data)
   - **Include Tests:** You can uncheck this for now
   - Click **Next**

5. **Choose Location:**
   - Navigate to where you want to save the project
   - **IMPORTANT:** Don't save it in the same folder as these source files
   - Create a new folder like "PomodoroTimerProject" and save there
   - Click **Create**

## Step 3: Replace Default Files

1. **In Xcode, you'll see some default files:**
   - `PomodoroTimerApp.swift` (or `App.swift`)
   - `ContentView.swift`
   - You might see `Assets.xcassets` and other files

2. **Delete the default Swift files:**
   - Right-click on `PomodoroTimerApp.swift` → **Delete** → **Move to Trash**
   - Right-click on `ContentView.swift` → **Delete** → **Move to Trash**

3. **Add the project files:**
   - Go to **File → Add Files to "PomodoroTimer"...**
   - Navigate to the folder where these source files are located
   - Select ALL the `.swift` files:
     - `PomodoroTimerApp.swift`
     - `ContentView.swift`
     - `PomodoroTimerManager.swift`
     - `TouchBarController.swift`
     - `SoundManager.swift`
   - Make sure **"Copy items if needed"** is checked
   - Make sure **"Add to targets: Pomodoro Timer"** is checked
   - Click **Add**

4. **Add Info.plist:**
   - Right-click on the project name in the left sidebar
   - Select **Add Files to "PomodoroTimer"...**
   - Select `Info.plist`
   - Make sure it's added to the target
   - Click **Add**

## Step 4: Configure Project Settings

1. **Select your project** in the left sidebar (the blue icon at the top)

2. **Select the "Pomodoro Timer" target** (under TARGETS)

3. **Go to "Signing & Capabilities" tab:**
   - Check **"Automatically manage signing"**
   - Select your **Team** (your Apple ID)

4. **Go to "General" tab:**
   - Make sure **"Deployment Target"** is set to **macOS 11.0** or later
   - This ensures Touch Bar support

## Step 5: Build and Run

1. **Select a scheme:**
   - At the top of Xcode, next to the Play button
   - Make sure "Pomodoro Timer" and "My Mac" are selected

2. **Build the project:**
   - Press **⌘ + B** (Command + B) or click **Product → Build**
   - Wait for it to compile (you'll see "Build Succeeded" if successful)

3. **Run the app:**
   - Press **⌘ + R** (Command + R) or click the **Play button** (▶️)
   - The app should launch!

## Troubleshooting

### "No such module 'SwiftUI'"
- Make sure you selected **SwiftUI** as the interface when creating the project
- Check that your Deployment Target is macOS 11.0+

### "Cannot find 'PomodoroTimerManager' in scope"
- Make sure all `.swift` files are added to the target
- Select each file and check the "Target Membership" in the right sidebar
- Make sure "Pomodoro Timer" is checked

### Touch Bar not showing
- Make sure you're running on a MacBook Pro with Touch Bar
- The Touch Bar should appear automatically when the app is active
- Try clicking on the app window to make it active

### Build errors
- Make sure all files are properly added to the project
- Try **Product → Clean Build Folder** (⌘ + Shift + K)
- Then build again (⌘ + B)

## Next Steps

Once the app is running:
1. Click "Start" to begin a work session
2. The app will go full-screen
3. Use the Touch Bar to control the timer
4. Enjoy your Pomodoro sessions!

## Need Help?

- Check the main `README.md` for more information
- Read the code comments - they explain what each part does
- Search online for Swift/SwiftUI tutorials
- Apple's documentation: https://developer.apple.com/documentation/

Good luck with your first app! 🎉


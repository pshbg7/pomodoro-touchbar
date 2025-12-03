# Creating the Xcode Project from Scratch

Since you only have the source files, you need to create an Xcode project and add all the files to it. Follow these steps:

## Step 1: Create New Xcode Project

1. **Open Xcode**

2. **Create a new project:**
   - Choose **"File" → "New" → "Project"**
   - Or press **⌘ + Shift + N**

3. **Select template:**
   - Choose **"macOS"** (at the top)
   - Select **"App"** (the first option)
   - Click **"Next"**

4. **Configure the project:**
   - **Product Name:** `Pomodoro Timer`
   - **Team:** Select your Apple ID (or "None" if you don't have one)
   - **Organization Identifier:** `com.yourname` (replace "yourname" with your name)
   - **Bundle Identifier:** This will auto-fill (leave it)
   - **Interface:** Select **"SwiftUI"**
   - **Language:** Select **"Swift"**
   - **Storage:** Select **"None"** (we don't need Core Data)
   - **Include Tests:** You can uncheck this for now
   - Click **"Next"**

5. **Choose location:**
   - **IMPORTANT:** Choose a DIFFERENT folder than where your source files are
   - For example, create a new folder called "PomodoroTimerProject" on your Desktop
   - Click **"Create"**

## Step 2: Delete Default Files

1. **In Xcode, you'll see some default files:**
   - `PomodoroTimerApp.swift` (or `App.swift`)
   - `ContentView.swift`
   - You might see `Assets.xcassets` and other files

2. **Delete the default Swift files:**
   - Right-click on `PomodoroTimerApp.swift` → **Delete** → **Move to Trash**
   - Right-click on `ContentView.swift` → **Delete** → **Move to Trash**

## Step 3: Add Your Source Files

1. **Add all Swift files:**
   - Go to **File → Add Files to "PomodoroTimer"...**
   - Navigate to the folder where your source files are located (`/Users/isaac/pomodoro timer/`)
   - Select ALL the `.swift` files:
     - `PomodoroTimerApp.swift`
     - `ContentView.swift`
     - `PomodoroTimerManager.swift`
     - `TouchBarController.swift`
     - `SoundManager.swift`
     - `LaunchAtLoginHelper.swift`
     - `GlobalShortcutManager.swift`
     - `DFRPrivateAPI.swift`
   - Make sure **"Copy items if needed"** is checked
   - Make sure **"Add to targets: Pomodoro Timer"** is checked
   - Click **"Add"**

2. **Verify files are added:**
   - Check the left sidebar in Xcode
   - You should see all the Swift files listed
   - Make sure they're all under the "Pomodoro Timer" folder/group

## Step 4: Configure Project Settings

1. **Select your project** in the left sidebar (the blue icon at the top)

2. **Select the "Pomodoro Timer" target** (under TARGETS)

3. **Go to "Signing & Capabilities" tab:**
   - Check **"Automatically manage signing"**
   - Select your **Team** (your Apple ID)

4. **Go to "General" tab:**
   - Make sure **"Deployment Target"** is set to **macOS 11.0** or later
   - This ensures Touch Bar support

5. **Go to "Build Settings" tab:**
   - Search for "Swift Language Version"
   - Make sure it's set to **Swift 5** or later

## Step 5: Build and Test

1. **Select a scheme:**
   - At the top of Xcode, next to the Play button
   - Make sure "Pomodoro Timer" and "My Mac" are selected

2. **Build the project:**
   - Press **⌘ + B** (Command + B) or click **Product → Build**
   - Wait for it to compile (you'll see "Build Succeeded" if successful)

3. **Run the app:**
   - Press **⌘ + R** (Command + R) or click the **Play button** (▶️)
   - The app should launch!

## Step 6: Export the App

Once it builds successfully:

1. **Build again** (⌘ + B)

2. **Find the built app:**
   - In the left sidebar, expand "Products"
   - Right-click on "Pomodoro Timer.app"
   - Select **"Show in Finder"**

3. **Copy to Applications:**
   - Drag the `.app` file to your Applications folder
   - Double-click to launch!

## Troubleshooting

### "Cannot find 'PomodoroTimerManager' in scope"
- Make sure all `.swift` files are added to the target
- Select each file and check the "Target Membership" in the right sidebar
- Make sure "Pomodoro Timer" is checked

### "No such module 'SwiftUI'"
- Make sure you selected **SwiftUI** as the interface when creating the project
- Check that your Deployment Target is macOS 11.0+

### Build errors
- Make sure all files are properly added to the project
- Try **Product → Clean Build Folder** (⌘ + Shift + K)
- Then build again (⌘ + B)

### Files not showing in Xcode
- Make sure you selected "Copy items if needed" when adding files
- Try adding files again if they didn't copy properly

## Quick Checklist

- [ ] Created new Xcode project (macOS App, SwiftUI)
- [ ] Deleted default Swift files
- [ ] Added all source files to project
- [ ] Verified all files are in target
- [ ] Set Deployment Target to macOS 11.0+
- [ ] Built successfully (⌘ + B)
- [ ] Ran the app (⌘ + R)
- [ ] Exported to Applications folder

Once you complete these steps, you'll have a working Xcode project and can build/export your app!




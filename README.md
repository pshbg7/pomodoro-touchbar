# Pomodoro Timer for macOS with Touch Bar

A beautiful, distraction-free Pomodoro timer app designed specifically for MacBook Pro with Touch Bar support. This app helps you maintain focus with 25-minute work sessions followed by 5-minute breaks.

## Features

- ⏱️ **25-minute work sessions** with automatic 5-minute breaks
- 🎯 **Full-screen blocking view** that prevents distractions during work
- 📱 **Touch Bar integration** - Control the timer directly from your MacBook Pro's Touch Bar
  - **Always available** - Touch Bar is accessible even when the app window is closed
  - **Launch from Touch Bar** - Start your Pomodoro timer right from the Touch Bar at any time
  - **Menu bar icon** - Quick access via the menu bar (top right)
- 🔊 **Sound notifications** when sessions complete
- 🎨 **Beautiful, modern UI** with large, readable timer display
- 🔄 **Automatic cycling** between work and break sessions
- 🔄 **Background operation** - App stays running even when window is closed, keeping Touch Bar active

## Requirements

- macOS 11.0 (Big Sur) or later
- MacBook Pro with Touch Bar (for Touch Bar features)
- Xcode 13.0 or later (for building)

## Building the App

Since you're new to coding, here's a step-by-step guide to build and run this app:

### Option 1: Using Xcode (Recommended)

1. **Open Xcode** (download from the Mac App Store if you don't have it)

2. **Create a new project:**
   - Open Xcode
   - Choose "File" → "New" → "Project"
   - Select "macOS" → "App"
   - Click "Next"
   - Fill in:
     - Product Name: `Pomodoro Timer`
     - Team: Your Apple ID (or leave default)
     - Organization Identifier: `com.yourname` (or any identifier)
     - Interface: `SwiftUI`
     - Language: `Swift`
   - Choose a location and click "Create"

3. **Replace the default files:**
   - Delete the default `ContentView.swift` and `PomodoroTimerApp.swift` files
   - Copy all the `.swift` files from this project into your Xcode project
   - Make sure all files are added to your target (check the Target Membership in the File Inspector)

4. **Configure the project:**
   - Select your project in the navigator
   - Go to "Signing & Capabilities"
   - Make sure "Automatically manage signing" is checked
   - Select your team

5. **Build and run:**
   - Press `Cmd + R` or click the Play button
   - The app will launch!

6. **Export the app:**
   - After building, right-click "Pomodoro Timer" in the Products folder
   - Select "Show in Finder"
   - Drag the `.app` file to your Applications folder
   - See `EXPORT_GUIDE.md` for detailed instructions

### Option 2: Using Swift Package Manager (Advanced)

If you prefer command line, you can create a Package.swift file, but Xcode is much easier for beginners.

## How to Use

### First Time Setup

1. **Launch the app** - The app will automatically:
   - Add itself to "Launch at Login" (so it starts when you boot your Mac)
   - Set up the Touch Bar controls
   - Create a menu bar icon (timer icon in the top menu bar)

2. **Touch Bar Setup (Important!):**
   - The Touch Bar will appear when the app is running
   - To make it always accessible, you can customize it in System Preferences:
     - Go to **System Preferences → Keyboard → Touch Bar shows**
     - Choose **"App Controls"** or **"F1, F2, etc. Keys"**
     - The Pomodoro Timer controls will appear when the app is active
   - **Tip:** Since the app runs in the background, the Touch Bar will be available whenever you need it

3. **Using the App:**

1. **Start a work session:**
   - **From Touch Bar:** Press the green "Start" button on your Touch Bar (no need to open the app!)
   - **From Menu Bar:** Click the timer icon in the menu bar, then click "Show Window", then click "Start"
   - The app will automatically go full-screen to block distractions
   - Focus on your work for 25 minutes

2. **During work:**
   - The timer counts down on your screen
   - You can pause/resume from the Touch Bar or the on-screen buttons
   - The full-screen view prevents you from accessing other apps

3. **When work session ends:**
   - A sound will play
   - The app automatically switches to break mode
   - The full-screen view disappears
   - A 5-minute break timer starts automatically

4. **After break:**
   - Another sound plays
   - The app automatically starts a new 25-minute work session
   - Full-screen blocking resumes

5. **Touch Bar controls & Global Shortcut:**
   - **Global Shortcut: Press ⌘+Shift+P from anywhere** to instantly activate the app and show Touch Bar controls!
   - This works from any app - just press the shortcut and the Pomodoro Timer will activate
   - The Touch Bar will immediately show with all controls
   - **Timer display** - Shows current time remaining (e.g., "25:00")
   - **Start/Pause button** - Green when stopped, orange when running
   - **Skip button** - Blue button to skip to next session
   - **Reset button** - Red button to reset the timer
   - The global shortcut also toggles the timer (starts if stopped, pauses if running)
   
6. **Menu Bar Access:**
   - Look for the timer icon (⏱️) in your menu bar (top right)
   - **Left-click** to show/hide the main window
   - **Right-click** for menu with options:
     - Show Window
     - Launch at Login (toggle on/off)
     - Quit Pomodoro Timer
   - The app runs in the background, so the Touch Bar stays active even when the window is closed

### Instant Access from Anywhere

**Global Shortcut: ⌘+Shift+P**
- Press this combination from **any app** to instantly:
  - Activate Pomodoro Timer
  - Show the Touch Bar with all controls
  - Toggle the timer (start if stopped, pause if running)
- This is the fastest way to access the timer without clicking anything!

**Other Access Methods:**
1. **Menu Bar Icon** - Click the timer icon (⏱️) in the menu bar
2. **Global Shortcut** - Press ⌘+Shift+P from anywhere
3. **App Window** - Click the Pomodoro Timer window if it's open

**Note:** macOS shows Touch Bar controls for the currently active app. To see Pomodoro Timer controls:
- Use the global shortcut (⌘+Shift+P) - fastest method!
- Or click the menu bar icon to activate the app
- The Touch Bar will appear immediately when the app is active

## Project Structure

```
Pomodoro Timer/
├── PomodoroTimerApp.swift      # Main app entry point
├── ContentView.swift            # Main UI and full-screen view
├── PomodoroTimerManager.swift   # Timer logic and state management
├── TouchBarController.swift     # Touch Bar integration
├── SoundManager.swift           # Audio notifications
├── LaunchAtLoginHelper.swift    # Launch at login functionality
├── Info.plist                   # App configuration
└── README.md                    # This file
```

## Architecture

This app follows best practices for macOS development:

- **MVVM Pattern**: Separates UI (View) from business logic (ViewModel/Manager)
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for state management
- **Separation of Concerns**: Each file has a single responsibility
- **ObservableObject**: Proper state management with SwiftUI

## Customization

You can easily customize the timer durations by editing `PomodoroTimerManager.swift`:

```swift
private let workDuration: TimeInterval = 25 * 60 // Change 25 to your preferred minutes
private let breakDuration: TimeInterval = 5 * 60  // Change 5 to your preferred minutes
```

## Troubleshooting

**Touch Bar not showing:**
- Make sure you're running on a MacBook Pro with Touch Bar
- Check that the app has proper permissions
- Try restarting the app

**Sound not playing:**
- Check your Mac's sound settings
- Make sure volume is not muted
- The app uses system sounds, so ensure system sounds are enabled

**App won't build:**
- Make sure all files are added to the target
- Check that you're using macOS 11.0+ as the deployment target
- Verify all imports are correct

## Future Enhancements

Potential features you could add:
- Customizable work/break durations
- Statistics tracking
- Multiple timer presets
- Dark/light mode themes
- Notification center integration

## License

This project is open source and available for personal use.

## Support

Since this is your first coding project, don't hesitate to:
- Read the code comments (they explain what each part does)
- Experiment with changing values
- Search online for Swift/SwiftUI documentation
- Ask questions in developer communities

Enjoy your new Pomodoro timer! 🍅


# Control Strip Integration - How It Works

Based on TouchSwitcher's implementation (https://hazeover.com/touchswitcher.html), I've implemented Control Strip integration for Pomodoro Timer.

## How It Works

The app now adds a button to the **Control Strip** area (where volume and brightness are) that:
- Shows a timer icon (⏱️) or tomato emoji (🍅)
- Changes color based on timer state (green = stopped, orange = running)
- One tap activates the app and shows full Touch Bar controls
- Toggles the timer automatically

## Important Notes

⚠️ **Only one custom control can be shown in the Control Strip at a time**
- If another app (like Safari, Xcode, or TouchSwitcher) adds a Control Strip item, it may displace the Pomodoro Timer button
- Use the global shortcut (⌘+Shift+P) to bring it back if it disappears

## Usage

1. **Launch the app** - The Control Strip button appears automatically
2. **Tap the button** in the Control Strip to:
   - Activate Pomodoro Timer
   - Show full Touch Bar with all controls
   - Toggle the timer (start if stopped, pause if running)

## If the Button Disappears

If the Control Strip button gets displaced by another app:
- Press **⌘+Shift+P** to activate the app and restore the button
- Or click the menu bar icon (⏱️) to activate the app

## Technical Details

The implementation uses `NSTouchBar.presentSystemModalFunctionBar()` to add the item to the Control Strip, similar to how TouchSwitcher works. This is a supported macOS API for adding custom controls to the Control Strip area.

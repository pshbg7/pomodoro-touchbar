//
//  PomodoroTimerApp.swift
//  Pomodoro Timer
//
//  Created for macOS with Touch Bar support
//

import SwiftUI
import AppKit

@main
struct PomodoroTimerApp: App {
    @StateObject private var timerManager = PomodoroTimerManager()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Store timer manager reference in AppDelegate for early setup
        // This will be used in applicationDidFinishLaunching
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    // Store timer manager in AppDelegate for Touch Bar setup
                    appDelegate.timerManager = timerManager
                    
                    // Setup Touch Bar if not already set up
                    if appDelegate.touchBarController == nil {
                        appDelegate.setupTouchBar(with: timerManager)
                    }
                    
                    // Configure window to be fullscreen-capable
                    DispatchQueue.main.async {
                        if let window = NSApplication.shared.windows.first {
                            window.collectionBehavior = [.fullScreenPrimary, .fullScreenAuxiliary]
                            
                            // Also set Touch Bar on window for better integration
                            if let touchBar = appDelegate.touchBarController?.makeTouchBar() {
                                window.touchBar = touchBar
                            }
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

// AppDelegate to handle Touch Bar and menu bar
class AppDelegate: NSObject, NSApplicationDelegate {
    var touchBarController: TouchBarController?
    var timerManager: PomodoroTimerManager?
    private var statusBarItem: NSStatusItem?
    private var popover: NSPopover?
    
    func setupTouchBar(with timerManager: PomodoroTimerManager, for window: NSWindow? = nil) {
        self.timerManager = timerManager
        
        // Only setup if not already set up
        if touchBarController == nil {
            touchBarController = TouchBarController()
            touchBarController?.setup(with: timerManager)
        }
        
        // Set Touch Bar at application level so it's always available
        // This makes it accessible even when the app window isn't focused
        if let touchBar = touchBarController?.makeTouchBar() {
            NSApplication.shared.touchBar = touchBar
            // Also set it on the window if provided
            if let window = window {
                window.touchBar = touchBar
            }
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item for easy access
        setupMenuBar()
        
        // Configure app to run in background (accessory mode)
        // This allows the app to stay running and keep Touch Bar active
        // even when the window is closed
        NSApp.setActivationPolicy(.accessory)
        
        // Setup Touch Bar immediately if timer manager is available
        // This ensures Touch Bar is available right from startup
        if let timerManager = timerManager {
            setupTouchBar(with: timerManager)
            
            // Setup global shortcut for instant access from anywhere
            GlobalShortcutManager.shared.setup(with: timerManager)
        }
        
        // Enable launch at login by default (user can disable in menu)
        if !LaunchAtLoginHelper.shared.isEnabled {
            _ = LaunchAtLoginHelper.shared.enable()
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // Show window when clicking dock icon or menu bar item
        if !flag {
            for window in sender.windows {
                window.makeKeyAndOrderFront(nil)
            }
        }
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up
        statusBarItem = nil
    }
    
    private func setupMenuBar() {
        // Create status bar item (menu bar icon)
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusBarItem?.button {
            // Use timer icon
            if #available(macOS 11.0, *) {
                button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Pomodoro Timer")
            } else {
                // Fallback for older macOS
                button.title = "🍅"
            }
            button.image?.isTemplate = true
            button.action = #selector(toggleMenu)
            button.target = self
            button.toolTip = "Pomodoro Timer - Click for menu"
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }
    
    @objc private func toggleMenu(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == .rightMouseUp {
            // Right click - show menu
            showMenu(sender)
        } else {
            // Left click - show/hide window
            showMainWindow()
        }
    }
    
    private func showMenu(_ sender: NSStatusBarButton) {
        let menu = NSMenu()
        
        // Show Window
        let showWindowItem = NSMenuItem(title: "Show Window", action: #selector(showMainWindow), keyEquivalent: "")
        showWindowItem.target = self
        menu.addItem(showWindowItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Launch at Login
        let launchAtLoginItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginItem.target = self
        launchAtLoginItem.state = LaunchAtLoginHelper.shared.isEnabled ? .on : .off
        menu.addItem(launchAtLoginItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        let quitItem = NSMenuItem(title: "Quit Pomodoro Timer", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusBarItem?.menu = menu
        statusBarItem?.button?.performClick(nil)
        statusBarItem?.menu = nil
    }
    
    @objc private func toggleLaunchAtLogin() {
        if LaunchAtLoginHelper.shared.isEnabled {
            _ = LaunchAtLoginHelper.shared.disable()
        } else {
            _ = LaunchAtLoginHelper.shared.enable()
        }
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    @objc private func showMainWindow() {
        // Show main window when menu bar item is clicked
        // Find the main app window (skip status bar and other system windows)
        for window in NSApplication.shared.windows {
            // Only make key windows that can become key (excludes status bar windows)
            if window.canBecomeKey {
                window.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                return
            }
        }
        
        // If no window exists, activate app to create one
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // Public method to get timer manager for setup
    func getTimerManager() -> PomodoroTimerManager? {
        return timerManager
    }
}


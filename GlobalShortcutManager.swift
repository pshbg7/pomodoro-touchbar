//
//  GlobalShortcutManager.swift
//  Pomodoro Timer
//
//  Manages global keyboard shortcuts to activate the app from anywhere
//

import AppKit

class GlobalShortcutManager {
    static let shared = GlobalShortcutManager()
    
    private var monitor: Any?
    private var timerManager: PomodoroTimerManager?
    
    private init() {}
    
    func setup(with timerManager: PomodoroTimerManager) {
        self.timerManager = timerManager
        
        // Register global hotkey: Cmd+Shift+P for Pomodoro
        registerGlobalHotkey()
    }
    
    private func registerGlobalHotkey() {
        // Use NSEvent to monitor for Cmd+Shift+P globally
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            // Check for Cmd+Shift+P
            if event.modifierFlags.contains([.command, .shift]) && 
               event.charactersIgnoringModifiers?.lowercased() == "p" {
                self?.handleHotKey()
            }
        }
    }
    
    private func handleHotKey() {
        DispatchQueue.main.async {
            // Activate the app
            NSApp.activate(ignoringOtherApps: true)
            
            // Show the main window
            if let window = NSApplication.shared.windows.first {
                window.makeKeyAndOrderFront(nil)
            }
            
            // Toggle timer if it exists
            if let timerManager = self.timerManager {
                if timerManager.isRunning {
                    timerManager.pause()
                } else {
                    timerManager.start()
                }
            }
        }
    }
    
    deinit {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}


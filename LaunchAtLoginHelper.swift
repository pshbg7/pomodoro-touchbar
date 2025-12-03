//
//  LaunchAtLoginHelper.swift
//  Pomodoro Timer
//
//  Helper to manage launch at login functionality
//

import Foundation
import ServiceManagement

class LaunchAtLoginHelper {
    static let shared = LaunchAtLoginHelper()
    
    private let bundleIdentifier: String
    
    private init() {
        // Get the app's bundle identifier
        bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.pomodoro.timer"
    }
    
    var isEnabled: Bool {
        // Check if app is in login items
        if #available(macOS 13.0, *) {
            // Use modern SMAppService API
            return SMAppService.mainApp.status == .enabled
        } else {
            // For macOS 11-12, we'll use a simple approach
            // Check if the app is registered (this is a simplified check)
            // Note: Full support requires macOS 13+ for SMAppService
            return false // Will be set when enabled
        }
    }
    
    func enable() -> Bool {
        if #available(macOS 13.0, *) {
            // Use modern SMAppService API (macOS 13+)
            do {
                try SMAppService.mainApp.register()
                return true
            } catch {
                print("Failed to enable launch at login: \(error)")
                return false
            }
        } else {
            // For macOS 11-12, provide user instructions
            // The modern API requires macOS 13+, so we'll show a message
            print("Launch at login requires macOS 13.0 or later for automatic setup.")
            print("You can manually add the app to Login Items in System Preferences.")
            return false
        }
    }
    
    func disable() -> Bool {
        if #available(macOS 13.0, *) {
            // Use modern SMAppService API
            do {
                try SMAppService.mainApp.unregister()
                return true
            } catch {
                print("Failed to disable launch at login: \(error)")
                return false
            }
        } else {
            // For macOS 11-12, user needs to manually remove from Login Items
            print("Please remove the app from Login Items in System Preferences.")
            return false
        }
    }
}


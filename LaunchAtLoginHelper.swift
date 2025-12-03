//
//  LaunchAtLoginHelper.swift
//  Pomodoro Timer
//
//  Helper to manage launch at login functionality
//

import Foundation
import ServiceManagement
import CoreServices

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
            // Fallback: check login items list
            return isInLoginItems()
        }
    }
    
    func enable() -> Bool {
        if #available(macOS 13.0, *) {
            // Use modern SMAppService API
            do {
                try SMAppService.mainApp.register()
                return true
            } catch {
                print("Failed to enable launch at login: \(error)")
                return false
            }
        } else {
            // Fallback: use login items
            return addToLoginItems()
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
            // Fallback: remove from login items
            return removeFromLoginItems()
        }
    }
    
    // MARK: - Legacy Methods (for macOS < 13)
    
    private func isInLoginItems() -> Bool {
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue() else {
            return false
        }
        
        let appURL = Bundle.main.bundleURL as CFURL
        let loginItemsArray = LSSharedFileListCopySnapshot(loginItems, nil)?.takeRetainedValue() as? [LSSharedFileListItem]
        
        guard let loginItemsArray = loginItemsArray else {
            return false
        }
        
        for item in loginItemsArray {
            if let itemURL = LSSharedFileListItemCopyResolvedURL(item, 0, nil)?.takeRetainedValue() {
                // Compare CFURLs using CFEqual
                if CFEqual(itemURL, appURL) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func addToLoginItems() -> Bool {
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue() else {
            return false
        }
        
        let appURL = Bundle.main.bundleURL as CFURL
        LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst.takeUnretainedValue(), nil, nil, appURL, nil, nil)
        
        return true
    }
    
    private func removeFromLoginItems() -> Bool {
        guard let loginItems = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeUnretainedValue(), nil)?.takeRetainedValue() else {
            return false
        }
        
        let appURL = Bundle.main.bundleURL as CFURL
        let loginItemsArray = LSSharedFileListCopySnapshot(loginItems, nil)?.takeRetainedValue() as? [LSSharedFileListItem]
        
        guard let loginItemsArray = loginItemsArray else {
            return false
        }
        
        for item in loginItemsArray {
            if let itemURL = LSSharedFileListItemCopyResolvedURL(item, 0, nil)?.takeRetainedValue() {
                // Compare CFURLs using CFEqual
                if CFEqual(itemURL, appURL) {
                    LSSharedFileListItemRemove(loginItems, item)
                    return true
                }
            }
        }
        
        return false
    }
}


//
//  DFRPrivateAPI.swift
//  Pomodoro Timer
//
//  Private API declarations for Control Strip integration
//  Similar to how TouchSwitcher implements Control Strip items
//
//  WARNING: These are private APIs and may not work in future macOS versions
//

import AppKit
import Foundation
import Darwin

// Private API declarations for DFRFoundation framework
// These are used to add items to the Control Strip (where volume/brightness are)
// We use dynamic loading to access these private APIs

class DFRPrivateAPI {
    private static var dfrFoundationHandle: UnsafeMutableRawPointer?
    
    static func loadDFRFoundation() -> Bool {
        guard dfrFoundationHandle == nil else { return true }
        
        // Try to load DFRFoundation framework dynamically
        if let handle = dlopen("/System/Library/PrivateFrameworks/DFRFoundation.framework/DFRFoundation", RTLD_LAZY) {
            dfrFoundationHandle = handle
            return true
        }
        return false
    }
    
    static func DFRElementSetControlStripPresenceForIdentifier(_ identifier: String, _ enabled: Bool) {
        guard loadDFRFoundation() else { return }
        
        // Get the function pointer
        if let symbol = dlsym(dfrFoundationHandle, "DFRElementSetControlStripPresenceForIdentifier") {
            typealias FunctionType = @convention(c) (CFString, Bool) -> Void
            let function = unsafeBitCast(symbol, to: FunctionType.self)
            function(identifier as CFString, enabled)
        }
    }
    
    static func DFRSystemModalShowsCloseBoxWhenFrontMost(_ enabled: Bool) {
        guard loadDFRFoundation() else { return }
        
        // Get the function pointer
        if let symbol = dlsym(dfrFoundationHandle, "DFRSystemModalShowsCloseBoxWhenFrontMost") {
            typealias FunctionType = @convention(c) (Bool) -> Void
            let function = unsafeBitCast(symbol, to: FunctionType.self)
            function(enabled)
        }
    }
}

// Extension to add system tray item functionality using Objective-C runtime
extension NSTouchBarItem {
    static func addSystemTrayItem(_ item: NSTouchBarItem) {
        // Use Objective-C runtime to call the private method
        let selector = NSSelectorFromString("addSystemTrayItem:")
        if responds(to: selector) {
            perform(selector, with: item)
        }
    }
}


//
//  TouchBarController.swift
//  Pomodoro Timer
//
//  Touch Bar integration for MacBook Pro
//

import AppKit
import Combine

// Import private API declarations
// Note: These are private APIs used by apps like TouchSwitcher
// They may not work in future macOS versions

class TouchBarController: NSObject, NSTouchBarDelegate {
    private var timerManager: PomodoroTimerManager?
    private var touchBar: NSTouchBar?
    private var cancellables = Set<AnyCancellable>()
    
    // Touch Bar item identifiers
    private let timerLabelIdentifier = NSTouchBarItem.Identifier("com.pomodoro.timerLabel")
    private let startPauseIdentifier = NSTouchBarItem.Identifier("com.pomodoro.startPause")
    private let skipIdentifier = NSTouchBarItem.Identifier("com.pomodoro.skip")
    private let resetIdentifier = NSTouchBarItem.Identifier("com.pomodoro.reset")
    private let continueIdentifier = NSTouchBarItem.Identifier("com.pomodoro.continue")
    private let controlStripIdentifier = NSTouchBarItem.Identifier("com.pomodoro.controlStrip")
    
    // References to Touch Bar items for updates
    private weak var timerLabel: NSTextField?
    private weak var startPauseButton: NSButton?
    private weak var controlStripButton: NSButton?
    
    func setup(with timerManager: PomodoroTimerManager) {
        self.timerManager = timerManager
        
        // Create Touch Bar
        touchBar = NSTouchBar()
        touchBar?.delegate = self
        
        // Set custom identifier so it can be customized in System Preferences
        touchBar?.customizationIdentifier = NSTouchBar.CustomizationIdentifier("com.pomodoro.timer.customization")
        
        // Make items customizable so user can rearrange them
        // Include control strip item so it can be added to control strip
        touchBar?.customizationAllowedItemIdentifiers = [
            timerLabelIdentifier,
            startPauseIdentifier,
            skipIdentifier,
            resetIdentifier,
            continueIdentifier,
            controlStripIdentifier
        ]
        
        // Update item identifiers based on state
        updateTouchBarItems()
        
        // Observe completion modal to update Touch Bar
        timerManager.$showCompletionModal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateTouchBarItems()
            }
            .store(in: &cancellables)
        
        // Setup control strip item (always visible)
        setupControlStripItem()
        
        // Observe timer changes to update Touch Bar
        timerManager.$timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeRemaining in
                // Format the time
                let minutes = Int(timeRemaining) / 60
                let seconds = Int(timeRemaining) % 60
                let formattedTime = String(format: "%02d:%02d", minutes, seconds)
                self?.timerLabel?.stringValue = formattedTime
            }
            .store(in: &cancellables)
        
        timerManager.$isRunning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRunning in
                self?.startPauseButton?.title = isRunning ? "Pause" : "Start"
                self?.startPauseButton?.bezelColor = isRunning ? .systemOrange : .systemGreen
            }
            .store(in: &cancellables)
    }
    
    func makeTouchBar() -> NSTouchBar? {
        return touchBar
    }
    
    // MARK: - NSTouchBarDelegate
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        guard let timerManager = timerManager else { return nil }
        
        switch identifier {
        case timerLabelIdentifier:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let label = NSTextField(labelWithString: timerManager.formattedTime)
            label.font = NSFont.monospacedSystemFont(ofSize: 20, weight: .regular)
            label.textColor = .white
            item.view = label
            timerLabel = label
            return item
            
        case startPauseIdentifier:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(
                title: timerManager.isRunning ? "Pause" : "Start",
                target: self,
                action: #selector(startPauseTapped)
            )
            button.bezelColor = timerManager.isRunning ? .systemOrange : .systemGreen
            item.view = button
            startPauseButton = button
            return item
            
        case skipIdentifier:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(
                title: "Skip",
                target: self,
                action: #selector(skipTapped)
            )
            button.bezelColor = .systemBlue
            item.view = button
            return item
            
        case resetIdentifier:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(
                title: "Reset",
                target: self,
                action: #selector(resetTapped)
            )
            button.bezelColor = .systemRed
            item.view = button
            return item
            
        case continueIdentifier:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(
                title: "Continue",
                target: self,
                action: #selector(continueTapped)
            )
            button.bezelColor = .systemGreen
            item.view = button
            return item
            
        case controlStripIdentifier:
            return createControlStripItem()
            
        default:
            return nil
        }
    }
    
    private func setupControlStripItem() {
        // Create and register control strip item
        // This will appear in the system control strip area (right side of Touch Bar)
        // Similar to how TouchSwitcher works
        if let controlStripItem = createControlStripItem() {
            // Present the control strip item using system modal function bar
            presentControlStripItem(controlStripItem)
        }
    }
    
    private func createControlStripItem() -> NSCustomTouchBarItem? {
        guard let timerManager = timerManager else { return nil }
        
        let item = NSCustomTouchBarItem(identifier: controlStripIdentifier)
        
        // Create a compact button for Control Strip
        // Show ONLY the time remaining (no icon)
        let button = NSButton()
        button.target = self
        button.action = #selector(controlStripTapped)
        
        // Show time only - no icon
        button.title = timerManager.formattedTime
        button.imagePosition = .noImage
        button.image = nil
        
        // Style the button - color indicates state
        button.bezelColor = timerManager.isRunning ? .systemOrange : .systemGreen
        button.font = NSFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        
        // Compact size for Control Strip - text only
        button.frame = NSRect(x: 0, y: 0, width: 60, height: 30)
        
        item.view = button
        controlStripButton = button
        
        // Observe timer changes to update control strip button with time
        timerManager.$timeRemaining
            .receive(on: DispatchQueue.main)
            .sink { [weak self, weak button] timeRemaining in
                guard let button = button, let self = self, let timerManager = self.timerManager else { return }
                // Update time display
                let minutes = Int(timeRemaining) / 60
                let seconds = Int(timeRemaining) % 60
                let formattedTime = String(format: "%02d:%02d", minutes, seconds)
                button.title = formattedTime
                // Update color based on state
                self.updateControlStripButton(button, timerManager: timerManager)
            }
            .store(in: &cancellables)
        
        timerManager.$isRunning
            .receive(on: DispatchQueue.main)
            .sink { [weak button, weak self] isRunning in
                guard let button = button, let self = self, let timerManager = self.timerManager else { return }
                self.updateControlStripButton(button, timerManager: timerManager)
            }
            .store(in: &cancellables)
        
        return item
    }
    
    private func updateControlStripButton(_ button: NSButton, timerManager: PomodoroTimerManager) {
        if timerManager.isRunning {
            button.bezelColor = .systemOrange
        } else {
            button.bezelColor = .systemGreen
        }
    }
    
    private func presentControlStripItem(_ item: NSCustomTouchBarItem) {
        // Present the control strip item using private DFRFoundation APIs
        // This makes it appear in the Control Strip area (where volume/brightness are)
        // Note: Only one custom control can be shown at a time in the Control Strip
        // Similar to how TouchSwitcher implements this
        
        // Add the item to system tray using private API
        NSTouchBarItem.addSystemTrayItem(item)
        
        // Enable Control Strip presence for this identifier using dynamic loading
        DFRPrivateAPI.DFRElementSetControlStripPresenceForIdentifier(controlStripIdentifier.rawValue, true)
    }
    
    func showControlStripItem() {
        // Method to show the control strip item (useful if it gets displaced)
        if let controlStripItem = createControlStripItem() {
            presentControlStripItem(controlStripItem)
        }
    }
    
    func dismissControlStripItem() {
        // Disable Control Strip presence
        DFRPrivateAPI.DFRElementSetControlStripPresenceForIdentifier(controlStripIdentifier.rawValue, false)
    }
    
    @objc private func controlStripTapped() {
        // When Control Strip button is tapped:
        // 1. Activate the app
        NSApp.activate(ignoringOtherApps: true)
        
        // 2. Show the main window (only if it can become key)
        for window in NSApplication.shared.windows {
            if window.canBecomeKey {
                window.makeKeyAndOrderFront(nil)
                break
            }
        }
        
        // 3. Toggle timer
        if let timerManager = timerManager {
            if timerManager.isRunning {
                timerManager.pause()
            } else {
                timerManager.start()
            }
        }
    }
    
    @objc private func startPauseTapped() {
        guard let timerManager = timerManager else { return }
        
        if timerManager.isRunning {
            timerManager.pause()
        } else {
            timerManager.start()
        }
    }
    
    @objc private func skipTapped() {
        timerManager?.skip()
    }
    
    @objc private func resetTapped() {
        timerManager?.reset()
    }
    
    @objc private func continueTapped() {
        timerManager?.continueAfterCompletion()
    }
    
    private func updateTouchBarItems() {
        guard let timerManager = timerManager else { return }
        
        // Show Continue button when completion modal is shown, otherwise show normal controls
        if timerManager.showCompletionModal {
            touchBar?.defaultItemIdentifiers = [
                timerLabelIdentifier,
                .flexibleSpace,
                continueIdentifier
            ]
        } else {
            touchBar?.defaultItemIdentifiers = [
                timerLabelIdentifier,
                .flexibleSpace,
                startPauseIdentifier,
                skipIdentifier,
                resetIdentifier
            ]
        }
    }
}


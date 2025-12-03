//
//  PomodoroTimerManager.swift
//  Pomodoro Timer
//
//  Manages the Pomodoro timer logic and state
//

import Foundation
import Combine
import AVFoundation
import AppKit

class PomodoroTimerManager: ObservableObject {
    // Timer states
    enum TimerState {
        case idle
        case working
        case breakTime
    }
    
    // Published properties for SwiftUI
    @Published var currentState: TimerState = .idle
    @Published var timeRemaining: TimeInterval = 25 * 60 // 25 minutes in seconds
    @Published var isRunning: Bool = false
    @Published var isFullScreen: Bool = false
    @Published var showCompletionModal: Bool = false
    @Published var completionMessage: String = ""
    @Published var showSettings: Bool = false
    
    // Pomodoro sequence tracking
    @Published var pomodoroCount: Int = 0 // Current pomodoro in sequence
    @Published var isLongBreak: Bool = false // Whether current break is a long break
    
    // Customizable timer durations (in minutes, converted to seconds when used)
    @Published var workDurationMinutes: Int = 25 {
        didSet {
            if currentState == .working && !isRunning {
                timeRemaining = TimeInterval(workDurationMinutes * 60)
            }
        }
    }
    
    @Published var breakDurationMinutes: Int = 5 {
        didSet {
            // Ensure minimum break duration is 5 minutes
            if breakDurationMinutes < 5 {
                breakDurationMinutes = 5
            }
            if currentState == .breakTime && !isRunning && !isLongBreak {
                timeRemaining = TimeInterval(breakDurationMinutes * 60)
            }
        }
    }
    
    @Published var longBreakDurationMinutes: Int = 15 {
        didSet {
            if longBreakDurationMinutes < 5 {
                longBreakDurationMinutes = 5
            }
            if currentState == .breakTime && !isRunning && isLongBreak {
                timeRemaining = TimeInterval(longBreakDurationMinutes * 60)
            }
        }
    }
    
    @Published var pomodorosBeforeLongBreak: Int = 3 {
        didSet {
            if pomodorosBeforeLongBreak < 1 {
                pomodorosBeforeLongBreak = 1
            }
        }
    }
    
    // Computed properties for durations in seconds
    private var workDuration: TimeInterval {
        TimeInterval(workDurationMinutes * 60)
    }
    
    private var breakDuration: TimeInterval {
        if isLongBreak {
            return TimeInterval(longBreakDurationMinutes * 60)
        }
        return TimeInterval(breakDurationMinutes * 60)
    }
    
    // Timer and sound
    private var timer: Timer?
    private let soundManager = SoundManager()
    
    // Computed properties
    var formattedTime: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var currentMode: String {
        switch currentState {
        case .idle:
            return "Ready"
        case .working:
            return "Work Time"
        case .breakTime:
            return "Break Time"
        }
    }
    
    init() {
        resetToWork()
    }
    
    // MARK: - Timer Control
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        
        // Play start sound
        soundManager.playStartSound()
        
        // Start work session if idle
        if currentState == .idle {
            currentState = .working
            timeRemaining = workDuration
            isFullScreen = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
        
        // Add timer to run loop to keep it running
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        
        // Play pause sound
        soundManager.playPauseSound()
    }
    
    func reset() {
        pause()
        pomodoroCount = 0
        isLongBreak = false
        resetToWork()
        isFullScreen = false
    }
    
    func skip() {
        pause()
        
        // Switch to next state
        switch currentState {
        case .working:
            // Move to break - determine if long break
            pomodoroCount += 1
            isLongBreak = pomodoroCount >= pomodorosBeforeLongBreak
            currentState = .breakTime
            timeRemaining = breakDuration
            isFullScreen = false
        case .breakTime:
            // Move to work - reset count if was long break
            if isLongBreak {
                pomodoroCount = 0
                isLongBreak = false
            }
            resetToWork()
            isFullScreen = true
        case .idle:
            resetToWork()
            isFullScreen = true
        }
    }
    
    // MARK: - Private Methods
    
    private func tick() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            timerCompleted()
        }
    }
    
    private func timerCompleted() {
        // Stop the timer immediately - do not auto-continue
        pause()
        
        // Play completion sound
        soundManager.playCompletionSound()
        
        // Show completion modal - user MUST confirm to continue
        // Timer will remain stopped until user interacts
        switch currentState {
        case .working:
            // Work session complete - increment pomodoro count
            pomodoroCount += 1
            
            // Determine if next break should be long break
            let shouldTakeLongBreak = pomodoroCount >= pomodorosBeforeLongBreak
            
            if shouldTakeLongBreak {
                isLongBreak = true
                completionMessage = "POMODORO \(pomodoroCount) COMPLETE\n\nLONG BREAK: \(longBreakDurationMinutes) MINUTES"
            } else {
                isLongBreak = false
                completionMessage = "POMODORO \(pomodoroCount) COMPLETE\n\nBREAK: \(breakDurationMinutes) MINUTES"
            }
            
            showCompletionModal = true
            
            // Bring app to front
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
            
        case .breakTime:
            // Break complete - reset pomodoro count if it was a long break
            if isLongBreak {
                pomodoroCount = 0
                isLongBreak = false
            }
            
            completionMessage = "BREAK OVER\n\nSTART POMODORO \(pomodoroCount + 1)"
            showCompletionModal = true
            
            // Bring app to front
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
            
        case .idle:
            break
        }
    }
    
    // Called when user confirms to continue after timer completion
    func continueAfterCompletion() {
        // Only proceed if modal is showing (prevents accidental calls)
        guard showCompletionModal else { return }
        
        showCompletionModal = false
        
        // Switch to next state
        switch currentState {
        case .working:
            // Move to break (short or long)
            currentState = .breakTime
            timeRemaining = breakDuration
            isFullScreen = false
            
        case .breakTime:
            // Move to work
            resetToWork()
            isFullScreen = true
            
        case .idle:
            resetToWork()
            isFullScreen = true
        }
    }
    
    private func resetToWork() {
        currentState = .working
        timeRemaining = workDuration
    }
    
    deinit {
        timer?.invalidate()
    }
}



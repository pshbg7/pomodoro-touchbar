//
//  PomodoroTimerManager.swift
//  Pomodoro Timer
//
//  Manages the Pomodoro timer logic and state
//

import Foundation
import Combine
import AVFoundation

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
    
    // Timer constants
    private let workDuration: TimeInterval = 25 * 60 // 25 minutes
    private let breakDuration: TimeInterval = 5 * 60  // 5 minutes
    
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
        resetToWork()
        isFullScreen = false
    }
    
    func skip() {
        pause()
        
        // Switch to next state
        switch currentState {
        case .working:
            // Move to break
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
    
    // MARK: - Private Methods
    
    private func tick() {
        timeRemaining -= 1
        
        if timeRemaining <= 0 {
            timerCompleted()
        }
    }
    
    private func timerCompleted() {
        pause()
        soundManager.playCompletionSound()
        
        // Switch to next state
        switch currentState {
        case .working:
            // Work session complete, start break
            currentState = .breakTime
            timeRemaining = breakDuration
            isFullScreen = false
            
            // Auto-start break after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.start()
            }
            
        case .breakTime:
            // Break complete, start work
            resetToWork()
            isFullScreen = true
            
            // Auto-start work after 1 second
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.start()
            }
            
        case .idle:
            break
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



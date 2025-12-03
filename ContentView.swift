//
//  ContentView.swift
//  Pomodoro Timer
//
//  Main UI view with full-screen blocking capability
//

import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    
    var body: some View {
        ZStack {
            if timerManager.isFullScreen && timerManager.currentState == .working {
                // Full-screen blocking view during work
                FullScreenBlockingView()
                    .environmentObject(timerManager)
                    .transition(.opacity)
            } else {
                // Normal view
                ZStack {
                    // Background color
                    Color.black
                        .ignoresSafeArea()
                    
                    VStack(spacing: 60) {
                        // Pomodoro count indicator (brutalist style)
                        if timerManager.pomodoroCount > 0 {
                            HStack(spacing: 20) {
                                Text("POMODORO")
                                    .font(.system(size: 24, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .tracking(4)
                                Text("\(timerManager.pomodoroCount)")
                                    .font(.system(size: 48, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 60)
                                    .border(Color.white, width: 4)
                                    .background(Color.black)
                            }
                            .padding(.top, 40)
                        }
                        
                        // Mode indicator (brutalist)
                        Text(timerManager.currentMode.uppercased())
                            .font(.system(size: 32, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(8)
                            .padding(.top, timerManager.pomodoroCount > 0 ? 0 : 60)
                        
                        // Timer display (brutalist)
                        Text(timerManager.formattedTime)
                            .font(.system(size: 140, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .padding(20)
                            .border(Color.white, width: 6)
                            .background(Color.black)
                        
                        // Control buttons (brutalist - no rounded corners)
                        HStack(spacing: 20) {
                            if timerManager.isRunning {
                                Button(action: {
                                    timerManager.pause()
                                }) {
                                    Text("PAUSE")
                                        .font(.system(size: 20, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .tracking(2)
                                        .frame(width: 140, height: 70)
                                        .border(Color.black, width: 4)
                                        .background(Color.white)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Button(action: {
                                    timerManager.start()
                                }) {
                                    Text("START")
                                        .font(.system(size: 20, weight: .black, design: .monospaced))
                                        .foregroundColor(.white)
                                        .tracking(2)
                                        .frame(width: 140, height: 70)
                                        .border(Color.white, width: 4)
                                        .background(Color.black)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Button(action: {
                                timerManager.skip()
                            }) {
                                Text("SKIP")
                                    .font(.system(size: 20, weight: .black, design: .monospaced))
                                    .foregroundColor(.black)
                                    .tracking(2)
                                    .frame(width: 140, height: 70)
                                    .border(Color.black, width: 4)
                                    .background(Color.white)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                timerManager.reset()
                            }) {
                                Text("RESET")
                                    .font(.system(size: 20, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .tracking(2)
                                    .frame(width: 140, height: 70)
                                    .border(Color.white, width: 4)
                                    .background(Color.black)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                timerManager.showSettings = true
                            }) {
                                Text("SET")
                                    .font(.system(size: 20, weight: .black, design: .monospaced))
                                    .foregroundColor(.black)
                                    .tracking(2)
                                    .frame(width: 140, height: 70)
                                    .border(Color.black, width: 4)
                                    .background(Color.white)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.bottom, 60)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: timerManager.isFullScreen) { oldValue, newValue in
            // The view will automatically update based on the conditional ZStack above
            // When isFullScreen is true, FullScreenBlockingView covers the entire window
        }
        .onAppear {
            // Make window fullscreen-capable
            if let window = NSApplication.shared.windows.first {
                window.collectionBehavior = [.fullScreenPrimary, .fullScreenAuxiliary]
            }
        }
        .overlay {
            // Full-screen blocking completion modal
            if timerManager.showCompletionModal {
                CompletionModalView()
                    .environmentObject(timerManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.95))
                    .ignoresSafeArea()
                    .zIndex(9999)
                    .transition(.opacity)
            }
        }
        .onChange(of: timerManager.showCompletionModal) { oldValue, newValue in
            // When modal appears, bring window to front and activate app
            if newValue {
                DispatchQueue.main.async {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    if let window = NSApplication.shared.windows.first {
                        window.makeKeyAndOrderFront(nil)
                        window.level = .floating
                    }
                }
            } else {
                // Reset window level when modal disappears
                DispatchQueue.main.async {
                    if let window = NSApplication.shared.windows.first {
                        window.level = .normal
                    }
                }
            }
        }
        .sheet(isPresented: $timerManager.showSettings) {
            SettingsView()
                .environmentObject(timerManager)
        }
    }
}

// Completion Modal - appears when timer ends, requires user confirmation
// Full-screen blocking overlay that appears in front of everything (brutalist design)
struct CompletionModalView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    
    var body: some View {
        ZStack {
            // Full-screen white background (brutalist - high contrast)
            Color.white
                .ignoresSafeArea()
            
            // Center modal content
            VStack(spacing: 60) {
                // Message - brutalist style
                Text(timerManager.completionMessage)
                    .font(.system(size: 48, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 80)
                    .lineSpacing(12)
                    .tracking(4)
                    .padding(.top, 120)
                
                Spacer()
                
                // Continue button - brutalist style
                Button(action: {
                    timerManager.continueAfterCompletion()
                }) {
                    Text("CONTINUE")
                        .font(.system(size: 36, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .tracking(6)
                        .frame(width: 400, height: 100)
                        .border(Color.black, width: 6)
                        .background(Color.black)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 120)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            // Bring window to front and activate app when modal appears
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
                if let window = NSApplication.shared.windows.first {
                    window.makeKeyAndOrderFront(nil)
                    window.level = .floating
                }
            }
        }
    }
}

// Settings View for customizing durations (brutalist design)
struct SettingsView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 40) {
            // Title (brutalist)
            Text("SETTINGS")
                .font(.system(size: 32, weight: .black, design: .monospaced))
                .foregroundColor(.black)
                .tracking(8)
                .padding(.top, 40)
                .border(Color.black, width: 4)
                .padding(.horizontal, 20)
                .background(Color.white)
            
            ScrollView {
                VStack(spacing: 50) {
                    // Work Duration
                    VStack(spacing: 20) {
                        HStack {
                            Text("WORK")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .tracking(4)
                            Spacer()
                            Text("\(timerManager.workDurationMinutes) MIN")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .frame(width: 120, height: 50)
                                .border(Color.black, width: 3)
                                .background(Color.white)
                        }
                        
                        Slider(
                            value: Binding(
                                get: { Double(timerManager.workDurationMinutes) },
                                set: { timerManager.workDurationMinutes = Int($0) }
                            ),
                            in: 1...60,
                            step: 1
                        )
                        .tint(.black)
                        
                        HStack {
                            Text("1")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                            Spacer()
                            Text("60")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .border(Color.black, width: 4)
                    .background(Color.white)
                    
                    // Short Break Duration
                    VStack(spacing: 20) {
                        HStack {
                            Text("BREAK")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .tracking(4)
                            Spacer()
                            Text("\(timerManager.breakDurationMinutes) MIN")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .frame(width: 120, height: 50)
                                .border(Color.black, width: 3)
                                .background(Color.white)
                        }
                        
                        Slider(
                            value: Binding(
                                get: { Double(timerManager.breakDurationMinutes) },
                                set: { timerManager.breakDurationMinutes = Int($0) }
                            ),
                            in: 5...60,
                            step: 1
                        )
                        .tint(.black)
                        
                        HStack {
                            Text("5")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                            Spacer()
                            Text("60")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .border(Color.black, width: 4)
                    .background(Color.white)
                    
                    // Long Break Duration
                    VStack(spacing: 20) {
                        HStack {
                            Text("LONG BREAK")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .tracking(4)
                            Spacer()
                            Text("\(timerManager.longBreakDurationMinutes) MIN")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .frame(width: 120, height: 50)
                                .border(Color.black, width: 3)
                                .background(Color.white)
                        }
                        
                        Slider(
                            value: Binding(
                                get: { Double(timerManager.longBreakDurationMinutes) },
                                set: { timerManager.longBreakDurationMinutes = Int($0) }
                            ),
                            in: 5...60,
                            step: 1
                        )
                        .tint(.black)
                        
                        HStack {
                            Text("5")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                            Spacer()
                            Text("60")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .border(Color.black, width: 4)
                    .background(Color.white)
                    
                    // Pomodoros Before Long Break
                    VStack(spacing: 20) {
                        HStack {
                            Text("POMODOROS BEFORE LONG BREAK")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .tracking(4)
                            Spacer()
                            Text("\(timerManager.pomodorosBeforeLongBreak)")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .frame(width: 80, height: 50)
                                .border(Color.black, width: 3)
                                .background(Color.white)
                        }
                        
                        Slider(
                            value: Binding(
                                get: { Double(timerManager.pomodorosBeforeLongBreak) },
                                set: { timerManager.pomodorosBeforeLongBreak = Int($0) }
                            ),
                            in: 1...10,
                            step: 1
                        )
                        .tint(.black)
                        
                        HStack {
                            Text("1")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                            Spacer()
                            Text("10")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .border(Color.black, width: 4)
                    .background(Color.white)
                }
                .padding(.vertical, 30)
            }
            
            // Done button (brutalist)
            Button(action: {
                dismiss()
            }) {
                Text("DONE")
                    .font(.system(size: 24, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
                    .tracking(4)
                    .frame(width: 300, height: 80)
                    .border(Color.black, width: 4)
                    .background(Color.black)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 40)
        }
        .frame(width: 700, height: 600)
        .background(Color.white)
    }
}

// Full-screen blocking view that prevents work (brutalist design)
struct FullScreenBlockingView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    
    var body: some View {
        ZStack {
            // Brutalist background - stark white
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                // Pomodoro count (brutalist)
                if timerManager.pomodoroCount > 0 {
                    HStack(spacing: 30) {
                        Text("POMODORO")
                            .font(.system(size: 32, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                            .tracking(6)
                        Text("\(timerManager.pomodoroCount)")
                            .font(.system(size: 64, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                            .frame(width: 120, height: 100)
                            .border(Color.black, width: 6)
                            .background(Color.white)
                    }
                    .padding(.top, 80)
                }
                
                // Large mode indicator (brutalist)
                Text("WORK TIME")
                    .font(.system(size: 72, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .tracking(12)
                    .padding(.top, timerManager.pomodoroCount > 0 ? 0 : 100)
                
                // Massive timer display (brutalist)
                Text(timerManager.formattedTime)
                    .font(.system(size: 240, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .monospacedDigit()
                    .padding(40)
                    .border(Color.black, width: 8)
                    .background(Color.white)
                
                // Status message (brutalist)
                if timerManager.isRunning {
                    Text("FOCUS")
                        .font(.system(size: 48, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .tracking(8)
                } else {
                    Text("PAUSED")
                        .font(.system(size: 48, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .tracking(8)
                }
                
                Spacer()
                
                // Control buttons (brutalist - no rounded corners)
                HStack(spacing: 30) {
                    if timerManager.isRunning {
                        Button(action: {
                            timerManager.pause()
                        }) {
                            Text("PAUSE")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(4)
                                .frame(width: 160, height: 80)
                                .border(Color.white, width: 4)
                                .background(Color.black)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button(action: {
                            timerManager.start()
                        }) {
                            Text("RESUME")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.black)
                                .tracking(4)
                                .frame(width: 160, height: 80)
                                .border(Color.black, width: 4)
                                .background(Color.white)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button(action: {
                        timerManager.skip()
                    }) {
                        Text("BREAK")
                            .font(.system(size: 24, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                            .tracking(4)
                            .frame(width: 160, height: 80)
                            .border(Color.black, width: 4)
                            .background(Color.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Prevent system sleep during work session
            timerManager.start()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PomodoroTimerManager())
}




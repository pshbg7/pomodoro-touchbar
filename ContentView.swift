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
                    
                    VStack(spacing: 40) {
                        // Mode indicator
                        Text(timerManager.currentMode)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 60)
                        
                        // Timer display
                        Text(timerManager.formattedTime)
                            .font(.system(size: 120, weight: .ultraLight, design: .rounded))
                            .foregroundColor(.white)
                            .monospacedDigit()
                            .padding()
                        
                        // Control buttons
                        HStack(spacing: 30) {
                            if timerManager.isRunning {
                                Button(action: {
                                    timerManager.pause()
                                }) {
                                    Label("Pause", systemImage: "pause.fill")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 150, height: 60)
                                        .background(Color.orange)
                                        .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            } else {
                                Button(action: {
                                    timerManager.start()
                                }) {
                                    Label("Start", systemImage: "play.fill")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 150, height: 60)
                                        .background(Color.green)
                                        .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Button(action: {
                                timerManager.skip()
                            }) {
                                Label("Skip", systemImage: "forward.fill")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 60)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                timerManager.reset()
                            }) {
                                Label("Reset", systemImage: "arrow.counterclockwise")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 60)
                                    .background(Color.red)
                                    .cornerRadius(12)
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
    }
}

// Full-screen blocking view that prevents work
struct FullScreenBlockingView: View {
    @EnvironmentObject var timerManager: PomodoroTimerManager
    
    var body: some View {
        ZStack {
            // Bright, attention-grabbing background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 0.9),
                    Color(red: 0.4, green: 0.8, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                // Large mode indicator
                Text("WORK TIME")
                    .font(.system(size: 80, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.top, 100)
                
                // Massive timer display
                Text(timerManager.formattedTime)
                    .font(.system(size: 200, weight: .ultraLight, design: .rounded))
                    .foregroundColor(.white)
                    .monospacedDigit()
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding()
                
                // Status message
                if timerManager.isRunning {
                    Text("Focus on your work!")
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                } else {
                    Text("Timer Paused")
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                
                Spacer()
                
                // Control buttons (smaller, at bottom)
                HStack(spacing: 20) {
                    if timerManager.isRunning {
                        Button(action: {
                            timerManager.pause()
                        }) {
                            Label("Pause", systemImage: "pause.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Button(action: {
                            timerManager.start()
                        }) {
                            Label("Resume", systemImage: "play.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 120, height: 50)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button(action: {
                        timerManager.skip()
                    }) {
                        Label("Take Break", systemImage: "forward.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 80)
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




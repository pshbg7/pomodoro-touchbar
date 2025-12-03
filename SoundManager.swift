//
//  SoundManager.swift
//  Pomodoro Timer
//
//  Handles audio notifications
//

import Foundation
import AppKit
import AVFoundation

class SoundManager {
    private var audioPlayer: AVAudioPlayer?
    
    func playCompletionSound() {
        // Play a more noticeable completion sound
        // Try multiple system sounds to ensure one plays
        
        // List of system sounds to try (in order of preference)
        let soundNames = ["Glass", "Ping", "Basso", "Blow", "Bottle", "Frog", "Funk", "Hero", "Morse", "Ping", "Pop", "Purr", "Sosumi", "Submarine", "Tink"]
        
        var soundPlayed = false
        
        // Try to play a system sound
        for soundName in soundNames {
            if let sound = NSSound(named: soundName) {
                sound.volume = 1.0 // Ensure full volume
                sound.play()
                soundPlayed = true
                break
            }
        }
        
        // If no system sound worked, use beep
        if !soundPlayed {
            NSSound.beep()
        }
        
        // Play a second sound after a short delay for emphasis (completion sound)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let sound = NSSound(named: "Glass") {
                sound.volume = 1.0
                sound.play()
            } else if let sound = NSSound(named: "Ping") {
                sound.volume = 1.0
                sound.play()
            } else {
                NSSound.beep()
            }
        }
    }
    
    func playStartSound() {
        // Play a gentle start sound
        if let sound = NSSound(named: "Ping") {
            sound.volume = 0.7 // Slightly quieter for start
            sound.play()
        } else if let sound = NSSound(named: "Pop") {
            sound.volume = 0.7
            sound.play()
        } else {
            // Fallback beep
            NSSound.beep()
        }
    }
    
    func playPauseSound() {
        // Play a subtle pause sound
        if let sound = NSSound(named: "Pop") {
            sound.volume = 0.5 // Quiet for pause
            sound.play()
        } else if let sound = NSSound(named: "Ping") {
            sound.volume = 0.5
            sound.play()
        }
    }
    
    // Create a custom sound using AVAudioPlayer (more reliable)
    private func playCustomSound(frequency: Float, duration: TimeInterval) {
        let sampleRate: Float = 44100
        let numberOfSamples = Int(sampleRate * Float(duration))
        
        var audioBufferList = AudioBufferList()
        audioBufferList.mNumberBuffers = 1
        audioBufferList.mBuffers.mNumberChannels = 1
        audioBufferList.mBuffers.mDataByteSize = UInt32(numberOfSamples * MemoryLayout<Float>.size)
        audioBufferList.mBuffers.mData = calloc(numberOfSamples, MemoryLayout<Float>.size)
        
        guard let buffer = audioBufferList.mBuffers.mData?.assumingMemoryBound(to: Float.self) else {
            return
        }
        
        // Generate a simple tone
        for i in 0..<numberOfSamples {
            let t = Float(i) / sampleRate
            buffer[i] = sin(2.0 * Float.pi * frequency * t) * 0.3
        }
        
        // Convert to AVAudioPCMBuffer and play
        // This is a simplified version - for production, use proper audio file
    }
}



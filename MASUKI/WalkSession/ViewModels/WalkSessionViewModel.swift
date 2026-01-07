//
//  WalkSessionViewModel.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import SwiftUI
import Observation

@Observable
final class WalkSessionViewModel {
    // MARK: - Published Properties
    var timerState: TimerState = .stopped
    var remainingTime: TimeInterval = 0
    var formattedTime: String = "00:00"
    var progress: Double = 0
    var amplitudes: [Float] = []
    var isAudioPlaying = false
    var activeSession: WalkSession?
    
    // MARK: - Managers
    private let timerManager = TimerManager()
    private let visualizerManager = VisualizerManager()
    
    // MARK: - Initialization
    init() {
        setupAmplitudeUpdates()
        // Don't load existing session - always start fresh
        // loadExistingSession() // Comment this out
    }
    
    deinit {
        saveSessionState()
    }
    
    // MARK: - Public Methods
    
    // Initialize session without starting timer
    func initializeSession(duration: DurationOption, music: MusicOption) {
        // Clear any existing session first
        WalkSession.clearActive()
        activeSession = nil
        
        let session = WalkSession(
            duration: duration,
            music: music,
            startTime: Date()
        )
        
        activeSession = session
        WalkSession.saveActive(session)
        
        // Set initial time display to FULL duration
        remainingTime = session.durationInSeconds
        progress = 0
        updateFormattedTime()
        
        // Ensure everything is stopped initially
        timerState = .stopped
        visualizerManager.stop()
        
        // Update amplitudes to show something (even when stopped)
        updateAmplitudesForStoppedState()
    }
    
    func playPause() {
        switch timerState {
        case .stopped:
            // START the timer from beginning
            guard let session = activeSession else { return }
            
            // Make sure we start from full duration
            timerManager.remainingTime = session.durationInSeconds
            timerManager.progress = 0
            
            timerManager.start(for: session, onTick: timerTick, onComplete: completeSession)
            visualizerManager.start()
            timerState = .running
            isAudioPlaying = true
            
        case .running:
            // PAUSE the timer
            timerManager.pause()
            visualizerManager.pause()
            timerState = .paused
            isAudioPlaying = false
            
        case .paused:
            // RESUME the timer
            timerManager.resume()
            visualizerManager.resume()
            timerState = .running
            isAudioPlaying = true
        }
        
        updateFromTimerManager()
    }
    
    func stopSession() {
        timerManager.stop()
        visualizerManager.stop()
        
        // Reset to full duration when stopped
        if let session = activeSession {
            remainingTime = session.durationInSeconds
            progress = 0
            updateFormattedTime()
        }
        
        timerState = .stopped
        isAudioPlaying = false
        updateAmplitudesForStoppedState()
        
        // Clear the active session
        WalkSession.clearActive()
        activeSession = nil
    }
    
    func getAmplitude(for index: Int) -> Float {
        amplitudes[index]
    }
    
    func saveSessionState() {
        guard var session = activeSession else { return }
        
        if timerState == .running {
            session.pausedAt = nil
        } else if timerState == .paused {
            session.pausedAt = timerManager.remainingTime
        } else if timerState == .stopped {
            // When stopped, clear any pause state
            session.pausedAt = nil
        }
        
        WalkSession.saveActive(session)
        activeSession = session
    }
    
    // MARK: - Private Methods
    
    private func timerTick() {
        remainingTime = timerManager.remainingTime
        progress = timerManager.progress
        updateFormattedTime()
        
        // Update amplitudes when timer is ticking
        amplitudes = visualizerManager.amplitudes
    }
    
    private func completeSession() {
        guard let session = activeSession else { return }
        
        // Save as completed
        _ = WalkSession.completeSession(session)
        activeSession = nil
        timerState = .stopped
        remainingTime = 0
        progress = 1.0
        visualizerManager.stop()
        isAudioPlaying = false
        
        updateFormattedTime()
    }
    
    private func updateFromTimerManager() {
        timerState = timerManager.timerState
        remainingTime = timerManager.remainingTime
        formattedTime = timerManager.formattedTime
        progress = timerManager.progress
        isAudioPlaying = visualizerManager.isActive
        
        // Update amplitudes
        amplitudes = visualizerManager.amplitudes
    }
    
    private func updateFormattedTime() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        formattedTime = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func setupAmplitudeUpdates() {
        // Initialize with some default amplitudes
        amplitudes = Array(repeating: 0.1, count: 30)
        
        // Set up periodic updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.updateAmplitudes()
        }
    }
    
    private func updateAmplitudes() {
        // Get current amplitudes from visualizer manager
        amplitudes = visualizerManager.amplitudes
        
        // Continue updating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.updateAmplitudes()
        }
    }
    
    private func updateAmplitudesForStoppedState() {
        // Show some minimal activity even when stopped
        for i in 0..<amplitudes.count {
            amplitudes[i] = Float.random(in: 0.05...0.15)
        }
    }
}

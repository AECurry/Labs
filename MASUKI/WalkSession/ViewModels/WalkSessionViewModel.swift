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
        loadExistingSession()
        setupAmplitudeUpdates()
    }
    
    deinit {
        saveSessionState()
    }
    
    // MARK: - Public Methods
    func startSession(duration: DurationOption, music: MusicOption) {
        let session = WalkSession(
            duration: duration,
            music: music,
            startTime: Date()
        )
        
        activeSession = session
        WalkSession.saveActive(session)
        
        timerManager.start(for: session, onTick: timerTick, onComplete: completeSession)
        visualizerManager.start()
        
        updateFromTimerManager()
    }
    
    func playPause() {
        switch timerState {
        case .running:
            timerManager.pause()
            visualizerManager.pause()
        case .paused:
            timerManager.resume()
            visualizerManager.resume()
        case .stopped:
            break
        }
        
        updateFromTimerManager()
    }
    
    func stopSession() {
        timerManager.stop()
        visualizerManager.stop()
        updateFromTimerManager()
        
        if let session = activeSession {
            remainingTime = session.durationInSeconds
            progress = 0
            updateFormattedTime()
        }
    }
    
    func getAmplitude(for index: Int) -> Float {
        visualizerManager.getAmplitude(for: index)
    }
    
    func saveSessionState() {
        guard var session = activeSession else { return }
        
        if timerState == .running {
            session.pausedAt = nil
        } else if timerState == .paused {
            session.pausedAt = session.elapsedTime
        }
        
        WalkSession.saveActive(session)
        activeSession = session
    }
    
    // MARK: - Private Methods
    private func loadExistingSession() {
        if let savedSession = WalkSession.loadActive() {
            activeSession = savedSession
            
            if savedSession.pausedAt != nil {
                timerState = .paused
                visualizerManager.pause()
            } else if !savedSession.isCompleted {
                timerState = .running
                timerManager.resume(from: savedSession, onTick: timerTick, onComplete: completeSession)
                visualizerManager.resume()
            }
            
            remainingTime = savedSession.remainingTime
            progress = savedSession.progress
            updateFormattedTime()
        }
    }
    
    private func timerTick() {
        guard let session = activeSession else { return }
        
        remainingTime = session.remainingTime
        progress = session.progress
        updateFormattedTime()
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
    }
    
    private func updateFromTimerManager() {
        timerState = timerManager.timerState
        remainingTime = timerManager.remainingTime
        formattedTime = timerManager.formattedTime
        progress = timerManager.progress
        isAudioPlaying = visualizerManager.isActive
    }
    
    private func updateFormattedTime() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        formattedTime = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func setupAmplitudeUpdates() {
        // Update amplitudes from visualizer manager
        amplitudes = visualizerManager.amplitudes
        
        // Set up periodic updates
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.setupAmplitudeUpdates()
        }
    }
}

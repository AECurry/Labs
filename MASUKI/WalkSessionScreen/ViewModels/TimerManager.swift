//
//  TimerManager.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import Foundation
import Combine
import SwiftUI

class TimerManager {
    // MARK: - Properties
    var timerState: TimerState = .stopped
    var remainingTime: TimeInterval = 0
    var formattedTime: String = "00:00"
    var progress: Double = 0
    
    private var backgroundTime: Date?
    private var onTick: (() -> Void)?
    private var onComplete: (() -> Void)?
    private var totalDuration: TimeInterval = 0
    
    // Combine timer
    private var timerCancellable: AnyCancellable?
    
    // MARK: - Scene Phase Handler (SwiftUI for lifecycle)
    func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .background, .inactive:
            appDidEnterBackground()
        case .active:
            appWillEnterForeground()
        @unknown default:
            break
        }
    }
    
    // MARK: - Public Methods
    func start(for session: WalkSession, onTick: @escaping () -> Void, onComplete: @escaping () -> Void) {
        stop()
        
        self.onTick = onTick
        self.onComplete = onComplete
        self.totalDuration = session.durationInSeconds
        self.remainingTime = session.durationInSeconds // Start from full duration
        self.progress = 0
        
        timerState = .running
        startCombineTimer()
        updateFormattedTime()
    }
    
    func pause() {
        timerState = .paused
        stopCombineTimer()
    }
    
    func resume() {
        timerState = .running
        startCombineTimer()
    }
    
    func resume(from session: WalkSession, onTick: @escaping () -> Void, onComplete: @escaping () -> Void) {
        self.onTick = onTick
        self.onComplete = onComplete
        self.totalDuration = session.durationInSeconds
        self.remainingTime = session.remainingTime
        
        timerState = .running
        startCombineTimer()
        updateFormattedTime()
    }
    
    func stop() {
        timerState = .stopped
        stopCombineTimer()
        remainingTime = 0
        progress = 0
        updateFormattedTime()
    }
    
    // MARK: - Private Methods
    private func startCombineTimer() {
        stopCombineTimer()
        
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.timerTick()
            }
    }
    
    private func stopCombineTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    private func timerTick() {
        guard remainingTime > 0 else {
            onComplete?()
            stop()
            return
        }
        
        remainingTime -= 1
        progress = 1 - (remainingTime / totalDuration)
        updateFormattedTime()
        onTick?()
    }
    
    private func updateFormattedTime() {
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        formattedTime = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Background Handling
    private func appDidEnterBackground() {
        backgroundTime = Date()
        stopCombineTimer() // Stop the Combine timer when app goes to background
    }
    
    private func appWillEnterForeground() {
        guard let backgroundTime = backgroundTime,
              timerState == .running else { return }
        
        let timeInBackground = Date().timeIntervalSince(backgroundTime)
        remainingTime = max(0, remainingTime - timeInBackground)
        
        if remainingTime <= 0 {
            onComplete?()
            stop()
        } else {
            startCombineTimer() // Restart the Combine timer
            updateFormattedTime()
        }
    }
    
    deinit {
        stopCombineTimer()
    }
}


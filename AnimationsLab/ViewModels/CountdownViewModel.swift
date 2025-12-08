//
//  CountdownViewModel.swift
//  AnimationsLab
//
//  Created by [Your Name] on [Date].
//

import SwiftUI
import Observation

/// Manages the countdown logic and animation state.
/// Uses SwiftUI's modern @Observable pattern.
@Observable
class CountdownViewModel {
    // MARK: - State Properties
    
    var currentNumber: Int?      // Currently displayed number (3, 2, or 1)
    var showGoText = false      // Whether "GO!" text should be visible
    var isCountdownActive = false  // Whether countdown sequence is running
    var isAnimating = false     // Whether any animation is in progress
    
    // Computed property to control "Get Ready..." visibility
    var shouldShowGetReady: Bool {
        isCountdownActive && !showGoText
    }
    
    // MARK: - Private Properties
    private var currentIndex: Int = 0  // Tracks position in countdown sequence
    private var timer: Timer?         // Controls timing between numbers
    
    // MARK: - Cleanup
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Starts the 3-2-1-GO! countdown animation sequence
    func startCountdown() {
        guard !isAnimating else { return }
        
        resetCountdown()
        isCountdownActive = true
        isAnimating = true
        currentIndex = 0
        animateNextNumber()
    }
    
    /// Resets all state to initial values
    func resetCountdown() {
        timer?.invalidate()
        timer = nil
        currentIndex = 0
        currentNumber = nil
        isAnimating = false
        showGoText = false
        isCountdownActive = false
    }
    
    // MARK: - Private Animation Logic
    
    /// Animates through countdown numbers: 3 → 2 → 1 → GO!
    private func animateNextNumber() {
        let countdownNumbers = [3, 2, 1]
        
        // If done with numbers, show "GO!"
        guard currentIndex < countdownNumbers.count else {
            currentNumber = nil  // Clear the last number
            
            // Brief pause before showing "GO!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showGoText = true
                self.isAnimating = false
            }
            return
        }
        
        // Show current number
        currentNumber = countdownNumbers[currentIndex]
        
        // Schedule next number after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.currentIndex += 1
            self?.animateNextNumber()
        }
    }
}

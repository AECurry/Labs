//
//  CountdownViewModel.swift
//  AnimationsLab
//
//  Created by [Your Name] on [Date].
//


/// STATE MANAGER: Single source of truth for countdown logic
/// SOLID: Single Responsibility - manages countdown state and timing
/// Observable: Children can @Bindable to this for reactive updates
import SwiftUI
import Observation

@Observable
class CountdownViewModel {
    // MARK: - Public State (Observable by child views)
    var currentNumber: Int?
    var showGoText = false
    var isCountdownActive = false
    var isAnimating = false
    var currentNumberIsFadingOut = false
    var symbolsState: [Bool] = Array(repeating: false, count: 4) // For controlling symbol animations
    
    // Computed property for child views
    var shouldShowGetReady: Bool {
        isCountdownActive && !showGoText
    }
    
    // Private State (Internal logic only)
    private var currentIndex: Int = 0
    private var timer: Timer?
    deinit {
            timer?.invalidate()
        }
    
    // Starts the countdown sequence from 4
    func startCountdown() {
        guard !isAnimating else { return }
        
        resetCountdown()
        isCountdownActive = true
        isAnimating = true
        currentIndex = 0
        symbolsState = Array(repeating: false, count: 4)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            animateNextNumber()
        }
    }
    
    // Restes all state to initial values
    func resetCountdown() {
        timer?.invalidate()
        timer = nil
        currentIndex = 0
        currentNumber = nil
        currentNumberIsFadingOut = false
        isAnimating = false
        showGoText = false
        isCountdownActive = false
        symbolsState = Array(repeating: false, count: 4)
    }
    
    private func animateNextNumber() {
        let countdownNumbers = [4, 3, 2, 1]
        
        guard currentIndex < countdownNumbers.count else {
            // All numbers done, show GO! after last number spins out
            fadeOutCurrentNumberThenShowGo()
            return
        }
        
        currentNumber = countdownNumbers[currentIndex]
        currentNumberIsFadingOut = false
        
        // Update symbol state for matched geometry effect
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            symbolsState[currentIndex] = true
        }
        
        // Display number for 1.5 seconds, then start spin/fade
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            withAnimation {
                self?.startFadeOut()
            }
        }
    }
    
    private func startFadeOut() {
        // Trigger spin animation (handled in CountdownNumberView)
        currentNumberIsFadingOut = true
        
        // Wait for spin animation (0.4s) to complete, then move to next number
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            withAnimation {
                self?.currentIndex += 1
                self?.animateNextNumber()
            }
        }
    }
    
    private func fadeOutCurrentNumberThenShowGo() {
        // Trigger final number spin
        currentNumberIsFadingOut = true
        
        // Wait for final spin animation (0.4s) then show GO!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                self?.currentNumber = nil
                self?.showGoText = true
                self?.isAnimating = false
            }
        }
    }
}

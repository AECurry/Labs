//
//  AudioVisualizerService.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import Foundation
import QuartzCore

class AudioVisualizerService {
    // MARK: - Properties
    var amplitudes: [Float] = Array(repeating: 0.1, count: 30)
    var isActive: Bool = false
    
    private var displayLink: CADisplayLink?
    
    // MARK: - Public Methods
    func start() {
        isActive = true
        startDisplayLink()
    }
    
    func pause() {
        isActive = false
    }
    
    func resume() {
        isActive = true
    }
    
    func stop() {
        isActive = false
        stopDisplayLink()
        resetAmplitudes()
    }
    
    func getAmplitude(for index: Int) -> Float {
        guard index >= 0 && index < amplitudes.count else { return 0.1 }
        return amplitudes[index]
    }
    
    // MARK: - Private Methods
    private func startDisplayLink() {
        stopDisplayLink()
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateAmplitudes))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    private func resetAmplitudes() {
        amplitudes = Array(repeating: 0.1, count: 30)
    }
    
    @objc private func updateAmplitudes() {
        guard isActive else {
            // Gradually reduce to base level when inactive
            for i in 0..<amplitudes.count {
                amplitudes[i] = max(0.1, amplitudes[i] - 0.02)
            }
            return
        }
        
        // Update amplitudes with random movement when active
        for i in 0..<amplitudes.count {
            let change = Float.random(in: -0.08...0.08)
            amplitudes[i] = max(0.1, min(1.0, amplitudes[i] + change))
        }
    }
    
    deinit {
        stopDisplayLink()
    }
}

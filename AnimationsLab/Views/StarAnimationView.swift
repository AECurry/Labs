//
//  StarAnimationView.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/9/25.
//

/// HELPER: Manages state for 4 individual star symbols
/// SOLID: Single Responsibility - tracks star animation states
/// @Observable: Allows reactive updates in SingleStarView
import SwiftUI

enum StarState {
    case inCorner /// Initial position
    case movingToCenter /// Animating to center
    case inCenter /// At center position
    case gone /// Faded out
}

@Observable
class StarAnimationView {
    var states: [StarState] = Array(repeating: .inCorner, count: 4)
    
    // Updates star staes based on current countdown number
    func update(for number: Int, showGoText: Bool) {
        if showGoText {
            // When GO! appears, fade out all stars
            withAnimation(.easeOut(duration: 0.3)) {
                states = [.gone, .gone, .gone, .gone]
            }
            return
        }
        
        // Map countdown numbers to star indices
                // 4 → star 0, 3 → star 1, 2 → star 2, 1 → star 3
                switch number {
                case 4:
                    resetAllStars()
                    moveStarToCenter(starIndex: 0)
                case 3:
                    moveStarToCenter(starIndex: 1)
                case 2:
                    moveStarToCenter(starIndex: 2)
                case 1:
                    moveStarToCenter(starIndex: 3)
                default:
                    break
                }
            }
            
            private func resetAllStars() {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    states = [.inCorner, .inCorner, .inCorner, .inCorner]
                }
            }
            
            private func moveStarToCenter(starIndex: Int) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        self.states[starIndex] = .movingToCenter
                    }
                    
                    // Disappear after reaching center
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.states[starIndex] = .gone
                        }
                    }
                }
            }
            
            func reset() {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    states = [.inCorner, .inCorner, .inCorner, .inCorner]
                }
            }
        }

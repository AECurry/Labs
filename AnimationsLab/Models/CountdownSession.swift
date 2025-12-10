//
//  CountdownSession.swift
//  AnimationsLab
//
//  Created by AnnElaine on 12/5/25.
//

/// MODEL: SwiftData persistence model (currently unused but ready for future)
/// SOLID: Single Responsibility - represents countdown session data
import Foundation
import SwiftData

/// A date model representing a single conoutdown session for potential persistence. SwiftData's @Model macro, automatically handles: persistance to device storage, change tracking and observation, relationship manabement (if we add relationships later)
@Model
class CountdownSession {
    var id: UUID /// Unique identifier for each countdown session
    var startTime: Date /// When the countdown session started
    var numbers: [Int] /// The sequence of numbers used in the countdown (default: [3, 2, 1])
    
    
    /// Initializer
    /// Create a new countdown session with default or custom values
    init(id: UUID = UUID(), startTime: Date = Date(), numbers: [Int] = [3, 2, 1]) {
        self.id = id
        self.startTime = startTime
        self.numbers = numbers
    }
}


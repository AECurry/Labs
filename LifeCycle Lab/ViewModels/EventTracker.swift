//
//  EventTracker.swift
//  LifeCycleLab
//
//  Created by AnnElaine on 10/22/25.
//

import Foundation
import SwiftUI

@Observable
class EventTracker {
    var events: [String] = []
    
    func addEvent(_ event: String) {
        let timestamp = Date().formatted(date: .omitted, time: .standard)
        events.append("\(event) - \(timestamp)")
    }
    
    func clearEvents() {
        events.removeAll()
        addEvent("Events cleared")
    }
}

//
//  SessionManager.swift
//  MASUKI
//
//  Created by AnnElaine on 1/7/26.
//

import Foundation
import SwiftUI

@Observable
final class SessionManager {
    var isSessionActive: Bool = false
    var activeSessionId: UUID?
    
    static let shared = SessionManager()
    
    private init() {}
    
    func startSession() {
        isSessionActive = true
        activeSessionId = UUID()
    }
    
    func endSession() {
        isSessionActive = false
        activeSessionId = nil
    }
}


//
//  WalkSetupViewModel.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI
import Observation

@Observable
final class WalkSetupViewModel {
    var selectedDuration: DurationOption = .recommended  // This is now .twentyOne
    var selectedMusic: MusicOption = .placeholder
    
    var isReadyToStart: Bool { true }
    
    init() {
        loadLastPreferences()
    }
    
    func startWalkingSession() {
        let session = WalkSession(
            duration: selectedDuration,
            music: selectedMusic
        )
        
        WalkSession.save(session)
        print("Starting \(selectedDuration.displayName) walk (\(selectedDuration.minutes) minutes)")
        
        // TODO: Navigate to actual walking session
    }
    
    private func loadLastPreferences() {
        if let duration = UserDefaults.standard.string(forKey: "lastDuration"),
           let option = DurationOption(rawValue: duration) {
            selectedDuration = option
        }
        
        if let musicId = UserDefaults.standard.string(forKey: "lastMusic"),
           let music = MusicOption.allOptions.first(where: { $0.id == musicId }) {
            selectedMusic = music
        }
    }
}


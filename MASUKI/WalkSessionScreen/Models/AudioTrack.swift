//
//  AudioTrack.swift
//  MASUKI
//
//  Created by AnnElaine on 1/4/26.
//

import Foundation

struct AudioTrack: Identifiable, Codable {
    let id: String
    let title: String
    let filename: String
    let duration: TimeInterval
    let category: AudioCategory
    let isPremium: Bool
    
    enum AudioCategory: String, Codable, CaseIterable {
        case nature, meditation, ambient, focus, energy
        
        var displayName: String {
            switch self {
            case .nature: return "Nature Sounds"
            case .meditation: return "Meditation"
            case .ambient: return "Ambient"
            case .focus: return "Focus"
            case .energy: return "Energy"
            }
        }
    }
    
    static let sampleTracks: [AudioTrack] = [
        AudioTrack(
            id: "zen_garden",
            title: "Zen Garden",
            filename: "zen_garden.mp3",
            duration: 1260,
            category: .nature,
            isPremium: false
        )
    ]
}


//
//  SettingsManager.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import Foundation
import SwiftUI

@Observable
final class SettingsManager {
    // MARK: - Published Properties
    var isHealthKitEnabled: Bool {
        didSet { UserDefaults.standard.set(isHealthKitEnabled, forKey: "isHealthKitEnabled") }
    }
    
    var selectedImageId: String {
        didSet { UserDefaults.standard.set(selectedImageId, forKey: "selectedImageId") }
    }
    
    var selectedDuration: DurationOption {
        didSet {
            if let encoded = try? JSONEncoder().encode(selectedDuration) {
                UserDefaults.standard.set(encoded, forKey: "selectedDuration")
            }
        }
    }
    
    var selectedMusicId: String {
        didSet { UserDefaults.standard.set(selectedMusicId, forKey: "selectedMusicId") }
    }
    
    var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "userName") }
    }
    
    var dailyGoal: Double {
        didSet { UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal") }
    }
    
    var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }
    
    // MARK: - Singleton
    static let shared = SettingsManager()
    
    // MARK: - Initialization
    private init() {
        // Load initial values from UserDefaults
        self.isHealthKitEnabled = UserDefaults.standard.bool(forKey: "isHealthKitEnabled")
        self.selectedImageId = UserDefaults.standard.string(forKey: "selectedImageId") ?? "koi"
        
        // For DurationOption (assuming it's Codable)
        if let data = UserDefaults.standard.data(forKey: "selectedDuration"),
           let duration = try? JSONDecoder().decode(DurationOption.self, from: data) {
            self.selectedDuration = duration
        } else {
            self.selectedDuration = .twentyOne
        }
        
        self.selectedMusicId = UserDefaults.standard.string(forKey: "selectedMusicId") ?? "placeholder"
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "Walker"
        
        // Check the UserDefaults value before assigning to property
        let savedGoal = UserDefaults.standard.double(forKey: "dailyGoal")
        if savedGoal == 0 {
            self.dailyGoal = 5.0
        } else {
            self.dailyGoal = savedGoal
        }
        
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }
    // MARK: - Helper Methods
    func getSelectedMusic() -> MusicOption {
        MusicOption.allOptions.first { $0.id == selectedMusicId } ?? .placeholder
    }
    
    func setSelectedMusic(_ music: MusicOption) {
        selectedMusicId = music.id
    }
    
    func resetToDefaults() {
        isHealthKitEnabled = false
        selectedImageId = "koi"
        selectedDuration = .twentyOne
        selectedMusicId = "placeholder"
        userName = "Walker"
        dailyGoal = 5.0
        notificationsEnabled = true
    }
}


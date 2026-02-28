//
//  SettingsViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    var settings = Settings()
    var users: [User] = []
    var isLoading = false
    var errorMessage: String?
    
    @ObservationIgnored
    private let apiService: APIServiceProtocol
    @ObservationIgnored
    private let storageService: StorageServiceProtocol
    
    init(apiService: APIServiceProtocol? = nil, storageService: StorageServiceProtocol? = nil) {
        self.apiService = apiService ?? APIService()
        self.storageService = storageService ?? StorageService()
        loadSettings()
    }

    func fetchUsers() async {
        isLoading = true
        errorMessage = nil
        self.users = []
        
       
        let fetchedUsers: [User]? = await withTaskGroup(of: [User]?.self) { group -> [User]? in
            
            // Task 1: real API call
            group.addTask {
                return try? await self.apiService.fetchUsers(settings: self.settings)
            }
            
            // Task 2: 5-second timeout sentinel
            group.addTask {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                return nil // signals timeout
            }
            
            // Take whichever finishes first
            for await result in group {
                group.cancelAll() // cancel the other task
                if let users = result {
                    return users // real API won
                } else {
                    return nil  // timeout won (or real API returned nil)
                }
            }
            return nil
        }
        
        if let users = fetchedUsers, !users.isEmpty {
            print("Real API succeeded with \(users.count) users")
            self.users = users
        } else {
            // Real API failed or timed out — use mock
            print("Real API unavailable. Switching to MockAPIService...")
            do {
                let mockUsers = try await MockAPIService().fetchUsers(settings: self.settings)
                print("Mock API succeeded with \(mockUsers.count) users")
                self.users = mockUsers
            } catch {
                self.errorMessage = "Both API and Mock failed: \(error.localizedDescription)"
            }
        }
        
        self.isLoading = false
    }
    
    func saveSettings() {
        try? storageService.save(settings, for: "userSettings")
    }
    
    func loadSettings() {
        if let saved: Settings = try? storageService.load(Settings.self, for: "userSettings") {
            settings = saved
        }
    }
    
    func toggleAllOptions(_ enable: Bool) {
        settings.showGender = enable
        settings.showLocation = enable
        settings.showEmail = enable
        settings.showLogin = enable
        settings.showRegistered = enable
        settings.showDob = enable
        settings.showPhone = enable
        settings.showCell = enable
        settings.showID = enable
        settings.showNationality = enable
    }
}

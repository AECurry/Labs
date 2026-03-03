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
            
            
            group.addTask {
                return try? await self.apiService.fetchUsers(settings: self.settings)
            }
            
         
            group.addTask {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                return nil
            }
            
           
            for await result in group {
                group.cancelAll()
                if let users = result {
                    return users
                } else {
                    return nil
                }
            }
            return nil
        }
        
        if let users = fetchedUsers, !users.isEmpty {
            print("Real API succeeded with \(users.count) users")
            self.users = users
        } else {
            
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

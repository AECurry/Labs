//
//  SettingsViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var settings = Settings()
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let apiService: APIServiceProtocol
    private let storageService: StorageServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.apiService = apiService
        self.storageService = storageService
        loadSettings()
    }
    
    func fetchUsers() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            users = try await apiService.fetchUsers(settings: settings)
            saveSettings()
        } catch {
            errorMessage = error.localizedDescription
        }
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

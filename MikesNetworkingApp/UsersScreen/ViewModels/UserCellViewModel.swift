//
//  UserCellViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Combine

@MainActor
final class UserCellViewModel: ObservableObject, Identifiable {
    // MARK: - Published Properties
    @Published var user: User
    @Published var imageData: Data?
    @Published var isLoadingImage = false
    
    // MARK: - Dependencies
    private let imageService: ImageServiceProtocol
    
    var id: String { user.id.uuidString }
    
    init(user: User, imageService: ImageServiceProtocol) {
        self.user = user
        self.imageService = imageService
    }
    
    func loadImage() async {
        guard imageData == nil, !isLoadingImage else { return }
        
        isLoadingImage = true
        defer { isLoadingImage = false }
        
        if let data = await imageService.loadImage(from: user.picture.thumbnail) {
            imageData = data
        }
    }
    
    var displayName: String { user.fullName }
    
    func fieldValue(for keyPath: KeyPath<Settings, Bool>, settings: Settings) -> String? {
        // This would map settings to actual user properties
        // Implementation depends on your needs
        return nil
    }
}

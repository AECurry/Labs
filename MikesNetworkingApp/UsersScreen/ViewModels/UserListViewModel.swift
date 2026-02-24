//
//  UserListViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Combine

@MainActor
final class UserListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var users: [User]
    @Published var isLoading = false
    @Published var cellViewModels: [String: UserCellViewModel] = [:]
    
    // MARK: - Dependencies
    private let imageService: ImageServiceProtocol
    
    init(users: [User], imageService: ImageServiceProtocol = ImageCacheService.shared) {
        self.users = users
        self.imageService = imageService
    }
    
    func cellViewModel(for user: User) -> UserCellViewModel {
        if let existing = cellViewModels[user.id.uuidString] {
            return existing
        }
        
        let newVM = UserCellViewModel(user: user, imageService: imageService)
        cellViewModels[user.id.uuidString] = newVM
        return newVM
    }
    
    func loadImagesForVisibleCells() async {
        isLoading = true
        defer { isLoading = false }
        
        await withTaskGroup(of: Void.self) { group in
            for vm in cellViewModels.values {
                group.addTask {
                    await vm.loadImage()
                }
            }
        }
    }
}

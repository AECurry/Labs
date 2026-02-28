//
//  UserListViewModel.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Observation

@Observable 
@MainActor
final class UserListViewModel {
    
    // No more @Published!
    var users: [User]
    var isLoading = false
    var cellViewModels: [String: UserCellViewModel] = [:]

    @ObservationIgnored private let imageService: ImageServiceProtocol
    let settings: Settings

    init(users: [User],
         settings: Settings,
         imageService: ImageServiceProtocol? = nil) {
        self.users = users
        self.settings = settings
        self.imageService = imageService ?? ImageCacheService.shared
        
        setupViewModels()
    }
    
    private func setupViewModels() {
        for user in users {
            let id = user.id.uuidString
            cellViewModels[id] = UserCellViewModel(user: user, imageService: imageService)
        }
    }
    
    func cellViewModel(for user: User) -> UserCellViewModel {
        return cellViewModels[user.id.uuidString] ?? UserCellViewModel(user: user, imageService: imageService)
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


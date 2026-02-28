//
//  ViewModelProtocols.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI
import Combine


protocol SettingsViewModelProtocol: ObservableObject {
    var settings: Settings { get set }
    var users: [User] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func fetchUsers() async
    func saveSettings()
    func loadSettings()
    func toggleAllOptions(_ enable: Bool)
}

protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var isLoading: Bool { get }
    func cellViewModel(for user: User) -> UserCellViewModel
    func loadImagesForVisibleCells() async
}

protocol UserCellViewModelProtocol: ObservableObject {
    var user: User { get }
    var imageData: Data? { get }
    var isLoadingImage: Bool { get }
    var displayName: String { get }
    func loadImage() async
}


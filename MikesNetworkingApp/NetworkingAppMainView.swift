//
//  NetworkingAppMainView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct NetworkingAppMainView: View {
    @State private var navigationPath = NavigationPath()
    @StateObject private var settingsVM = SettingsViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            SettingsView(
                viewModel: settingsVM,
                navigationPath: $navigationPath
            )
            .navigationDestination(for: [User].self) { users in
                if !users.isEmpty {
                    UserListView(
                        viewModel: UserListViewModel(users: users),
                        navigationPath: $navigationPath
                    )
                }
            }
        }
        .tint(.blue)
    }
}

//
//  NetworkingAppMainView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case userList
}

struct NetworkingAppMainView: View {
    @State private var navigationPath = NavigationPath()
    @State private var settingsVM = SettingsViewModel()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            SettingsView(
                viewModel: settingsVM,
                navigationPath: $navigationPath
            )
           
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .userList:
                    UserListView(
                        viewModel: UserListViewModel(
                            users: settingsVM.users,
                            settings: settingsVM.settings
                        ),
                        navigationPath: $navigationPath
                    )
                }
            }
        }
       
        .onChange(of: settingsVM.users.count) { _, newCount in
            if newCount > 0 && navigationPath.count == 0 {
                navigationPath.append(AppRoute.userList)
            }
        }
    }
}


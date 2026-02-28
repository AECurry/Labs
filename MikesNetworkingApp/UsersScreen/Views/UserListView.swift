//
//  UserListView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct UserListView: View {
    
   
    @State var viewModel: UserListViewModel
    @Binding var navigationPath: NavigationPath

    var body: some View {
        List(viewModel.users) { user in
            UserCellView(
                viewModel: viewModel.cellViewModel(for: user),
                settings: viewModel.settings
            )
            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .background(backgroundGradient)
        .navigationTitle("Users (\(viewModel.users.count))")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.blue.opacity(0.05), .purple.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}


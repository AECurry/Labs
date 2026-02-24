//
//  UserListView.swift
//  MikesNetworkingApp
//
//  Created by AnnElaine on 2/24/26.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        List(viewModel.users) { user in
            UserCellView(viewModel: viewModel.cellViewModel(for: user))
        }
        .listStyle(.plain)
        .background(backgroundGradient)
        .navigationTitle("Users (\(viewModel.users.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    navigationPath.removeLast()
                }
            }
        }
        .task {
            await viewModel.loadImagesForVisibleCells()
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView()
            }
        }
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

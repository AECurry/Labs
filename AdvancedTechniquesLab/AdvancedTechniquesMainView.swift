//
//  AdvancedTechniquesMainView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import SwiftUI

struct AdvancedTechniquesMainView: View {
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoggedIn {
                    DashboardView(username: viewModel.username)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Logout") {
                                    viewModel.logout()
                                }
                            }
                        }
                } else {
                    LoginView(viewModel: viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    AdvancedTechniquesMainView()
}

//
//  LoginView.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

//  Main parent file for the Login folder
import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            LoginHeaderView()
                .padding(.top, 40)
            
            UsernameFieldView(username: $viewModel.username)
            
            PasswordFieldView(password: $viewModel.password)
            
            StatusMessageView(loginState: viewModel.loginState)
            
            Spacer()
                .frame(minHeight: 100)
            
            VStack(spacing: 20) {
                LoginButtonView(
                    action: viewModel.validateAndLogin,
                    isDisabled: viewModel.loginState == .loading
                )
                
                ForgotPasswordButtonView(action: viewModel.handleForgotPassword)
            }
            
            Spacer()
                .frame(height: 30)
        }
        .padding(32)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    NavigationView {
        LoginView(viewModel: LoginViewModel())
    }
}

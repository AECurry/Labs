//
//  LoginViewModel.swift
//  AdvancedTechniquesLab
//
//  Created by AnnElaine on 1/5/26.
//

import Foundation

@Observable
class LoginViewModel {
    var username: String = ""
    var password: String = ""
    var loginState: LoginState = .idle
    var isLoggedIn: Bool = false  // Make sure this exists!
    
    func validateAndLogin() {
        guard !username.isEmpty else {
            loginState = .error("Username cannot be empty")
            return
        }
        
        guard !password.isEmpty else {
            loginState = .error("Password cannot be empty")
            return
        }
        
        performLogin()
    }
    
    private func performLogin() {
        loginState = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            
            if self.username.lowercased() == "admin" && self.password == "password123" {
                self.loginState = .success
                // After showing success message, set logged in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.isLoggedIn = true
                }
            } else {
                self.loginState = .error("Invalid username or password")
            }
        }
    }
    
    func handleForgotPassword() {
        print("Forgot password tapped")
    }
    
    func logout() {
        isLoggedIn = false
        username = ""
        password = ""
        loginState = .idle
    }
}

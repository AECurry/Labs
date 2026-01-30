//
//  PasswordViewModel.swift
//  TDDPasswordLab
//
//  Created by AnnElaine on 1/27/26.
//

import Foundation
import Combine

class PasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var passwordBrokenRules: [String] = []
    @Published var emailBrokenRules: [String] = []
    @Published var isPasswordValid: Bool = false
    @Published var isEmailValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Validate password whenever it changes
        $password
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] newPassword in
                self?.validatePassword(newPassword)
            }
            .store(in: &cancellables)
        
        // Validate email whenever it changes
        $email
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] newEmail in
                self?.validateEmail(newEmail)
            }
            .store(in: &cancellables)
    }
    
    private func validatePassword(_ password: String) {
        let result = PasswordValidation.validate(password: password)
        isPasswordValid = result.isValid
        passwordBrokenRules = result.brokenRules
    }
    
    private func validateEmail(_ email: String) {
        let result = EmailValidation.validate(email: email)
        isEmailValid = result.isValid
        emailBrokenRules = result.brokenRules
    }
    
    func canSubmit() -> Bool {
        return isPasswordValid && isEmailValid && !password.isEmpty && !email.isEmpty
    }
}

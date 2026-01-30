//
//  PasswordValidation.swift
//  TDDPasswordLab
//
//  Created by AnnElaine on 1/27/26.
//

import Foundation

struct ValidationResult {
    let isValid: Bool
    let brokenRules: [String]
}

class PasswordValidation {
    
    // MARK: - Individual Rule Validators
    
    static func hasMinimumLength(password: String) -> Bool {
        return password.count >= 8
    }
    
    static func hasMaximumLength(password: String) -> Bool {
        return password.count <= 30  // Changed from >= to <=
    }
    
    static func containsLowerCase(password: String) -> Bool {
        let lowercaseCharacter = "qwertyuiopasdfghjklzxcvbnm"
        for character in password {
            if lowercaseCharacter.contains(character) {
                return true
            }
        }
        return false  // Added missing return statement
    }
    
    static func containsUpperCase(password: String) -> Bool {
        let uppercaseCharacter = "QWERTYUIOPASDFGHJKLZXCVBNM"
        for character in password {
            if uppercaseCharacter.contains(character) {
                return true
            }
        }
        return false
    }
    
    static func containsNumber(password: String) -> Bool {
        let numbers = "0123456789"
        for character in password {
            if numbers.contains(character) {
                return true
            }
        }
        return false
    }
    
    static func containsSpecialCharacter(password: String) -> Bool {
        let specialCharacters = "!@#$%^&*()_+-=[]{}|;:',.<>?/~`"
        for character in password {
            if specialCharacters.contains(character) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Complete Validation
    
    static func validate(password: String) -> ValidationResult {
        var brokenRules: [String] = []
        
        if !hasMinimumLength(password: password) {
            brokenRules.append("Password must be at least 8 characters long")
        }
        
        if !hasMaximumLength(password: password) {
            brokenRules.append("Password must not exceed 30 characters")
        }
        
        if !containsLowerCase(password: password) {
            brokenRules.append("Password must contain at least one lowercase letter")
        }
        
        if !containsUpperCase(password: password) {
            brokenRules.append("Password must contain at least one uppercase letter")
        }
        
        if !containsNumber(password: password) {
            brokenRules.append("Password must contain at least one number")
        }
        
        if !containsSpecialCharacter(password: password) {
            brokenRules.append("Password must contain at least one special character")
        }
        
        return ValidationResult(isValid: brokenRules.isEmpty, brokenRules: brokenRules)
    }
}

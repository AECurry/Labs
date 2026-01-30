//
//  EmailValidation.swift
//  TDDPasswordLab
//
//  Created by AnnElaine on 1/27/26.
//

import Foundation

class EmailValidation {
    
    static func hasValidLocalPart(email: String) -> Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let localPart = email[..<atIndex]
        return localPart.count >= 1 && localPart.count <= 64
    }
    
    static func hasValidDomain(email: String) -> Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let domain = email[email.index(after: atIndex)...]
        return domain.count >= 1 && domain.contains(".")
    }
    
    static func hasValidDomainExtension(email: String) -> Bool {
        guard let atIndex = email.firstIndex(of: "@") else { return false }
        let domain = email[email.index(after: atIndex)...]
        guard let dotIndex = domain.lastIndex(of: ".") else { return false }
        let extension_ = domain[domain.index(after: dotIndex)...]
        return extension_.count >= 1
    }
    
    static func hasOnlyOneAtSymbol(email: String) -> Bool {
        return email.filter({ $0 == "@" }).count == 1
    }
    
    static func validate(email: String) -> ValidationResult {
        var brokenRules: [String] = []
        
        if !hasOnlyOneAtSymbol(email: email) {
            brokenRules.append("Email must contain exactly one @ symbol")
        }
        
        if !hasValidLocalPart(email: email) {
            brokenRules.append("Email local part must be 1-64 characters")
        }
        
        if !hasValidDomain(email: email) {
            brokenRules.append("Email must have a valid domain")
        }
        
        if !hasValidDomainExtension(email: email) {
            brokenRules.append("Email must have a valid domain extension")
        }
        
        return ValidationResult(isValid: brokenRules.isEmpty, brokenRules: brokenRules)
    }
}

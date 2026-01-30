//
//  TDDPasswordLabTests.swift
//  TDDPasswordLabTests
//
//  Created by AnnElaine on 1/27/26.
//

@testable import TDDPasswordLab
import XCTest

class TDDPasswordLabTests: XCTestCase {
    
    //  Minimum Length Tests
    
    func testPasswordSizeMin_FailsWithTooShortPassword() {
        let result = PasswordValidation.hasMinimumLength(password: "Pass")
        XCTAssertFalse(result, "Password with 4 characters should fail minimum length")
    }
    
    func testPasswordSizeMin_PassesWithValidLength() {
        let result = PasswordValidation.hasMinimumLength(password: "Password")
        XCTAssertTrue(result, "Password with 8+ characters should pass minimum length")
    }
    
    func testPasswordSizeMin_PassesWithExactlyEightCharacters() {
        let result = PasswordValidation.hasMinimumLength(password: "12345678")
        XCTAssertTrue(result, "Password with exactly 8 characters should pass")
    }
    
    func testPasswordSizeMin_FailsWithEmptyString() {
        let result = PasswordValidation.hasMinimumLength(password: "")
        XCTAssertFalse(result, "Empty password should fail minimum length")
    }
    
    func testPasswordSizeMin_FailsWithSevenCharacters() {
        let result = PasswordValidation.hasMinimumLength(password: "1234567")
        XCTAssertFalse(result, "Password with 7 characters should fail minimum length")
    }
    
    // Maximum Length Tests
    
    func testPasswordSizeMax_PassesWithShortPassword() {
        let result = PasswordValidation.hasMaximumLength(password: "Pass")
        XCTAssertTrue(result, "Short password should pass maximum length")
    }
    
    func testPasswordSizeMax_FailsWithTooLongPassword() {
        let result = PasswordValidation.hasMaximumLength(password: "ThisPasswordIsWayTooLongAndExceedsTheMaximumAllowedLength!")
        XCTAssertFalse(result, "Password longer than 30 characters should fail")
    }
    
    func testPasswordSizeMax_PassesWithExactlyThirtyCharacters() {
        let result = PasswordValidation.hasMaximumLength(password: "123456789012345678901234567890") // 30 chars
        XCTAssertTrue(result, "Password with exactly 30 characters should pass")
    }
    
    func testPasswordSizeMax_FailsWithThirtyOneCharacters() {
        let result = PasswordValidation.hasMaximumLength(password: "1234567890123456789012345678901") // 31 chars
        XCTAssertFalse(result, "Password with 31 characters should fail maximum length")
    }
    
    func testPasswordSizeMax_PassesWithEmptyString() {
        let result = PasswordValidation.hasMaximumLength(password: "")
        XCTAssertTrue(result, "Empty string is under maximum length")
    }
    
    // Lowercase Tests
    
    func testLowerCaseContained_PassesWithLowercaseLetters() {
        let result = PasswordValidation.containsLowerCase(password: "Password")
        XCTAssertTrue(result, "Password with lowercase letters should pass")
    }
    
    func testLowerCaseContained_FailsWithNoLowercaseLetters() {
        let result = PasswordValidation.containsLowerCase(password: "PASSWORD123!")
        XCTAssertFalse(result, "Password without lowercase letters should fail")
    }
    
    func testLowerCaseContained_PassesWithOnlyLowercase() {
        let result = PasswordValidation.containsLowerCase(password: "password")
        XCTAssertTrue(result, "Password with only lowercase should pass")
    }
    
    func testLowerCaseContained_PassesWithMixedContent() {
        let result = PasswordValidation.containsLowerCase(password: "P@ssw0rd!")
        XCTAssertTrue(result, "Password with mixed content including lowercase should pass")
    }
    
    // Uppercase Tests
    
    func testUpperCaseContained_PassesWithUppercaseLetters() {
        let result = PasswordValidation.containsUpperCase(password: "Password")
        XCTAssertTrue(result, "Password with uppercase letters should pass")
    }
    
    func testUpperCaseContained_FailsWithNoUppercaseLetters() {
        let result = PasswordValidation.containsUpperCase(password: "password123!")
        XCTAssertFalse(result, "Password without uppercase letters should fail")
    }
    
    func testUpperCaseContained_PassesWithOnlyUppercase() {
        let result = PasswordValidation.containsUpperCase(password: "PASSWORD")
        XCTAssertTrue(result, "Password with only uppercase should pass")
    }
    
    func testUpperCaseContained_PassesWithMixedContent() {
        let result = PasswordValidation.containsUpperCase(password: "p@SSw0rd!")
        XCTAssertTrue(result, "Password with mixed content including uppercase should pass")
    }
    
    // Number Tests
    
    func testNumbersContained_PassesWithNumbers() {
        let result = PasswordValidation.containsNumber(password: "Password123")
        XCTAssertTrue(result, "Password with numbers should pass")
    }
    
    func testNumbersContained_FailsWithNoNumbers() {
        let result = PasswordValidation.containsNumber(password: "Password!")
        XCTAssertFalse(result, "Password without numbers should fail")
    }
    
    func testNumbersContained_PassesWithOnlyNumbers() {
        let result = PasswordValidation.containsNumber(password: "12345678")
        XCTAssertTrue(result, "Password with only numbers should pass")
    }
    
    func testNumbersContained_PassesWithSingleNumber() {
        let result = PasswordValidation.containsNumber(password: "Password1!")
        XCTAssertTrue(result, "Password with at least one number should pass")
    }
    
    // Special Character Tests
    
    func testSpecialCharactersContained_PassesWithSpecialCharacters() {
        let result = PasswordValidation.containsSpecialCharacter(password: "Password!")
        XCTAssertTrue(result, "Password with special characters should pass")
    }
    
    func testSpecialCharactersContained_FailsWithNoSpecialCharacters() {
        let result = PasswordValidation.containsSpecialCharacter(password: "Password123")
        XCTAssertFalse(result, "Password without special characters should fail")
    }
    
    func testSpecialCharactersContained_PassesWithMultipleSpecialCharacters() {
        let result = PasswordValidation.containsSpecialCharacter(password: "P@ssw0rd!")
        XCTAssertTrue(result, "Password with multiple special characters should pass")
    }
    
    func testSpecialCharactersContained_PassesWithAtSymbol() {
        let result = PasswordValidation.containsSpecialCharacter(password: "P@ssword1")
        XCTAssertTrue(result, "Password with @ symbol should pass")
    }
    
    func testSpecialCharactersContained_PassesWithHashSymbol() {
        let result = PasswordValidation.containsSpecialCharacter(password: "Password1#")
        XCTAssertTrue(result, "Password with # symbol should pass")
    }
    
    // Complete Validation Tests
    
    func testValidate_PassesWithValidPassword() {
        let result = PasswordValidation.validate(password: "Password123!")
        XCTAssertTrue(result.isValid, "Valid password should pass all checks")
        XCTAssertEqual(result.brokenRules.count, 0, "Valid password should have no broken rules")
    }
    
    func testValidate_FailsWithInvalidPassword() {
        let result = PasswordValidation.validate(password: "pass")
        XCTAssertFalse(result.isValid, "Invalid password should fail")
        XCTAssertTrue(result.brokenRules.count > 0, "Invalid password should have broken rules")
    }
    
    func testValidate_ReturnsAllBrokenRules() {
        let result = PasswordValidation.validate(password: "abc")
        XCTAssertFalse(result.isValid, "Password 'abc' should be invalid")
        XCTAssertEqual(result.brokenRules.count, 4, "Password 'abc' should break 4 rules: too short, no uppercase, no number, no special char")
    }
    
    func testValidate_FailsWithOnlyLength() {
        let result = PasswordValidation.validate(password: "passwordpassword")
        XCTAssertFalse(result.isValid, "Password with only lowercase should fail")
        XCTAssertTrue(result.brokenRules.count == 3, "Should fail uppercase, number, and special character checks")
    }
    
    func testValidate_PassesWithMinimalValidPassword() {
        let result = PasswordValidation.validate(password: "Passw0rd!")
        XCTAssertTrue(result.isValid, "Password meeting all minimum requirements should pass")
        XCTAssertEqual(result.brokenRules.count, 0, "Valid password should have no broken rules")
    }
    
    // Email Validation Tests
    
    func testEmail_PassesWithValidEmail() {
        let result = EmailValidation.validate(email: "test@example.com")
        XCTAssertTrue(result.isValid, "Valid email should pass")
        XCTAssertEqual(result.brokenRules.count, 0, "Valid email should have no broken rules")
    }
    
    func testEmail_PassesWithMinimalEmail() {
        let result = EmailValidation.validate(email: "b@p.c")
        XCTAssertTrue(result.isValid, "Minimal valid email should pass")
        XCTAssertEqual(result.brokenRules.count, 0, "Minimal valid email should have no broken rules")
    }
    
    func testEmail_FailsWithNoAtSymbol() {
        let result = EmailValidation.validate(email: "testexample.com")
        XCTAssertFalse(result.isValid, "Email without @ should fail")
        XCTAssertTrue(result.brokenRules.count > 0, "Email without @ should have broken rules")
    }
    
    func testEmail_FailsWithMultipleAtSymbols() {
        let result = EmailValidation.validate(email: "test@@example.com")
        XCTAssertFalse(result.isValid, "Email with multiple @ symbols should fail")
        XCTAssertTrue(result.brokenRules.contains("Email must contain exactly one @ symbol"), "Should report multiple @ symbols")
    }
    
    func testEmail_FailsWithNoDot() {
        let result = EmailValidation.validate(email: "test@example")
        XCTAssertFalse(result.isValid, "Email without domain extension should fail")
    }
    
    func testEmail_FailsWithEmptyLocalPart() {
        let result = EmailValidation.validate(email: "@example.com")
        XCTAssertFalse(result.isValid, "Email with empty local part should fail")
    }
    
    func testEmail_FailsWithLocalPartTooLong() {
        let longLocal = String(repeating: "a", count: 65)
        let result = EmailValidation.validate(email: "\(longLocal)@example.com")
        XCTAssertFalse(result.isValid, "Email with local part over 64 characters should fail")
    }
    
    func testEmail_PassesWithLocalPartExactly64Characters() {
        let longLocal = String(repeating: "a", count: 64)
        let result = EmailValidation.validate(email: "\(longLocal)@example.com")
        XCTAssertTrue(result.isValid, "Email with local part exactly 64 characters should pass")
    }
    
    func testEmail_FailsWithEmptyDomain() {
        let result = EmailValidation.validate(email: "test@")
        XCTAssertFalse(result.isValid, "Email with empty domain should fail")
    }
    
    func testEmail_PassesWithComplexEmail() {
        let result = EmailValidation.validate(email: "user.name+tag@example.co.uk")
        XCTAssertTrue(result.isValid, "Complex valid email should pass")
    }
}

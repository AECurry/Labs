//
//  ContentView.swift
//  TDDPasswordLab
//
//  Created by AnnElaine on 1/27/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PasswordViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // Email Section
                Section(header: Text("Email")) {
                    TextField("Enter email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                    
                    if !viewModel.email.isEmpty {
                        if viewModel.isEmailValid {
                            Label("Valid email", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            ForEach(viewModel.emailBrokenRules, id: \.self) { rule in
                                Label(rule, systemImage: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                // Password Section
                Section(header: Text("Password")) {
                    SecureField("Enter password", text: $viewModel.password)
                    
                    if !viewModel.password.isEmpty {
                        if viewModel.isPasswordValid {
                            Label("Valid password", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            ForEach(viewModel.passwordBrokenRules, id: \.self) { rule in
                                Label(rule, systemImage: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                // Password Requirements Section
                Section(header: Text("Password Requirements")) {
                    ValidationRuleView(
                        text: "8-30 characters",
                        isValid: viewModel.password.isEmpty ? nil :
                            PasswordValidation.hasMinimumLength(password: viewModel.password) &&
                            PasswordValidation.hasMaximumLength(password: viewModel.password)
                    )
                    ValidationRuleView(
                        text: "At least one uppercase letter",
                        isValid: viewModel.password.isEmpty ? nil :
                            PasswordValidation.containsUpperCase(password: viewModel.password)
                    )
                    ValidationRuleView(
                        text: "At least one lowercase letter",
                        isValid: viewModel.password.isEmpty ? nil :
                            PasswordValidation.containsLowerCase(password: viewModel.password)
                    )
                    ValidationRuleView(
                        text: "At least one number",
                        isValid: viewModel.password.isEmpty ? nil :
                            PasswordValidation.containsNumber(password: viewModel.password)
                    )
                    ValidationRuleView(
                        text: "At least one special character",
                        isValid: viewModel.password.isEmpty ? nil :
                            PasswordValidation.containsSpecialCharacter(password: viewModel.password)
                    )
                }
                
                // Submit Button Section
                Section {
                    Button(action: {
                        // Handle submission
                        print("Form submitted!")
                        print("Email: \(viewModel.email)")
                        print("Password: \(viewModel.password)")
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(viewModel.canSubmit() ? .blue : .gray)
                    }
                    .disabled(!viewModel.canSubmit())
                }
            }
            .navigationTitle("Sign Up")
        }
    }
}

struct ValidationRuleView: View {
    let text: String
    let isValid: Bool?
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(text)
                .font(.caption)
                .foregroundColor(iconColor)
        }
    }
    
    private var iconName: String {
        guard let isValid = isValid else {
            return "circle"
        }
        return isValid ? "checkmark.circle.fill" : "xmark.circle.fill"
    }
    
    private var iconColor: Color {
        guard let isValid = isValid else {
            return .gray
        }
        return isValid ? .green : .red
    }
}

#Preview {
    ContentView()
}

//
//  LoginView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI
import Foundation

// MARK: - Login View
/// Authentication screen for student login
/// Displays a personalized welcome, pre-fills the student email, and validates credentials
/// Uses demo password matching with API fallback for development/testing purposes

struct LoginView: View {
    // *Injected Dependencies
    let student: Student                 // Student attempting to log in
    let onLoginSuccess: () -> Void       // Callback triggered after successful authentication
    
    // *View State
    @State private var email: String = ""        // Email input (auto-filled on appear)
    @State private var password: String = ""     // Secure password input
    @State private var showAlert = false          // Controls login error alert visibility
    @State private var alertMessage = ""          // Error message displayed in alert
    @State private var isLoading = false          // Shows loading spinner during authentication
    
    // *Environment
    @Environment(\.dismiss) private var dismiss   // Allows dismissing the view
    
    var body: some View {
        NavigationStack {
            ZStack {
                // *Global Background
                MountainlandColors.platinum.ignoresSafeArea()
                
                // *Background Logo Watermark
                Image("MountainlandLogo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .opacity(0.1)
                    .offset(y: 50)
                
                // *Main Layout
                VStack(spacing: 0) {
                    
                    // *Back Navigation
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    // *Student Avatar
                    ZStack {
                        Circle()
                            .fill(MountainlandColors.burgundy2)
                            .frame(width: 100, height: 100)
                        
                        Text(student.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    // *Scrollable Content
                    ScrollView {
                        VStack(alignment: .center, spacing: 24) {
                            
                            // *Welcome Message
                            Text("Welcome back, \(student.firstName)!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 24)
                            
                            // *Email Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                
                                TextField("Email", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .textContentType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding(.horizontal, 16)
                            
                            // *Password Field
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .textContentType(.password)
                            }
                            .padding(.horizontal, 16)
                            
                            // *Forgot Password Action
                            Button("Forgot Password?") {
                                // Placeholder for password recovery flow
                            }
                            .font(.subheadline)
                            .foregroundColor(MountainlandColors.smokeyBlack)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                            
                            // *Login Button / Loading Indicator
                            if isLoading {
                                ProgressView()
                                    .padding()
                            } else {
                                Button(action: {
                                    authenticateUser()
                                }) {
                                    Text("Sign In")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(MountainlandColors.smokeyBlack)
                                        .frame(width: 162, height: 48)
                                        .background(MountainlandColors.white)
                                        .cornerRadius(32)
                                        .shadow(
                                            color: .black.opacity(0.3),
                                            radius: 6,
                                            x: 0,
                                            y: 4
                                        )
                                }
                                .disabled(email.isEmpty || password.isEmpty) // Prevent empty submissions
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            
            // *Login Error Alert
            .alert("Login Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            
            // *Pre-fill Email on Load
            .onAppear {
                email = student.email
            }
        }
    }
    
    // MARK: - Authentication Logic
    /// Handles user login using API authentication with demo fallback
    private func authenticateUser() {
        isLoading = true
        
        Task {
            do {
                // Attempt API login
                let response = try await APIController.shared.login(
                    email: email,
                    password: password
                )
                
                // *Debug Logging (Success)
                print("✅ Login successful!")
                print("   User: \(response.firstName) \(response.lastName)")
                print("   Email: \(response.email)")
                print("   User UUID: \(response.userUUID)")
                print("   UserSecret (for API calls): \(response.secret)")
                
                await MainActor.run {
                    isLoading = false
                    onLoginSuccess()
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    
                    // *Debug Logging (Failure)
                    print("❌ Login failed: \(error)")
                    
                    // *Error Handling
                    if let loginError = error as? LoginError {
                        switch loginError {
                        case .badResponse:
                            alertMessage = "Server error. Please try again."
                            print("   Error type: Bad server response")
                        case .systemError:
                            alertMessage = "Connection problem. Check your internet."
                            print("   Error type: System/network error")
                        }
                    } else {
                        alertMessage = "Login failed: \(error.localizedDescription)"
                        print("   Error type: Unknown - \(error)")
                    }
                    
                    showAlert = true
                    
                    // *Demo Authentication Fallback
                    // Allows login if demo password matches student record
                    // Remove once API authentication is fully implemented
                    if password == student.password {
                        print("⚠️ API failed, using demo authentication with password: \(password)")
                        print("   Student demo password match: true")
                        onLoginSuccess()
                    } else {
                        print("   Student demo password match: false")
                    }
                }
            }
        }
    }
}

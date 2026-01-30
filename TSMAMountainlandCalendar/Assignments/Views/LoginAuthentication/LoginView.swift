//
//  LoginView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 11/7/25.
//

import SwiftUI

// MARK: - Login View
/// Authentication screen for student login that automatically fills in their email address and shows their profile picture, then checks if the password matches.
/// Features personalized welcome, secure input fields, and demo authentication
/// Right now this uses simple password matching for demo purposes. In a real app, this would connect to a secure authentication system.

// MARK: - Login View
struct LoginView: View {
    let student: Student
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                MountainlandColors.platinum.ignoresSafeArea()
                
                Image("MountainlandLogo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .opacity(0.1)
                    .offset(y: 50)
                
                VStack(spacing: 0) {
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
                    
                    ScrollView {
                        VStack(alignment: .center, spacing: 24) {
                            Text("Welcome back, \(student.firstName)!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 24)
                            
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
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .textContentType(.password)
                            }
                            .padding(.horizontal, 16)
                            
                            Button("Forgot Password?") {
                                // Handle forgot password
                            }
                            .font(.subheadline)
                            .foregroundColor(MountainlandColors.smokeyBlack)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                            
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
                                .disabled(email.isEmpty || password.isEmpty)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .alert("Login Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(isPresented: $isAuthenticated) {
                CourseSectionView(currentUser: student)
            }
            .onAppear {
                email = student.email
            }
        }
    }
    
    private func authenticateUser() {
        isLoading = true
        
        Task {
            do {
                // Use the real API
                let _ = try await APIController.shared.login(email: email, password: password)
                
                // Update your ViewModels to use real API
                await MainActor.run {
                    isLoading = false
                    isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Login failed: \(error.localizedDescription)"
                    showAlert = true
                    
                    // Fall back to demo authentication if API fails
                    if password == student.password {
                        isAuthenticated = true
                    }
                }
            }
        }
    }
}

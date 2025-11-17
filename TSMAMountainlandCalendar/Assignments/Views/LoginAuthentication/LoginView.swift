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

struct LoginView: View {
    // MARK: - Properties
    let student: Student                  // The student attempting to log in
    @State private var email: String = "" // User's email input
    @State private var password: String = "" // User's password input
    @State private var showAlert = false  // Controls alert presentation
    @State private var alertMessage = ""  // Error message for failed login
    @State private var isAuthenticated = false // Tracks successful authentication
    @Environment(\.dismiss) private var dismiss // Environment value for closing view
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Background Layers
                /// Layered design with background color and watermark logo
                
                // 1. Background color
                MountainlandColors.platinum.ignoresSafeArea()
                
                // 2. Watermark logo
                /// Subtle branding element in background for visual appeal
                Image("MountainlandLogo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                    .opacity(0.1)        // Very subtle for watermark effect
                    .offset(y: 50)       // Positioned slightly lower
                
                // MARK: - Main Content
                /// Foreground content including header, form, and buttons
                VStack(spacing: 0) {
                    // MARK: - Header with Back Button
                    /// Custom navigation bar for returning to previous screen
                    HStack {
                        Button(action: {
                            dismiss()    // Returns to student selection
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                        .padding(.leading, 16)  // Comfortable tap target padding
                        
                        Spacer()  // Pushes content to left edge
                    }
                    .padding(.top, 16)   // Safe area top padding
                    .padding(.bottom, 8) // Small bottom padding
                    
                    // MARK: - Profile Picture
                    /// Large circular avatar showing student initials
                    ZStack {
                        Circle()
                            .fill(MountainlandColors.burgundy2)  // Brand color
                            .frame(width: 100, height: 100)      // Large size for prominence
                        
                        Text(student.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)   // Extra top spacing
                    .padding(.bottom, 16) // Bottom spacing before form
                    
                    // MARK: - Scrollable Form Content
                    /// Allows form to adjust for different screen sizes
                    ScrollView {
                        VStack(alignment: .center, spacing: 24) {
                            // MARK: - Welcome Message
                            /// Personalized greeting using student's first name
                            Text("Welcome back, \(student.firstName)!")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 24)  // Extra spacing before form fields
                            
                            // MARK: - Email Field
                            /// Pre-populated with student's email for convenience
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                TextField("Email", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .textContentType(.emailAddress)  // iOS keyboard optimization
                                    .autocapitalization(.none)       // Email formatting
                            }
                            .padding(.horizontal, 16)  // Side margins
                            
                            // MARK: - Password Field
                            /// Secure input for password protection
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Password")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                SecureField("Password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .textContentType(.password)  // iOS password management
                            }
                            .padding(.horizontal, 16)  // Side margins
                            
                            // MARK: - Forgot Password
                            /// Placeholder for password recovery functionality
                            Button("Forgot Password?") {
                                // Handle forgot password - future implementation
                            }
                            .font(.subheadline)
                            .foregroundColor(MountainlandColors.smokeyBlack)
                            .frame(maxWidth: .infinity, alignment: .trailing)  // Right-aligned
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)  // Spacing before sign-in button
                            
                            // MARK: - Sign In Button
                            /// Prominent button that triggers authentication
                            Button(action: {
                                authenticateUser()  // Validates credentials
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(MountainlandColors.smokeyBlack)
                                    .frame(width: 162, height: 48)  // Fixed button size
                                    .background(MountainlandColors.white)
                                    .cornerRadius(32)  // Pill-shaped button
                                    .shadow(
                                        color: .black.opacity(0.3),
                                        radius: 6,
                                        x: 0,
                                        y: 4
                                    )  // Elevated button appearance
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)  // Top spacing from form fields
                        }
                    }
                }
            }
            .navigationBarHidden(true)  // Custom navigation implementation
            // MARK: - Login Error Alert
            /// Shows error message when authentication fails
            .alert("Login Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            // MARK: - Navigation Destination
            /// Automatically navigates to main app after successful login
            .navigationDestination(isPresented: $isAuthenticated) {
                CourseSectionView(currentUser: student)  // Pass authenticated student to main app
            }
            // MARK: - View Setup
            /// Pre-populates email field when view appears
            .onAppear {
                // Pre-populate with student email for user convenience
                email = student.email
            }
        }
    }
    
    // MARK: - Authentication Method
    /// Validates user credentials against stored student data
    /// In production, this would connect to a secure authentication service
    private func authenticateUser() {
        if password == student.password {
            // MARK: - Successful Login
            /// Password matches - grant access to main application
            isAuthenticated = true
        } else {
            // MARK: - Failed Login
            /// Password doesn't match - show error message
            alertMessage = "Invalid password. Please try again."
            showAlert = true
        }
    }
}

//
//  StudentLoginView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

// MARK: - Student Selection View
/// Displays a list of students for login selection
/// Acts as the entry point to authentication by allowing the user to choose their profile
/// Navigates to LoginView for the selected student

struct StudentLoginView: View {
    // *Callback
    let onLoginSuccess: () -> Void    // Triggered after a successful login
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // *App Header
                // Shared header component without tab navigation
                AppHeader(
                    title: "iOS Development",
                    subtitle: "Fall/Spring - 25/26"
                )
                
                // *Scrollable Student List
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // *Screen Title
                        Text("Select Your Name")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        
                        // *Student Cards
                        LazyVStack(spacing: 16) {
                            
                            // Iterate through demo students defined in Student.swift
                            ForEach(Student.demoStudents) { student in
                                NavigationLink {
                                    
                                    // *Navigate to Login Screen
                                    // Pass the selected student into LoginView
                                    LoginView(
                                        student: student,
                                        onLoginSuccess: onLoginSuccess
                                    )
                                } label: {
                                    
                                    // *Student Profile Card
                                    // Visual representation of the student
                                    StudentProfileCard(student: student)
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default NavigationLink styling
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            // *Global Background
            .background(MountainlandColors.platinum.ignoresSafeArea())
        }
    }
}

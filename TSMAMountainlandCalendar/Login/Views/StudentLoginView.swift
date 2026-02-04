//
//  StudentLoginView.swift
//  TSMAMountainlandCalendar
//
//  Created by AnnElaine on 2/2/26.
//

import SwiftUI

// THIS IS THE VIEW THAT SHOWS THE LIST OF STUDENTS
struct StudentLoginView: View {
    let onLoginSuccess: () -> Void  // ← NO student parameter!
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // App Header without tabs
                AppHeader(
                    title: "iOS Development",
                    subtitle: "Fall/Spring - 25/26"
                )
                
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Select Your Name")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                        
                        LazyVStack(spacing: 16) {
                            // THIS IS WHERE YOU USE THE STUDENT LIST FROM Student.swift
                            ForEach(Student.demoStudents) { student in
                                NavigationLink {
                                    // When a student is tapped, show their LoginView
                                    LoginView(
                                        student: student,  // Pass THIS student
                                        onLoginSuccess: onLoginSuccess
                                    )
                                } label: {
                                    StudentProfileCard(student: student)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .background(MountainlandColors.platinum.ignoresSafeArea())
        }
    }
}


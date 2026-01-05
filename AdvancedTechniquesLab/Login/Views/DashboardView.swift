//
//  DashboardView.swift
//  AdvancedTechniquesLab
//
//  Created by YourName on 1/5/26.
//

import SwiftUI

struct DashboardView: View {
    var username: String
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Welcome, \(username)!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Login Successful")
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                InfoRow(icon: "person.fill", text: "Profile")
                InfoRow(icon: "gear", text: "Settings")
                InfoRow(icon: "bell.fill", text: "Notifications")
                InfoRow(icon: "questionmark.circle", text: "Help")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Dashboard")
        .navigationBarBackButtonHidden(true)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationView {
        DashboardView(username: "TestUser")
    }
}

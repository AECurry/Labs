//
//  SimpleSettingsView.swift
//  TripLogger2App
//
//  Created by AnnElaine on 1/16/26.
//

import SwiftUI

struct SimpleSettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            List {
                Section("Account") {
                    Text("Profile")
                    Text("Privacy")
                    Text("Notifications")
                }
                
                Section("App") {
                    Text("Theme")
                    Text("Language")
                    Text("Units")
                }
                
                Section("About") {
                    Text("Version 1.0")
                    Text("Help & Support")
                    Text("Rate App")
                }
            }
            .listStyle(.insetGrouped)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SimpleSettingsView()
    }
}

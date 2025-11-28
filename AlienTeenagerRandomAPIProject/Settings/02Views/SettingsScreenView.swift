//
//  SettingsScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct SettingsScreenView: View {
    var body: some View {
        ZStack {
            CustomGradientBkg2()
            Text("Settings Coming Soon!")
                .font(.title)
                .foregroundColor(.white)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsScreenView()
    }
}

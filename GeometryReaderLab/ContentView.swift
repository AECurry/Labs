//
//  ContentView.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

// This is the main parent file for the entire app
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ProfileGrid()  // Primary view demonstrating GeometryReader
                .navigationTitle("Team Profiles")  // Sets the navigation bar title
        }
    }
}

#Preview {
    ContentView()
}

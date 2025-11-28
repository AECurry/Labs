//
//  DiscoverScreenView.swift
//  AlienTeenagerRandomAPIProject
//

import SwiftUI

struct DiscoverScreenView: View {
    let onDogsTapped: () -> Void
    let onRepresentativesTapped: () -> Void
    let onNobelTapped: () -> Void
    
    var body: some View {
        ZStack {
            // Layer 1 Background
            CustomGradientBkg2()
            // Layer 2 Stars
            StarsBackground().opacity(0.6)
            
            // Layer 3 Contne
            VStack(spacing: 0) {
                DiscoverGreetingView().frame(height: 200)
                
                VStack(spacing: 40) {
                    DiscoverButton(title: "Dogs", icon: "pawprint") {
                        onDogsTapped()
                    }
                    
                    DiscoverButton(title: "Representatives", icon: "person.2") {
                        onRepresentativesTapped()
                    }
                    
                    DiscoverButton(title: "Nobel Prize Winners", icon: "crown") {
                        onNobelTapped()
                    }
                }
                .padding(.leading, 24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    DiscoverScreenView(
        onDogsTapped: { print("Dogs tapped") },
        onRepresentativesTapped: { print("Reps tapped") },
        onNobelTapped: { print("Nobel tapped") }
    )
}

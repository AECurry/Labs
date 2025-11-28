//
//  HomeScreenView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/19/25.
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        ZStack {
            // Layer 1: Gradient Background
            CustomGradientBkg1.customSunset
            
            // Layer 2: Animated Stars (with opacity control)
            StarsBackground()
                .opacity(0.6)
            
            // Layer 3: Content
            VStack(spacing: 0) {
                Spacer()
                
                GreetingDisplayView()
                    .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeScreenView()
}


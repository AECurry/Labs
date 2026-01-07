//
//  CardDetailView.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

// This view receives data via Profile model and controls its own dismissal.
import SwiftUI

// Data model containing profile information
struct CardDetailView: View {
    let profile: Profile
    
    // Two-way binding to control modal visibility
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        // Full-screen modal overlay with semi-transparent background
        ZStack {
            
            // Dimmed background that dismisses on tap
            Color.black.opacity(0.4)
            
            // Extends to screen edges
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isShowingDetail = false  // Animated dismissal
                    }
                }
            
            // Content card positioned in center of screen
            VStack(spacing: 20) {
                // Profile image using SF Symbols
                Image(systemName: profile.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)  // Consistent branding color
                
                // Profile name as primary title
                Text(profile.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Role/title description
                Text(profile.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Extended bio with secondary styling
                Text(profile.detailedDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Primary action button for explicit dismissal
                Button("Close") {
                    withAnimation(.spring()) {
                        isShowingDetail = false
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(30)  // Inner padding for content breathing room
            .background(
                // Card background with rounded corners
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))  // Adaptive light/dark mode
            )
            .padding(40)  // Outer padding from screen edges
            .transition(.scale.combined(with: .opacity))  // Entry/exit animation
        }
    }
}

// Animation is applied for both tap and button dismissals.

//
//  ProfileCardView.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProfileCardView: View {
    let profile: Profile
    let cardWidth: CGFloat
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) { // Reduced spacing
                Image(systemName: profile.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40) // Smaller image
                    .foregroundColor(.blue)
                    .padding(.top, 8) // Less top padding
                
                Text(profile.name)
                    .font(.subheadline) // Smaller font
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2) // Allow 2 lines for long names
                    .minimumScaleFactor(0.8) // Shrink text if needed
                
                Text(profile.description)
                    .font(.caption) // Smaller font
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                VStack(spacing: 4) { // Reduced spacing
                    Text(isExpanded ? "Tap for details" : "Tap to expand")
                        .font(.caption2) // Smallest font
                        .foregroundColor(isExpanded ? .blue : .gray)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption2)
                        .foregroundColor(isExpanded ? .blue : .gray)
                }
                .padding(.bottom, 4)
            }
            .frame(width: cardWidth, height: isExpanded ? 140 : 120) // Much smaller heights
            .modifier(ProfileCardModifier())
            .scaleEffect(isExpanded ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

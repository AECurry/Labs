//
//  ProfileCardModifier.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

// This custom ViewModifier encapsulates card styling to ensure
// visual consistency across all profile cards in the application.
import SwiftUI

struct ProfileCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()  // Internal spacing between content and card edges
            .background(
                // Card background with rounded corners and subtle shadow
                RoundedRectangle(cornerRadius: 16)  // Consistent corner radius
                    .fill(Color(.systemBackground))  // Adapts to light/dark mode
                    .shadow(
                        color: Color.black.opacity(0.1), 
                        radius: 5,
                        x: 0, y: 2
                    )
            )
    }
}


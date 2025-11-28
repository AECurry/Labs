//
//  RepresentativeContentStack.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/23/25.
//

import SwiftUI

struct RepresentativeContentStack: View {
    // Data - receives state from parent (RepresentativeScreenView)
    let representatives: [Representative]
    let isLoading: Bool
    let error: String?
    let hasSearched: Bool
    let searchedZipCode: String
    
    // Actions - closure to trigger search
    let onSearch: (String) -> Void
    
    // Local state for the text field input
    @State private var zipCodeInput: String = ""
    
    var body: some View {
        // GeometryReader gives us access to the screen size for proportional layouts
        GeometryReader { geometry in
            VStack(spacing: 0) {  // spacing: 0 means no space between header and results
                
                // ========== FIXED HEADER SECTION ==========
                VStack(spacing: 48) {  // Space between title and search bar
                    
                    // Title text
                    Text("Find Your Representatives")
                        .font(.system(size: 26, weight: .bold))  // Controls title size
                        .foregroundColor(.white)  // Text color
                    
                    // Search box and button (from separate file)
                    RepresentativeSearchSection(
                        zipCode: $zipCodeInput,
                        isLoading: isLoading,
                        onSearch: {
                            onSearch(zipCodeInput)
                        }
                    )
                    
                    // Error message (only shows if error exists)
                    if let error = error {
                        Text(error)
                            .font(.subheadline)  // Error text size
                            .foregroundColor(.red)  // Error text color
                            .padding(.horizontal)  // Left/right padding
                    }
                }
                .frame(height: geometry.size.height * 0.35)  // Header takes 35% of screen height
                .padding(.top, geometry.safeAreaInsets.top + 60)  // Space from top (60pts below notch)
                .padding(.bottom, 8)  // Space between header and results (20pts)
                .background(Color.clear)  // Transparent background
                
                // ========== SCROLLABLE RESULTS SECTION ==========
                RepresentativeListSection(
                    representatives: representatives,
                    hasSearched: hasSearched,
                    searchedZipCode: searchedZipCode
                )
                .frame(height: geometry.size.height * 0.65)  // Results take 65% of screen height
            }
        }
        .ignoresSafeArea(.container, edges: .top)  // Allows content to extend under the notch
    }
}

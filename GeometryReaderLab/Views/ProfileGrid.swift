//
//  ProfileGrid.swift
//  GeometryReaderLab
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

/// A responsive grid layout that displays profile cards in a 2-column (portrait)
/// or 3-column (landscape) format using GeometryReader for dynamic sizing
struct ProfileGrid: View {
    
    // MARK: - Environment Properties
    
    /// Monitors device orientation changes (compact = landscape, regular = portrait)
    /// This is more reliable than comparing width/height for orientation detection
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // MARK: - State Properties
    
    /// Tracks which card is currently expanded for the detail view overlay
    /// nil = no card expanded, UUID = specific card is expanded
    @State private var expandedCardId: UUID?
    
    // MARK: - Data Properties
    
    /// Array of profile data to display in the grid
    private let profiles = Profile.sampleData
    
    // MARK: - Computed Properties
    
    /// Dynamically determines number of columns based on device orientation
    /// - Returns: 3 columns for landscape (compact vertical), 2 columns for portrait (regular vertical)
    private var columnCount: Int {
        verticalSizeClass == .compact ? 3 : 2
    }
    
    /// Calculates the total number of rows needed to display all profiles
    /// Uses ceil() to ensure partial rows are counted (e.g., 8 items / 3 columns = 3 rows)
    private var numberOfRows: Int {
        Int(ceil(Double(profiles.count) / Double(columnCount)))
    }
    
    // MARK: - Body
    
    var body: some View {
        // GeometryReader provides access to parent view's size for responsive calculations
        GeometryReader { geometry in
            ZStack {
                // BACKGROUND LAYER
                // Semi-transparent blue background visible between cards
                Color.blue.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                // CONTENT LAYER
                ScrollView {
                    // VStack contains all rows with consistent 16pt vertical spacing
                    VStack(spacing: 16) {
                        // Create each row of the grid
                        ForEach(0..<numberOfRows, id: \.self) { row in
                            makeRow(row: row, geometry: geometry)
                        }
                    }
                    // Add padding around the grid
                    .padding(.horizontal, 16)  // 16pt on left and right
                    .padding(.top, 8)          // Reduced top padding to move content up
                    .padding(.bottom, 16)      // Bottom padding for scrolling space
                }
            }
            // OVERLAY LAYER
            // Shows expanded card detail view on top of everything when a card is tapped
            .overlay(
                Group {
                    // Only show detail view if a card is expanded
                    if let expandedProfile = profiles.first(where: { $0.id == expandedCardId }) {
                        CardDetailView(
                            profile: expandedProfile,
                            // Two-way binding allows CardDetailView to dismiss itself
                            isShowingDetail: Binding(
                                get: { expandedCardId != nil },
                                set: { if !$0 { expandedCardId = nil } }
                            )
                        )
                    }
                }
            )
        }
    }
    
    // MARK: - Helper Methods
    
    /// Builds a single row of the grid with proper card sizing and alignment
    /// - Parameters:
    ///   - row: The row index (0-based)
    ///   - geometry: GeometryProxy providing parent view dimensions
    /// - Returns: A view containing cards for this row with proper spacing
    @ViewBuilder
    private func makeRow(row: Int, geometry: GeometryProxy) -> some View {
        // STEP 1: Calculate card dimensions based on available space
        
        let spacing: CGFloat = 40  // Horizontal space between cards
        let padding: CGFloat = 32  // Total padding (16pt on each side)
        
        // Total space consumed by gaps between cards
        // Example: 3 columns = 2 gaps = 2 * 40 = 80pts of spacing
        let totalSpacing = CGFloat(columnCount - 1) * spacing
        
        // Available width = screen width - side padding - spacing between cards
        let calculatedWidth = (geometry.size.width - padding - totalSpacing) / CGFloat(columnCount)
        
        // STEP 2: Apply maximum width constraints to prevent cards from getting too large
        let maxWidth: CGFloat = columnCount == 2 ? 145 : 115
        let cardWidth = min(calculatedWidth, maxWidth)
        
        // STEP 3: Calculate which profiles belong in this row
        let startIndex = row * columnCount  // First profile index for this row
        
        // STEP 4: Build the row using HStack
        HStack(spacing: spacing) {
            // Loop through ALL column positions (ensures every row has same structure)
            ForEach(0..<columnCount, id: \.self) { col in
                let index = startIndex + col  // Actual profile index
                
                if index < profiles.count {
                    // REAL CARD: Profile exists at this position
                    ProfileCardView(
                        profile: profiles[index],
                        // KEY TRICK: Pass width - 12 to create visible 12pt gap
                        // The card is 12pts narrower than its container
                        cardWidth: cardWidth - 12,
                        isExpanded: expandedCardId == profiles[index].id,
                        onTap: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                // Toggle expansion: if already expanded, collapse it
                                expandedCardId = (expandedCardId == profiles[index].id) ? nil : profiles[index].id
                            }
                        }
                    )
                    // Container frame is full cardWidth, but card inside is smaller
                    .frame(width: cardWidth)
                    .transition(.scale.combined(with: .opacity))
                } else {
                    // INVISIBLE PLACEHOLDER: No profile at this position (incomplete row)
                    // This maintains grid alignment by reserving space
                    Color.clear
                        .frame(width: cardWidth, height: 1)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ProfileGrid()
            .navigationTitle("Team Profiles")
    }
}

/*
 KEY CONCEPTS DEMONSTRATED:
 
 1. GEOMETRY READER:
    - Provides parent view dimensions for responsive calculations
    - Recalculates automatically when device rotates
 
 2. SIZE CLASS:
    - verticalSizeClass detects orientation more reliably than width/height comparison
    - compact = landscape, regular = portrait
 
 3. MANUAL GRID LAYOUT:
    - Uses VStack (rows) + HStack (columns) instead of LazyVGrid
    - Gives precise control over sizing and spacing
 
 4. ALIGNMENT SOLUTION:
    - Every row loops through ALL column positions (0..<columnCount)
    - Uses invisible placeholders for empty positions
    - Ensures all rows have identical structure = perfect alignment
 
 5. VISIBLE GAP TRICK:
    - Card container: cardWidth
    - Actual card: cardWidth - 12
    - Result: 12pt visible gap between cards
 
 6. DYNAMIC CALCULATION:
    - Card width = (screen width - padding - spacing) / columns
    - Adjusts automatically to any screen size
    - Max width constraints prevent oversized cards
 */

//
//  ItemCellView.swift
//  TDDStubLab
//
//  Created by AnnElaine on 1/26/26.
//

import SwiftUI

// Individual cell view that displays a single store item in the list
struct ItemCellView: View {
    // MARK: - Properties
    
    // The store item data to display (passed in from parent view)
    let item: StoreItem
    
    // Closure that gets called when the play button is pressed
    // This allows the parent view to handle the preview playback logic
    let onPlayButtonPressed: () -> Void

    // MARK: - Body
    
    var body: some View {
        // Horizontal stack to arrange content left to right
        HStack {
            // MARK: - Artwork Section
            
            // Check if the item has an artwork URL
            if let url = item.artworkURL {
                // AsyncImage loads and displays remote images asynchronously
                AsyncImage(url: url) { image in
                    // Success state: image loaded successfully
                    image
                        .resizable()                    // Allow image to be resized
                        .aspectRatio(contentMode: .fit) // Maintain aspect ratio while fitting frame
                } placeholder: {
                    // Loading state: show placeholder while image loads
                    Image(systemName: "photo")          // System photo icon
                        .resizable()                    // Make icon resizable
                        .foregroundColor(.gray)         // Gray color for placeholder
                }
                .frame(width: 75, height: 75)  // Fixed size for artwork
                .cornerRadius(8)               // Rounded corners for better appearance
            } else {
                // Fallback: show placeholder icon if no artwork URL exists
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.gray)
            }
            
            // MARK: - Text Information Section
            
            // Vertical stack for title and artist information
            VStack(alignment: .leading, spacing: 8) {
                // Item name/title
                Text(item.name)
                    .font(.headline)        // Prominent text style
                    .lineLimit(2)           // Allow up to 2 lines with truncation
                
                // Artist/creator name
                Text(item.artist)
                    .font(.subheadline)     // Smaller, less prominent text
                    .foregroundColor(.secondary)  // Gray color for less emphasis
                    .lineLimit(1)           // Single line with truncation
            }
            
            // MARK: - Spacing
            
            // Flexible space that pushes content to the left and right edges
            Spacer()
            
            // MARK: - Play Button Section
            
            // Only show play button if the item has a preview URL
            if item.previewUrl != nil {
                Button(action: onPlayButtonPressed) {
                    // Play button icon
                    Image(systemName: "play.circle")
                        .font(.title2)              // Medium-sized icon
                        .foregroundColor(.blue)     // Standard iOS blue color
                }
                // Borderless style prevents default button styling in Lists
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        // Add vertical padding inside each cell for better spacing
        .padding(.vertical, 8)
    }
}


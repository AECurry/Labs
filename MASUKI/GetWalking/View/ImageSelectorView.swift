//
//  ImageSelectorView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

// ==========================================
// MARK: - IMAGE SELECTOR VIEW
// ==========================================
/// Screen for users to select different images
/// Located in the "More" section of the app
/// Shows all available images in categorized grid

struct ImageSelectorView: View {
    // MARK: - STATE & ENVIRONMENT
    /// Currently selected image ID (bound to UserDefaults)
    @AppStorage("selectedImageId") private var selectedImageId: String = "koi"
    
    /// Dismiss handler for closing the sheet
    @Environment(\.dismiss) private var dismiss
    
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Loop through all image categories (if you add them later)
                    // For now, show all images in one grid
                    ImageGridSection(
                        selectedImageId: selectedImageId,
                        onSelect: { newImageId in
                            selectedImageId = newImageId  // Save selection
                            dismiss()                     // Close sheet
                        }
                    )
                    
                    // Live preview of selected image
                    ImagePreviewSection(selectedImageId: selectedImageId)
                }
                .padding()
            }
            .background(MasukiColors.adaptiveBackground)  // App background
            .navigationTitle("Select Image")              // Screen title
            .navigationBarTitleDisplayMode(.inline)       // Compact title
            .toolbar {
                // Done button to close
                Button("Done") { dismiss() }
                    .foregroundColor(MasukiColors.mediumJungle)  // Green color
            }
        }
    }
}


// ==========================================
// MARK: - IMAGE GRID SECTION
// ==========================================
/// Grid of all available images
/// Two-column layout for mobile
/// Handles selection with visual feedback

struct ImageGridSection: View {
    let selectedImageId: String
    let onSelect: (String) -> Void
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),  // Column 1
                GridItem(.flexible(), spacing: 16)   // Column 2
            ],
            spacing: 16  // Space between rows
        ) {
            // Show ALL available images
            ForEach(AnimatedImageLibrary.availableImages) { config in
                ImageOptionCard(
                    config: config,
                    isSelected: selectedImageId == config.id,
                    onSelect: { onSelect(config.id) }
                )
            }
        }
        .padding(.horizontal, 20)  // Side padding
    }
}


// ==========================================
// MARK: - IMAGE OPTION CARD
// ==========================================
/// Individual image selection card
/// Tappable button with preview image
/// Shows selection state visually

struct ImageOptionCard: View {
    let config: AnimatedImageConfig
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 12) {
                // Image preview
                Image(config.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)  //  Consistent height
                    .cornerRadius(12)    //  Rounded corners
                    .overlay(
                        // Green border when selected
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected ? MasukiColors.mediumJungle : Color.clear,
                                lineWidth: 3
                            )
                    )
                
                // Image name and description
                VStack(spacing: 4) {
                    Text(config.name)
                        .font(.custom("Inter-SemiBold", size: 14))
                        .foregroundColor(MasukiColors.adaptiveText)
                    
                    Text(config.description)
                        .font(.custom("Inter-Regular", size: 11))
                        .foregroundColor(MasukiColors.coffeeBean)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)  // Limit to 2 lines
                }
                
                // Selected badge
                if isSelected {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                        Text("Selected")
                            .font(.custom("Inter-SemiBold", size: 11))
                    }
                    .foregroundColor(MasukiColors.mediumJungle)
                }
            }
            .padding(12)
            .background(
                // Subtle background for card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.08))
            )
        }
        .buttonStyle(.plain)  // Remove default button styling
    }
}


// ==========================================
// MARK: - IMAGE PREVIEW SECTION
// ==========================================
/// Live animated preview of selected image
/// Shows actual animation at smaller scale
/// Helps users preview before selecting

struct ImagePreviewSection: View {
    let selectedImageId: String
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Preview")
                .font(.custom("Inter-SemiBold", size: 18))
                .foregroundColor(MasukiColors.adaptiveText)
            
            if let config = AnimatedImageLibrary.getImage(byId: selectedImageId) {
                Image(config.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)  // Preview size
                    .cornerRadius(16)                // Rounded corners
                    .rotationEffect(.degrees(rotation))  // Rotation
                    .scaleEffect(scale)                  // Scale
                    .shadow(
                        color: .black.opacity(0.15),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
                    .onAppear {
                        startPreviewAnimation(config: config)
                    }
                    .id(config.id)  // Force restart when image changes
            }
        }
        .padding(.top, 20)
    }
    
    /// Start preview animation
    private func startPreviewAnimation(config: AnimatedImageConfig) {
        // Rotation animation
        withAnimation(
            .linear(duration: config.rotationSpeed)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
        
        // 📏 Scale animation
        withAnimation(
            .easeInOut(duration: config.scaleSpeed)
                .repeatForever(autoreverses: true)
        ) {
            scale = config.maxScale
        }
    }
}


// ==========================================
// MARK: - PREVIEW
// ==========================================
/// Development preview
/// Shows the image selector in isolation

#Preview {
    ImageSelectorView()
}

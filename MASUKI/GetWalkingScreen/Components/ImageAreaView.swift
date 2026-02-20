//
//  ImageAreaView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

// ==========================================
// MARK: - IMAGE AREA VIEW
// ==========================================
/// Displays the animated image on the Get Walking screen
/// Handles BOTH rotation and scale animations
/// Uses AnimatedImageConfig as SINGLE SOURCE for animation settings
/// Only handles LAYOUT (positioning, sizing) - animation comes from config

struct ImageAreaView: View {
    // MARK: - Image Selection State
    /// Stores which image is currently selected (bound to UserDefaults)
    /// Defaults to "koi" on first app launch
    @AppStorage("selectedImageId") private var selectedImageId: String = "koi"
    
    /// Holds the current image configuration loaded from AnimatedImageLibrary
    /// This updates automatically when selectedImageId changes
    @State private var currentConfig: AnimatedImageConfig?
    
    
    // MARK: - Layout Controls (User Customizable via LayoutCustomizationView)
    /// These properties control the visual layout and positioning of the image
    /// They are separate from animation settings and are managed independently
    
    /// Space above the image (negative values move the image upward)
    @AppStorage("imageTopPadding") private var topPadding: Double = 0
    
    /// Space below the image (positive values move the image downward)
    @AppStorage("imageBottomPadding") private var bottomPadding: Double = 24
    
    /// Space on left and right sides of the image
    @AppStorage("imageHorizontalPadding") private var horizontalPadding: Double = 0
    
    /// Width of the image container in points
    @AppStorage("imageWidth") private var width: Double = 380
    
    /// Height of the image container in points
    @AppStorage("imageHeight") private var height: Double = 380
    
    /// Radius for rounded corners of the image
    @AppStorage("imageCornerRadius") private var cornerRadius: Double = 20
    
    /// Blur radius for the shadow effect
    @AppStorage("imageShadowRadius") private var shadowRadius: Double = 12
    
    /// Opacity of the shadow (0.0 = transparent, 1.0 = solid)
    @AppStorage("imageShadowOpacity") private var shadowOpacity: Double = 0.15
    
    
    // MARK: - Animation State Variables
    /// Tracks the current rotation angle for the animation (0° to 360°)
    @State private var rotation: Double = 0
    
    /// Tracks the current scale multiplier for the animation (1.0 = normal size)
    @State private var scale: CGFloat = 1.0
    
    
    // MARK: - View Body
    var body: some View {
        // Display the current image using its imageName from the config
        Image(currentConfig?.imageName ?? "JapaneseKoi")
            .resizable()                    // Allow the image to be resized
            .scaledToFit()                  // Maintain aspect ratio while fitting frame
            
            // Apply user-customized size from LayoutCustomizationView
            .frame(width: width, height: height)
            
            // Apply rounded corners with user-customized radius
            .cornerRadius(cornerRadius)
            
            // Apply rotation animation if enabled in the config
            .rotationEffect(.degrees(currentConfig?.isRotationEnabled == true ? rotation : 0))
            
            // Apply scale animation if enabled in the config
            .scaleEffect(currentConfig?.isScaleEnabled == true ? scale : 1.0)
            
            // Add shadow with user-customized properties
            .shadow(
                color: .black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,  // No horizontal offset
                y: 4   // Slight downward offset for natural shadow
            )
            
            // Apply user-customized padding for positioning
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .padding(.horizontal, horizontalPadding)
            
            // MARK: - View Lifecycle Events
            
            // When the view appears, load config and start animations
            .onAppear {
                loadCurrentConfig()    // Load the image configuration
                startAnimations()      // Begin rotation and scale animations
            }
            
            // When the selected image changes, update config and restart animations
            // Using new onChange syntax for iOS 17+
            .onChange(of: selectedImageId) { oldValue, newValue in
                loadCurrentConfig()    // Load new image configuration
                restartAnimations()    // Restart animations with new settings
            }
    }
    
    
    // MARK: - Private Helper Methods
    
    /// Loads the current image configuration from AnimatedImageLibrary
    /// Uses selectedImageId to find the correct configuration
    private func loadCurrentConfig() {
        currentConfig = AnimatedImageLibrary.getImage(byId: selectedImageId)
    }
    
    /// Starts both rotation and scale animations using settings from currentConfig
    /// Only starts animations that are enabled in the configuration
    private func startAnimations() {
        // Exit if no configuration is loaded
        guard let config = currentConfig else { return }
        
        // Rotation Animation
        if config.isRotationEnabled {
            withAnimation(
                .linear(duration: config.rotationSpeed)  // Use speed from config
                    .repeatForever(autoreverses: false)  // Continue indefinitely
            ) {
                rotation = 360  // Rotate a full circle
            }
        }
        
        // Scale Animation
        if config.isScaleEnabled {
            // Start at the minimum scale
            scale = config.minScale
            
            withAnimation(
                .easeInOut(duration: config.scaleSpeed)  // Use speed from config
                    .repeatForever(autoreverses: true)   // Pulse back and forth
            ) {
                scale = config.maxScale  // Grow to maximum scale
            }
        }
    }
    
    /// Restarts animations from the beginning
    /// Used when the image changes or when settings are updated
    private func restartAnimations() {
        rotation = 0    // Reset rotation to starting position
        scale = 1.0     // Reset scale to normal size
        startAnimations()  // Start fresh with new settings
    }
}


// MARK: - Preview
// Development preview showing the ImageAreaView with proper background
struct ImageAreaView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Replace MasukiColors.adaptiveBackground with your actual background color
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
            
            ImageAreaView()
        }
    }
}


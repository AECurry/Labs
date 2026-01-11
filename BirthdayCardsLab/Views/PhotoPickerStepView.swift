//
//  PhotoPickerStepView.swift
//  BirthdayCardsLab
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI
import PhotosUI

struct PhotoPickerStepView: View {
    @Environment(CardCreationCoordinator.self) private var coordinator
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    // Sample images from Assets.xcassets
    private let sampleImages = [
        ("Balloons", "BirthdayBalloons"),
        ("Cake", "BirthdayCake"),
        ("Bunny", "BunnyAndSign"),
        ("CompanyParty", "CompanyBirthdayParty"),
        ("Presents", "Presents"),
        ("Student", "StudentBirthday")
    ]
    
    var body: some View {
        VStack(spacing: 28) {
            // Progress dots at top
            ProgressDotsView(
                currentStep: coordinator.currentStep.rawValue,
                totalSteps: CreationStep.allCases.count
            )
            .padding(.top, 10)
            .padding(.horizontal) // Add horizontal padding here
            
            // Photo display area
            ZStack {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(width: 300, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("No photo selected")
                                    .foregroundColor(.gray)
                            }
                        )
                }
            }
            
            // OPTION 1: Sample photos from app bundle
            VStack(alignment: .leading, spacing: 10) {
                Text("Sample Party Photos")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(sampleImages, id: \.1) { title, imageName in
                            Button(action: {
                                selectSampleImage(named: imageName)
                            }) {
                                VStack(spacing: 5) {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                        )
                                    
                                    Text(title)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .frame(width: 80)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, -5) // Adjust for scroll view padding
            }
            .padding(.horizontal) // Add padding to this container
            
            // OR divider
            HStack {
                VStack { Divider() }
                Text("OR")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 10)
                VStack { Divider() }
            }
            .padding(.horizontal)
            
            // OPTION 2: Choose from photo library (original PhotosPicker)
            VStack(spacing: 15) {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Choose from Your Photos", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Skip button with fixed spacing
                Button("Skip Photo") {
                    coordinator.navigateToNextStep()
                }
                .foregroundColor(.secondary)
                .padding(.bottom, 10) // Add bottom padding to skip button
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Navigation buttons at bottom
            StepNavigationView()
        }
        // REMOVE the general .padding() and use specific padding instead
        .padding(.vertical, 16) // Only vertical padding, no horizontal
        .navigationTitle("Add Party Photo")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    coordinator.card.imageData = data
                    if let uiImage = UIImage(data: data) {
                        selectedImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
        .onAppear {
            // Load existing image if available
            if let imageData = coordinator.card.imageData,
               let uiImage = UIImage(data: imageData) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }
    
    // Helper function to select sample image
    private func selectSampleImage(named imageName: String) {
        // Clear any PhotosPicker selection
        selectedPhoto = nil
        
        // Use the bundled image
        if let uiImage = UIImage(named: imageName) {
            // Convert UIImage to Data for storage
            if let imageData = uiImage.jpegData(compressionQuality: 0.8) {
                coordinator.card.imageData = imageData
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }
}

#Preview {
    let coordinator = CardCreationCoordinator()
    
    return PhotoPickerStepView()
        .environment(coordinator)
}

//
//  PhotoPlaceholderSection.swift
//  GamesTrackerProject#9
//
//  Created by AnnElaine on 12/16/25.
//

import SwiftUI

struct PhotoPlaceholderSection: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Profile Image Placeholder
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.fnBlue, lineWidth: 2)
                    )
            } else {
                ZStack {
                    Circle()
                        .fill(Color.fnGray3)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.fnGray1)
                }
            }
            
            // Add Photo Button
            Button {
                showImagePicker = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: selectedImage == nil ? "camera.fill" : "photo.fill")
                    Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                }
                .font(.subheadline)
                .foregroundColor(.fnBlue)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .sheet(isPresented: $showImagePicker) {
            // We'll implement photo picker later
            // For now, just show a placeholder
            PhotoPickerPlaceholder()
        }
    }
}

struct PhotoPickerPlaceholder: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 60))
                    .foregroundColor(.fnGray1)
                
                Text("Photo Picker")
                    .font(.title2)
                    .foregroundColor(.fnWhite)
                
                Text("In a real app, this would show the photo picker")
                    .font(.body)
                    .foregroundColor(.fnGray1)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Button("Dismiss") {
                    dismiss()
                }
                .padding()
                .background(Color.fnBlue)
                .foregroundColor(.fnWhite)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding()
            .background(Color(red: 0.08, green: 0.0, blue: 0.15))
            .navigationTitle("Select Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.fnWhite)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.0, blue: 0.15)
            .ignoresSafeArea()
        
        PhotoPlaceholderSection()
            .padding()
    }
}

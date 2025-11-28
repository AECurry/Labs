//
//  CurrentDogView.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct CurrentDogView: View {
    let dog: CurrentDog?
    let onNameChange: (String) -> Void
    var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            if let dog = dog {
                // Dog content
                DogImageView(image: dog.image)
                DogNameTextField(name: dog.name, onNameChange: onNameChange)
            } else if isLoading {
                DogLoadingView()
            } else {
                DogEmptyStateView()
            }
        }
    }
}

// ADD THESE MISSING COMPONENTS:
private struct DogImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

private struct DogNameTextField: View {
    let name: String
    let onNameChange: (String) -> Void
    
    var body: some View {
        TextField("Name your dog...", text: Binding(
            get: { name },
            set: { onNameChange($0) }
        ))
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.horizontal)
    }
}

private struct DogLoadingView: View {
    var body: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color.alabasterGray.opacity(0.8))
            .cornerRadius(16)
    }
}

private struct DogEmptyStateView: View {
    var body: some View {
        Text("No dog loaded")
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color.alabasterGray.opacity(0.8))
            .cornerRadius(16)
    }
}


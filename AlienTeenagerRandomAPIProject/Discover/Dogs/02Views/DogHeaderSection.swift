//
//  DogHeaderSection.swift
//  AlienTeenagerRandomAPIProject
//
//  Created by AnnElaine on 11/21/25.
//

import SwiftUI

struct DogHeaderSection: View {
    let currentDog: CurrentDog?
    let isLoading: Bool
    let canSave: Bool
    let onNameChange: (String) -> Void
    let onNewImageTapped: () -> Void
    let onSaveToListTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            CurrentDogView(
                dog: currentDog,
                onNameChange: onNameChange,
                isLoading: isLoading
            )
            .padding(.horizontal)
            .padding(.top)
            
            DogControlsSection(
                isLoading: isLoading,
                canSave: canSave,
                onNewImageTapped: onNewImageTapped,
                onSaveToListTapped: onSaveToListTapped
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.clear)
    }
}


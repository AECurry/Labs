//
//  SimpleImagePicker.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct SimpleImagePicker: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedImageName") private var selectedImageName: String = "JapaneseKoi"
    
    let images = [
        ("JapaneseKoi", "Japanese Koi"),
        ("WalkingPerson", "Walking Person"),
        ("KanjiMatsukiIcon", "Kanji Icon"),
        // Add your actual image names here
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(images, id: \.0) { imageName, displayName in
                    Button(action: {
                        selectedImageName = imageName
                        dismiss()
                    }) {
                        HStack {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                            
                            Text(displayName)
                                .font(.custom("Inter-Regular", size: 16))
                                .foregroundColor(MasukiColors.adaptiveText)
                            
                            Spacer()
                            
                            if selectedImageName == imageName {
                                Image(systemName: "checkmark")
                                    .foregroundColor(MasukiColors.mediumJungle)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Select Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
    }
}


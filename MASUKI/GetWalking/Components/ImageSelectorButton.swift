//
//  ImageSelectorButton.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct ImageSelectorButton: View {
    @State private var showImagePicker = false
    
    var body: some View {
        Button(action: { showImagePicker = true }) {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 24))
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text("Change Home Screen Image")
                    .font(.custom("Inter-Regular", size: 18))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(MasukiColors.coffeeBean)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showImagePicker) {
            SimpleImagePicker()
        }
    }
}

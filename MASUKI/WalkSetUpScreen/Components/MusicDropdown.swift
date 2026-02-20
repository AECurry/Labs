//
//  MusicDropdown.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct MusicDropdown: View {
    @Binding var selectedMusic: MusicOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Select Music")
                    .font(.custom("Inter-SemiBold", size: 18))
                    .foregroundColor(MasukiColors.adaptiveText)
                
                Spacer()
                
                Text("Coming Soon")
                    .font(.custom("Inter-Regular", size: 12))
                    .foregroundColor(MasukiColors.coffeeBean)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(MasukiColors.mediumJungle.opacity(0.1))
                    )
            }
            
            HStack {
                Image(systemName: "music.note")
                    .foregroundColor(MasukiColors.mediumJungle)
                
                Text("Music selection will be available soon")
                    .font(.custom("Inter-Regular", size: 14))
                    .foregroundColor(MasukiColors.coffeeBean)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(MasukiColors.mediumJungle.opacity(0.3), lineWidth: 1)
            )
            .opacity(0.7)
        }
    }
}

#Preview {
    MusicDropdown(selectedMusic: .constant(.placeholder))
        .padding()
        .background(MasukiColors.adaptiveBackground)
}

#Preview {
    MusicDropdown(selectedMusic: .constant(.zenGarden))
        .padding()
        .background(MasukiColors.adaptiveBackground)
}


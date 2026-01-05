//
//  MoreView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        MoreScreen()
    }
}

struct MoreScreen: View {
    var body: some View {
        ZStack {
            MasukiColors.adaptiveBackground
                .ignoresSafeArea()
            
            VStack {
                Text("More")
                    .font(.custom("Spinnaker-Regular", size: 32))
                    .foregroundColor(MasukiColors.adaptiveText)
                    .padding(.top, 40)
                
                Spacer()
                
                MoreContent()
                
                Spacer()
            }
        }
    }
}

struct MoreContent: View {
    var body: some View {
        VStack(spacing: 20) {
            ImageSelectorButton()
            // ... other more options
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    MoreView()
}

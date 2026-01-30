//
//  MoreScreenHeaderView.swift
//  MASUKI
//
//  Created by AnnElaine on 1/9/26.
//

import SwiftUI

struct MoreScreenHeaderView: View {
    @AppStorage("moreHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("moreHeaderBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("moreHeaderHorizontalPadding") private var horizontalPadding: Double = 16
    @AppStorage("moreHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("moreHeaderIconPadding") private var iconPadding: Double = 12
    
    @State private var showCustomization = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: { showCustomization = true }) {
                Image("KanjiMatsukiIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .padding(iconPadding)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.horizontal, horizontalPadding)
        .sheet(isPresented: $showCustomization) {
            // TODO: Create MoreCustomizationView
            Text("More Screen Customization")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    MoreScreenHeaderView()
        .background(MasukiColors.adaptiveBackground)
}

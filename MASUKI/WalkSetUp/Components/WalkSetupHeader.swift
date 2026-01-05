//
//  WalkSetupHeader.swift
//  MASUKI
//
//  Created by AnnElaine on 1/2/26.
//

import SwiftUI

struct WalkSetupHeader: View {
    @AppStorage("walkSetupHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("walkSetupHeaderBottomPadding") private var bottomPadding: Double = 0
    @AppStorage("walkSetupHeaderHorizontalPadding") private var horizontalPadding: Double = 16
    @AppStorage("walkSetupHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("walkSetupHeaderIconPadding") private var iconPadding: Double = 12
    
    let onBack: () -> Void
    @State private var showCustomization = false
    
    var body: some View {
        HStack {
            // Back Button
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(MasukiColors.carbonBlack)
                    .padding(iconPadding)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Kanji Icon (Settings)
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
            // TODO: Create WalkSetupCustomizationView
            Text("Walk Setup Customization")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    WalkSetupHeader(onBack: {})
        .background(MasukiColors.adaptiveBackground)
}

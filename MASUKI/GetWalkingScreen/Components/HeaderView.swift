//
//  HeaderView.swift
//  MASUKI
//
//  Created by AnnElaine on 12/31/25.
//

import SwiftUI

struct HeaderView: View {
    @AppStorage("headerTopPadding") private var topPadding: Double = 0
    @AppStorage("headerBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("headerHorizontalPadding") private var horizontalPadding: Double = 48
    @AppStorage("headerIconSize") private var iconSize: Double = 40
    @AppStorage("headerIconPadding") private var iconPadding: Double = 12
    
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
            LayoutCustomizationView()
        }
    }
}


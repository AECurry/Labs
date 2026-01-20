//
//  ProgressHeader.swift
//  MASUKI
//
//  Created by AnnElaine on 1/6/26.
//

import SwiftUI

struct ProgressHeader: View {
    @AppStorage("progressHeaderTopPadding") private var topPadding: Double = 0
    @AppStorage("progressHeaderBottomPadding") private var bottomPadding: Double = 8
    @AppStorage("progressHeaderHorizontalPadding") private var horizontalPadding: Double = 48
    
    // Internal sizing
    @AppStorage("progressHeaderIconSize") private var iconSize: Double = 40
    @AppStorage("progressHeaderIconPadding") private var iconPadding: Double = 12
    
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
            Text("Progress Customization")
                .presentationDetents([.medium])
        }
    }
}
